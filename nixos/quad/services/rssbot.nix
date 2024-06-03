{ config, ... }: {
  sops.secrets.rssbot-token = {
    owner = config.users.users.rssbot.name;
    group = config.users.groups.rssbot.name;
  };
  services.rssbot = {
    enable = true;
    dbFile = "/var/lib/rssbot/db.json";
    environmentFile = config.sops.secrets.rssbot-token.path;
  };
}
