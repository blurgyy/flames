{ config, lib, pkgs
, hostName
, proxy
}: {
  enable = true;
  profiles = {
    home = {
      name = "home";
      id = 0;
      isDefault = true;
      # NOTE: prefs set here are modifiable in firefox's about:config page
      settings = {
        "general.useragent.override" = let
          inherit (config.programs.firefox.package) version;
        in "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:${version}) Gecko/20100101 Firefox/${version}";
        "identity.fxaccounts.account.device.name" = hostName;
      };
      userChrome = ''
        #sidebar-box *,
        #urlbar-background,
        #navigator-toolbox {
          transition: background-color .5s cubic-bezier(0, 0, 0, 1);
        }
        .tab-background {
          transition: background-color .5s cubic-bezier(0, 0, 0, 1);
          box-shadow: none !important;
          background-image: none !important;
        }
        .tab-background[selected] {
          background-color: var(--tab-selected-bgcolor) !important;
        }
      '';
    };
  };
  policies = {
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
    # NOTE: prefs set here are immutable during usage
    # REF: <https://mozilla.github.io/policy-templates/#preferences>
    Preferences = (if proxy != null then {
      "network.proxy.socks_remote_dns" = true;
      "network.proxy.no_proxies_on" = lib.concatStringsSep ", " proxy.ignore;
      "network.proxy.type" = 1;  # manual proxy configuration
      "network.proxy.socks_version" = 5;
      "network.proxy.socks" = proxy.socks.addr or "";
      "network.proxy.socks_port" = proxy.socks.port or 0;
      "network.proxy.http" = proxy.http.addr or "";
      "network.proxy.http_port" = proxy.http.port or 0;
      "network.proxy.share_proxy_settings" = true;
    } else {}) // {
      # REF: <https://support.mozilla.org/en-US/kb/accessibility-services>
      "accessibility.force_disabled" = 1;  # it seems setting this to `true` instead of `1` causes firefox to omit all of the preferences set in this file

      "browser.newtab.extensionControlled" = false;
      "browser.newtabpage.activity-stream.default.sites" = "https://arxiv.org/list/cs.CV/pastweek?show=397";
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.startup.homepage" = "https://github.com/";
      "browser.toolbars.bookmarks.visibility" = "newtab";

      "browser.urlbar.suggest.searches" = true;
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "browser.search.suggest.enabled" = true;
      "browser.search.suggest.enabled.private" = false;

      "browser.warnOnQuitShortcut" = false;
      "fission.autostart" = true;
      "layout.css.overflow-overlay.enabled" = true;  # for the plugin "Bing Chat for All Browsers" <https://github.com/anaclumos/bing-chat-for-all-browsers#firefox>
      "layout.css.prefers-color-scheme.content-override" = 2;  # REF: <https://support.mozilla.org/bm/questions/1364502>
      "media.ffmpeg.vaapi.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      "widget.gtk.overlay-scrollbars.enabled" = false;

      # enable userChrome.css loading
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
    ExtensionSettings = let
      mkForceInstalled = extensions: builtins.mapAttrs 
        (name: cfg: { installation_mode = "force_installed"; } // cfg)
        extensions;
    in mkForceInstalled {  # download the .xpi file, unzip the .xpi file, `jq .browser_specific_settings.gecko.id manifest.json` to get the id
      "addon@darkreader.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      "enhancerforyoutube@maximerf.addons.mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/enhancer-for-youtube/latest.xpi";
      "jid1-93WyvpgvxzGATw@jetpack".install_url = "https://addons.mozilla.org/firefox/downloads/latest/to-google-translate/latest.xpi";
      # "jid1-Om7eJGwA1U8Akg@jetpack".install_url = "https://addons.mozilla.org/firefox/downloads/latest/octotree/latest.xpi";
      "spdyindicator@chengsun.github.com".install_url = "https://addons.mozilla.org/firefox/downloads/latest/http2-indicator/latest.xpi";
      "tridactyl.vim@cmcaine.co.uk".install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
      "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      "zotero@chnm.gmu.edu".install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
      "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
      "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
      "firefox-translations-addon@mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-translations/latest.xpi";
      "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ruffle_rs/latest.xpi";
      # "{a9cb10b9-75e9-45c3-8194-d3b2c25bb6a2}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bing-chat-for-all-browsers/latest.xpi";
      "{85860b32-02a8-431a-b2b1-40fbd64c9c69}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/github-file-icons/latest.xpi";
      "ATBC@EasonWong".install_url = "https://addons.mozilla.org/firefox/downloads/latest/adaptive-tab-bar-colour/latest.xpi";
    } // {
      "*".installation_mode = "blocked";  # blocks all other addons
    };
  };
}
