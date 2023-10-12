{ pkgs }: ''
// rune script <https://rune-rs.github.io>
// vim: ft=rust:

pub async fn init() {
    let domestic = Domain::new()
        .add_file("${pkgs.dnsmasq-china-list-domains-only}/share/dnsmasq-china-list-domains-only/apple.txt")?
        .add_file("${pkgs.dnsmasq-china-list-domains-only}/share/dnsmasq-china-list-domains-only/google.txt")?
        .add_file("${pkgs.dnsmasq-china-list-domains-only}/share/dnsmasq-china-list-domains-only/accelerated-domains.txt")?
        .seal();
    Ok(#{
        "geoip": Utils::GeoIp(GeoIp::create_default()?),
        "domestic_domains": Utils::Domain(domestic),
    })
}

// HACK:
//    `rune` script does not support the `contains` method of `&str`
fn contains(parent, sub) {
    parent.len() != parent.replace(sub, "").len()
}
fn name_of(query) {
    query.first_question?.qname.to_str()
}

fn is_ntp(query) {
    let name = name_of(query);
    name.ends_with("ntp.org")
        || name == "time.apple.com"
        || name.ends_with("time.apple.com")
}

fn is_tailscale(query) {
    let name = name_of(query);
    name.ends_with(".ts.net")
}

fn is_zju(query) {
    let name = name_of(query);
    contains(name, "cc98")
        || contains(name, "nexushd")
        || name.ends_with(".zju.edu.cn")
}

pub async fn route(upstreams, inited, ctx, query) {
    // skip IPv6
    if query.first_question?.qtype.to_str() == "AAAA" {
        return blackhole(query);
    }

    if is_ntp(query) {
        return upstreams.send_default("ntp", query).await;
    }

    if is_tailscale(query) {
        return upstreams.send_default("tailscale", query).await;
    }

    if is_zju(query) {
        return upstreams.send_default("zju", query).await;
    }

    // is domestic
    if inited.domestic_domains.0.contains(query.first_question?.qname) {
        return upstreams.send_default("domestic", query).await;
    }

    return upstreams.send_default("oversea", query).await;
}
''
