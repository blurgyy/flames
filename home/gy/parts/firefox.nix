{ config, pkgs }: {
  enable = true;
  profiles = {
    home = {
      name = "home";
      id = 0;
      isDefault = true;
      settings = {
        "general.useragent.override" = let
          inherit (config.programs.firefox.package) version;
        in "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:${version}) Gecko/20100101 Firefox/${version}";
      };
    };
  };
  package = pkgs.wrapFirefox pkgs.firefox-bin-unwrapped {
    extraPolicies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = false;
      PasswordManagerEnabled = false;
      DisableFirefoxAccounts = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      Preferences = {
        "browser.newtab.extensionControlled" = false;
        "browser.newtabpage.activity-stream.default.sites" = "https://arxiv.org/list/cs.CV/pastweek?show=397";
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage" = "https://github.com/";
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "browser.warnOnQuitShortcut" = false;
        "fission.autostart" = true;
        "layout.css.prefers-color-scheme.content-override" = 2;  # REF: <https://support.mozilla.org/bm/questions/1364502>
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.gtk.overlay-scrollbars.enabled" = false;
      };
      ExtensionSettings = let
        mkForceInstalled = extensions: builtins.mapAttrs 
          (name: cfg: { installation_mode = "force_installed"; } // cfg)
          extensions;
      in mkForceInstalled {
        "addon@darkreader.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        "enhancerforyoutube@maximerf.addons.mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/enhancer-for-youtube/latest.xpi";
        "jid1-93WyvpgvxzGATw@jetpack".install_url = "https://addons.mozilla.org/firefox/downloads/latest/to-google-translate/latest.xpi";
        "jid1-Om7eJGwA1U8Akg@jetpack".install_url = "https://addons.mozilla.org/firefox/downloads/latest/octotree/latest.xpi";
        "spdyindicator@chengsun.github.com".install_url = "https://addons.mozilla.org/firefox/downloads/latest/http2-indicator/latest.xpi";
        "tridactyl.vim@cmcaine.co.uk".install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
        "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        "zotero@chnm.gmu.edu".install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
        "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        "firefox-translations-addon@mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-translations/latest.xpi";
        "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ruffle_rs/latest.xpi";
      };
    };
  };
}
