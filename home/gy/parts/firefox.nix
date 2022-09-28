{ config, pkgs }: {
  enable = true;
  profiles = {
    home = {
      name = "home";
      id = 0;
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "https://github.com/";
        "fission.autostart" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "browser.newtabpage.activity-stream.feeds.topsites" = "https://google.com/,https://github.com/";
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "general.useragent.override" = with config.programs.firefox.package; "Mozilla/5.0 (X11; x86_64; rv:${version}) Gecko/20100101 Firefox/${version}";
        "widget.gtk.overlay-scrollbars.enabled" = false;
        "layout.css.prefers-color-scheme.content-override" = 0;  # REF: <https://support.mozilla.org/bm/questions/1364502>
      };
    };
  };
  package = pkgs.wrapFirefox pkgs.firefox-bin-unwrapped {
    forceWayland = true;
    extraPolicies = {
      PasswordManagerEnabled = false;
      DisableFirefoxAccounts = false;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Preferences = {
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "https://arxiv.org/list/cs.CV/pastweek?show=397";
        "browser.newtab.extensionControlled" = false;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        "tridactyl.vim@cmcaine.co.uk" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
        };
        "jid1-Om7eJGwA1U8Akg@jetpack" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/octotree/latest.xpi";
        };
        "zotero@chnm.gmu.edu" = {
          installation_mode = "force_installed";
          install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
        };
        "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
        };
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
      };
    };
  };
}
