use clap::Parser;
use std::fs;
use std::io::Write;
use std::process::{Command, Stdio};
use systemd::daemon;
use uuid::Uuid;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Command to run
    #[arg(required = true)]
    command: String,

    /// Arguments for the command
    #[arg(num_args = 0..)]
    args: Vec<String>,

    /// Length of the random suffix for the unit name
    #[arg(short, long, default_value_t = 3)]
    suffix_length: usize,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    setup();

    let args = Args::parse();

    if is_systemd_available() {
        run_with_systemd(&args)
    } else {
        run_without_systemd(&args)
    }
}

fn is_systemd_available() -> bool {
    fs::metadata("/run/systemd/system").is_ok()
}

fn run_with_systemd(args: &Args) -> Result<(), Box<dyn std::error::Error>> {
    let user_flag = if unsafe { libc::geteuid() } != 0 {
        Some("--user")
    } else {
        None
    };

    let unit_name = format!(
        "sdwrap-{}-{}",
        args.command.split('/').last().unwrap_or(&args.command),
        Uuid::new_v4().simple().to_string()[..args.suffix_length].to_string()
    );

    if is_unit_failed(&unit_name, user_flag)? {
        reset_failed_unit(&unit_name, user_flag)?;
    }

    let do_attach = is_unit_active(&unit_name, user_flag)?;

    if do_attach {
        let child = Command::new("systemd-cat")
            .arg(&args.command)
            .args(&args.args)
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()?;

        let pid = child.id();

        if let Err(e) = attach_process_to_unit(&unit_name, pid, user_flag) {
            tracing::error!(
                "Failed to attach new process to '{}.scope': {}",
                unit_name,
                e
            );
            return Err(e.into());
        }
    } else {
        Command::new("systemd-cat")
            .args(&[
                "echo",
                &format!("Starting {}.scope", unit_name),
            ])
            .spawn()?;
        Command::new("systemd-run")
            .args(user_flag)
            .args(&[
                "--scope",
                "--same-dir",
                &format!("--unit={}.scope", unit_name),
                "--property=Delegate=yes",
            ])
            .arg("systemd-cat")
            .arg(&args.command)
            .args(&args.args)
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()?;
    }

    if let Err(e) = daemon::notify(false, [(daemon::STATE_READY, "1")].iter()) {
        tracing::error!("Failed to notify systemd: {}", e);
    }

    if do_attach {
        tracing::info!("Attached command to an existing unit: {}.scope", unit_name);
    } else {
        tracing::info!("Running command as a new unit: {}.scope", unit_name);
    }
    tracing::info!("Command is: `{} {}`", args.command, args.args.join(" "));

    Ok(())
}

fn run_without_systemd(args: &Args) -> Result<(), Box<dyn std::error::Error>> {
    let output_dir = format!("/tmp/sdwrap/{}-{}", args.command, Uuid::new_v4().simple());
    fs::create_dir_all(&output_dir)?;

    let pid_file = format!("{}/pid", &output_dir);
    let stdout_file = format!("{}/stdout", &output_dir);
    let stderr_file = format!("{}/stderr", &output_dir);

    // write stdout to /tmp/sdwrap/stdout, and stderr to /tmp/sdwrap/stderr
    let child = Command::new(&args.command)
        .args(&args.args)
        .stdout(
            fs::OpenOptions::new()
                .create(true)
                .write(true)
                .truncate(true)
                .open(&stdout_file)?,
        )
        .stderr(
            fs::OpenOptions::new()
                .create(true)
                .write(true)
                .truncate(true)
                .open(&stderr_file)?,
        )
        .spawn()?;

    let pid = child.id();

    // Write PID to file
    fs::write(&pid_file, pid.to_string())?;

    tracing::info!(
        "Running command in background. PID: {}, stdout: {}, stderr: {}",
        pid,
        stdout_file,
        stderr_file,
    );
    tracing::info!("To terminate the process, run: kill $(cat {})", pid_file);
    tracing::info!("Command is: `{} {}`", args.command, args.args.join(" "));

    Ok(())
}

fn is_unit_failed(unit_name: &str, user_flag: Option<&str>) -> Result<bool, std::io::Error> {
    let status = Command::new("systemctl")
        .args(user_flag)
        .args(&["is-failed", &format!("{}.scope", unit_name)])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()?;
    Ok(status.success())
}

fn reset_failed_unit(unit_name: &str, user_flag: Option<&str>) -> Result<(), std::io::Error> {
    let status = Command::new("systemctl")
        .args(user_flag)
        .args(&["reset-failed", &format!("{}.scope", unit_name)])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()?;
    if !status.success() {
        return Err(std::io::Error::new(
            std::io::ErrorKind::Other,
            "Failed to reset failed unit",
        ));
    }
    Ok(())
}

fn is_unit_active(unit_name: &str, user_flag: Option<&str>) -> Result<bool, std::io::Error> {
    let status = Command::new("systemctl")
        .args(user_flag)
        .args(&["is-active", &format!("{}.scope", unit_name)])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()?;
    Ok(status.success())
}

fn attach_process_to_unit(
    unit_name: &str,
    pid: u32,
    user_flag: Option<&str>,
) -> Result<(), std::io::Error> {
    let status = Command::new("busctl")
        .args(user_flag)
        .args(&[
            "call",
            "org.freedesktop.systemd1",
            "/org/freedesktop/systemd1",
            "org.freedesktop.systemd1.Manager",
            "AttachProcessesToUnit",
            "ssau",
            &format!("{}.scope", unit_name),
            "/",
            "1",
            &pid.to_string(),
        ])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()?;
    if !status.success() {
        return Err(std::io::Error::new(
            std::io::ErrorKind::Other,
            "Failed to attach process to unit",
        ));
    }
    Ok(())
}

fn setup() {
    if std::env::var("RUST_LOG").is_err() {
        std::env::set_var("RUST_LOG", "info");
    }
    tracing_subscriber::fmt::init();
}
