use clap::Parser;
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
    let args = Args::parse();

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

    // Unfortunately, we still need to use systemctl for some operations
    // that are not available in the systemd crate
    if is_unit_failed(&unit_name, user_flag)? {
        reset_failed_unit(&unit_name, user_flag)?;
    }

    let do_attach = is_unit_active(&unit_name, user_flag)?;

    if do_attach {
        // Unit is active, attach the new process to it
        let child = Command::new("systemd-cat")
            .arg(&args.command)
            .args(&args.args)
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()?;

        let pid = child.id();

        if let Err(e) = attach_process_to_unit(&unit_name, pid, user_flag) {
            eprintln!(
                "Failed to attach new process to '{}.scope': {}",
                unit_name, e
            );
            return Err(e.into());
        }
    } else {
        // Use systemd-run to create and start the unit
        Command::new("systemd-run")
            .args(user_flag)
            .args(&[
                "--scope",
                "--same-dir",
                &format!("--unit={}.scope", unit_name),
                "--property=Delegate=yes",
            ])
            .arg(&args.command)
            .args(&args.args)
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()?;
    }

    // Notify systemd that we're ready
    if let Err(e) = daemon::notify(false, [(daemon::STATE_READY, "1")].iter()) {
        eprintln!("Failed to notify systemd: {}", e);
    }

    if do_attach {
        println!("Attached command to an existing unit: {}.scope", unit_name);
    } else {
        println!("Running command as a new unit: {}.scope", unit_name);
    }
    println!("Command is: `{} {}`", args.command, args.args.join(" "));

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
