{ aliyundrive-fuse
, writeText
}: aliyundrive-fuse.overrideAttrs (o: {
  pname = o.pname + "-mobile";
  patches = o.patches or [] ++ [(writeText "allow-mobile-refresh-token.patch" ''
    diff --git a/src/main.rs b/src/main.rs
    index f99ca80..ebee85a 100644
    --- a/src/main.rs
    +++ b/src/main.rs
    @@ -44,6 +44,13 @@ fn main() -> anyhow::Result<()> {
         tracing_subscriber::fmt::init();
     
         let opt = Opt::parse();
    +
    +    let (client_type, actual_refresh_token) = if opt.refresh_token.starts_with("app:") {
    +        ("app", opt.refresh_token[4..].to_string())
    +    } else {
    +        ("web", opt.refresh_token)
    +    };
    +
         let drive_config = if let Some(domain_id) = opt.domain_id {
             DriveConfig {
                 api_base_url: format!("https://{}.api.aliyunpds.com", domain_id),
    @@ -53,13 +60,23 @@ fn main() -> anyhow::Result<()> {
             }
         } else {
             DriveConfig {
    -            api_base_url: "https://api.aliyundrive.com".to_string(),
    -            refresh_token_url: "https://api.aliyundrive.com/token/refresh".to_string(),
    +            api_base_url: (if client_type == "web" {
    +                "https://api.aliyundrive.com"
    +            } else {
    +                "https://auth.aliyundrive.com"
    +            })
    +            .to_string(),
    +            refresh_token_url: (if client_type == "web" {
    +                "https://api.aliyundrive.com/token/refresh"
    +            } else {
    +                "https://auth.aliyundrive.com/v2/account/token"
    +            })
    +            .to_string(),
                 workdir: opt.workdir,
                 app_id: None,
             }
         };
    -    let drive = AliyunDrive::new(drive_config, opt.refresh_token).map_err(|_| {
    +    let drive = AliyunDrive::new(drive_config, actual_refresh_token).map_err(|_| {
             io::Error::new(io::ErrorKind::Other, "initialize aliyundrive client failed")
         })?;
  '')];
})
