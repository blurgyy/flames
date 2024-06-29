use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use blake2::{Blake2b512, Digest};
use clap::Parser;
use num_bigint::BigUint;
use num_traits::{Num, ToPrimitive};
use serde_json::json;
use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;
use std::sync::Arc;

#[derive(Parser)]
#[command(name = "sing_box_rules")]
enum Cli {
    Populate {
        rules_dir: PathBuf,
        cfg_path: PathBuf,
    },
    Serve {
        rules_dir: PathBuf,
        template_json_path: PathBuf,
        userids_path: PathBuf,
        #[arg(long, default_value = "127.0.0.1")]
        host: String,
        #[arg(long, default_value = "2983")]
        port: u16,
    },
}

#[derive(Clone)]
struct User {
    username: String,
    uuid: String,
}

fn txt_as_list(path: &PathBuf) -> Vec<String> {
    fs::read_to_string(path)
        .unwrap()
        .lines()
        .map(|s| s.trim().to_string())
        .collect()
}

fn apply_prepend_char(rules: &[String], prepend_char: &str) -> Vec<String> {
    rules
        .iter()
        .map(|entry| format!("{}{}", prepend_char, entry))
        .collect()
}

fn populate_rules(obj: &serde_json::Value, rules_dir: &PathBuf) -> serde_json::Value {
    match obj {
        serde_json::Value::Object(map) => {
            let mut ret = serde_json::Map::new();
            for (key, value) in map {
                if let serde_json::Value::String(s) = value {
                    if s.starts_with('@') && s.ends_with('@') && s.len() > 2 {
                        let rules_file_specs = s[1..s.len() - 1].trim().replace(',', "+");
                        let rules_file_specs: Vec<&str> = rules_file_specs
                            .split('+')
                            .map(str::trim)
                            .filter(|&s| !s.is_empty())
                            .collect();
                        let mut rules = Vec::new();
                        for file_spec in rules_file_specs {
                            let mut prepend_char = String::new();
                            let file_spec = if file_spec.contains('#') {
                                let parts: Vec<&str> = file_spec.split('#').collect();
                                prepend_char = parts[1].to_string();
                                parts[0]
                            } else {
                                file_spec
                            };
                            if file_spec.contains(':') {
                                let parts: Vec<&str> = file_spec.split(':').collect();
                                let stem = parts[0];
                                let variant = parts[1];
                                let path = rules_dir.join(format!("{}.txt", stem));
                                let prefix = format!("{}:", variant);
                                let mut variant_rules: Vec<String> = txt_as_list(&path)
                                    .into_iter()
                                    .filter(|entry| entry.starts_with(&prefix))
                                    .map(|entry| entry[prefix.len()..].to_string())
                                    .collect();
                                variant_rules = apply_prepend_char(&variant_rules, &prepend_char);
                                rules.extend(variant_rules);
                            } else {
                                let path = rules_dir.join(format!("{}.txt", file_spec));
                                let mut file_rules: Vec<String> = txt_as_list(&path)
                                    .into_iter()
                                    .filter(|entry| !entry.contains(':'))
                                    .collect();
                                file_rules = apply_prepend_char(&file_rules, &prepend_char);
                                rules.extend(file_rules);
                            }
                        }
                        ret.insert(
                            key.clone(),
                            serde_json::Value::Array(
                                rules.into_iter().map(serde_json::Value::String).collect(),
                            ),
                        );
                    } else {
                        ret.insert(key.clone(), value.clone());
                    }
                } else if let serde_json::Value::Object(_) = value {
                    ret.insert(key.clone(), populate_rules(value, rules_dir));
                } else if let serde_json::Value::Array(arr) = value {
                    ret.insert(
                        key.clone(),
                        serde_json::Value::Array(
                            arr.iter().map(|v| populate_rules(v, rules_dir)).collect(),
                        ),
                    );
                } else {
                    ret.insert(key.clone(), value.clone());
                }
            }
            serde_json::Value::Object(ret)
        }
        _ => obj.clone(),
    }
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

        let char_index = &index % BigUint::from(all_choices.len());
        let char = all_choices[char_index.to_usize().unwrap()];
        handle.push(char);

        pos = (&index % hashed_hex.len()).to_usize().unwrap_or(0);
        old_index = index;
    }

    handle
}

fn replace_uuid(cfg: &serde_json::Value, uuid: &str) -> serde_json::Value {
    match cfg {
        serde_json::Value::Object(map) => {
            let mut ret = serde_json::Map::new();
            for (key, value) in map {
                if key == "uuid" {
                    ret.insert(key.clone(), serde_json::Value::String(uuid.to_string()));
                } else if let serde_json::Value::Object(_) = value {
                    ret.insert(key.clone(), replace_uuid(value, uuid));
                } else if let serde_json::Value::Array(arr) = value {
                    ret.insert(
                        key.clone(),
                        serde_json::Value::Array(
                            arr.iter().map(|v| replace_uuid(v, uuid)).collect(),
                        ),
                    );
                } else {
                    ret.insert(key.clone(), value.clone());
                }
            }
            serde_json::Value::Object(ret)
        }
        _ => cfg.clone(),
    }
}

fn modify_set_system_proxy(cfg: &serde_json::Value) -> serde_json::Value {
    let mut ret = cfg.clone();
    if let serde_json::Value::Object(map) = &mut ret {
        if let Some(serde_json::Value::Array(inbounds)) = map.get_mut("inbounds") {
            let new_inbounds: Vec<serde_json::Value> = inbounds
                .iter()
                .filter_map(|inbound| {
                    if let serde_json::Value::Object(obj) = inbound {
                        if obj.get("type") == Some(&serde_json::Value::String("tun".to_string())) {
                            return None;
                        }
                        let mut new_obj = obj.clone();
                        if obj.get("type") == Some(&serde_json::Value::String("http".to_string())) {
                            new_obj.insert(
                                "set_system_proxy".to_string(),
                                serde_json::Value::Bool(true),
                            );
                        }
                        Some(serde_json::Value::Object(new_obj))
                    } else {
                        Some(inbound.clone())
                    }
                })
                .collect();
            map.insert(
                "inbounds".to_string(),
                serde_json::Value::Array(new_inbounds),
            );
        }
    }
    ret
}

fn populate(rules_dir: PathBuf, cfg_path: PathBuf) -> std::io::Result<()> {
    let cfg = fs::read_to_string(&cfg_path)?;
    let cfg: serde_json::Value = serde_json::from_str(&cfg)?;
    let populated = populate_rules(&cfg, &rules_dir);
    fs::write(cfg_path, serde_json::to_string_pretty(&populated)?)?;
    Ok(())
}

async fn serve(
    rules_dir: PathBuf,
    template_path: PathBuf,
    userids_path: PathBuf,
    host: String,
    port: u16,
) -> std::io::Result<()> {
    let template = fs::read_to_string(&template_path)?;
    let template: serde_json::Value = serde_json::from_str(&template)?;
    let populated = populate_rules(&template, &rules_dir);

    let userids = fs::read_to_string(&userids_path)?;
    let handle_to_user: HashMap<String, User> = userids
        .lines()
        .filter(|line| !line.trim().is_empty())
        .map(|line| {
            let parts: Vec<&str> = line.split('=').collect();
            let username = parts[0].to_string();
            let uuid = parts[1].to_string();
            let handle = username_to_handle(&username, 6);
            (handle, User { username, uuid })
        })
        .collect();

    let handle_to_user = Arc::new(handle_to_user);
    let populated = Arc::new(populated);

    HttpServer::new(move || {
        let handle_to_user = handle_to_user.clone();
        let populated = populated.clone();
        App::new()
            .app_data(web::Data::new(handle_to_user))
            .app_data(web::Data::new(populated))
            .route(
                "/api/v1/_handle/{username}/{handle_length}",
                web::get().to(get_handle),
            )
            .route("/{salty_handle}", web::get().to(serve_config))
    })
    .bind((host, port))?
    .run()
    .await
}

async fn get_handle(path: web::Path<(String, usize)>) -> impl Responder {
    let (username, handle_length) = path.into_inner();
    HttpResponse::Ok().json(json!({
        "handle": username_to_handle(&username, handle_length)
    }))
}

async fn serve_config(
    salty_handle: web::Path<String>,
    query: web::Query<HashMap<String, String>>,
    handle_to_user: web::Data<Arc<HashMap<String, User>>>,
    populated: web::Data<Arc<serde_json::Value>>,
) -> impl Responder {
    let set_system_proxy = query
        .get("set_system_proxy")
        .map(|v| v == "true")
        .unwrap_or(false);
    for (handle, user) in handle_to_user.iter() {
        if salty_handle.contains(handle) {
            let cfg = if set_system_proxy {
                modify_set_system_proxy(&populated)
            } else {
                (**populated.into_inner()).clone()
            };
            let cfg_with_uuid = replace_uuid(&cfg, &user.uuid);
            return HttpResponse::Ok().json(cfg_with_uuid);
        }
    }
    HttpResponse::NotFound().finish()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let cli = Cli::parse();

    match cli {
        Cli::Populate {
            rules_dir,
            cfg_path,
        } => populate(rules_dir, cfg_path)?,
        Cli::Serve {
            rules_dir,
            template_json_path,
            userids_path,
            host,
            port,
        } => serve(rules_dir, template_json_path, userids_path, host, port).await?,
    }

    Ok(())
}
