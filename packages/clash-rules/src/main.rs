use actix_web::{web, App, HttpResponse, HttpServer, Responder, middleware::Logger};
use blake2::{Blake2b512, Digest};
use clap::Parser;
use num_bigint::BigUint;
use num_traits::{Num, ToPrimitive};
use serde_json::json;
use std::collections::HashMap;
use std::fs;
use std::sync::Arc;
use log::info;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(long)]
    template: String,

    #[arg(long)]
    users: String,

    #[arg(long, default_value = "127.0.0.1")]
    listen: String,

    #[arg(long, default_value_t = 8000)]
    port: u16,
}

fn username_to_handle(username: &str, handle_length: usize) -> String {
    let mut hasher = Blake2b512::new();
    hasher.update(username.as_bytes());
    let hashed = hasher.finalize();
    let hashed_hex = hex::encode(hashed);

    let all_choices: Vec<char> = (b'0'..=b'9')
        .chain(b'a'..=b'z')
        .chain(b'A'..=b'Z')
        .map(char::from)
        .collect();

    let mut handle = String::new();
    let mut pos = 0;
    let mut old_index = BigUint::from(0u32);

    while handle.len() < handle_length {
        let slice = &hashed_hex[pos..std::cmp::min(pos + 16, hashed_hex.len())];
        let index = BigUint::from_str_radix(&format!("0{}", slice), 16).unwrap()
            ^ (BigUint::from(998_244_353u32) * &old_index);

        let char_index = (&index * &index) % BigUint::from(all_choices.len());
        let char = all_choices[char_index.to_usize().unwrap()];
        handle.push(char);

        pos = (&index % hashed_hex.len()).to_usize().unwrap_or(0);
        old_index = index;
    }

    handle
}

fn load_users(file_path: &str) -> HashMap<String, String> {
    fs::read_to_string(file_path)
        .expect("Failed to read users file")
        .lines()
        .map(|line| {
            let parts: Vec<&str> = line.split('=').collect();
            (parts[0].to_string(), parts[1].to_string())
        })
        .collect()
}

fn prerender_configs(
    template_path: &str,
    users: &HashMap<String, String>,
) -> HashMap<String, String> {
    let template = fs::read_to_string(template_path).expect("Failed to read template file");
    let mut cached_configs = HashMap::new();

    for (name, uuid) in users {
        let config_yaml = template.replace("@@uuid@@", uuid);
        match serde_yaml::from_str::<serde_yaml::Value>(&config_yaml) {
            Ok(yaml_value) => {
                if let Ok(json_value) = serde_json::to_string(&yaml_value) {
                    cached_configs.insert(name.clone(), json_value);
                } else {
                    eprintln!("Error converting YAML to JSON for user {}", name);
                }
            }
            Err(_) => eprintln!("Error parsing YAML for user {}", name),
        }
    }

    cached_configs
}

async fn handle_api_request(path: web::Path<(String, usize)>) -> impl Responder {
    let (name, length) = path.into_inner();
    info!("API request: name={}, length={}", name, length);

    let hash_value = username_to_handle(&name, length);
    HttpResponse::Ok().json(json!({"hash": hash_value}))
}

async fn handle_hash_request(
    hash_prefix: web::Path<String>,
    users: web::Data<Arc<HashMap<String, String>>>,
    cached_configs: web::Data<Arc<HashMap<String, String>>>,
) -> impl Responder {
    info!("Hash request: hash_prefix={}", hash_prefix);

    if hash_prefix.len() < 6 {
        return HttpResponse::BadRequest().finish();
    }

    for (name, _) in users.iter() {
        let computed_hash = username_to_handle(name, hash_prefix.len());
        if computed_hash == *hash_prefix {
            if let Some(config_json) = cached_configs.get(name) {
                return HttpResponse::Ok()
                    .content_type("application/json")
                    .body(config_json.clone());
            } else {
                return HttpResponse::InternalServerError().finish();
            }
        }
    }

    HttpResponse::NotFound().finish()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let args = Args::parse();

    // Initialize the logger
    env_logger::init_from_env(env_logger::Env::default().default_filter_or("info"));

    let users = Arc::new(load_users(&args.users));
    let cached_configs = Arc::new(prerender_configs(&args.template, &users));

    info!("Server running on http://{}:{}", args.listen, args.port);

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::default())
            .app_data(web::Data::new(users.clone()))
            .app_data(web::Data::new(cached_configs.clone()))
            .route(
                "/api/v1/_handle/{name}/{length}",
                web::get().to(handle_api_request),
            )
            .route("/{hash_prefix}", web::get().to(handle_hash_request))
    })
    .bind((args.listen, args.port))?
    .run()
    .await
}
