{ config, ... }:

let
  profile = rec {
    name = "main";
    path = name;
  };
  inherit (config.ricing.headful) themeColor;
in

{
  home.file = {
    zoteroProfileIni = {
      text = ''
        [General]
        StartWithLastProfile=1

        [Profile0]
        Name=${profile.name}
        IsRelative=1
        Path=${profile.path}
        Default=1
      '';
      target = ".zotero/zotero/profiles.ini";
    };
    zoteroChromeCssTabBarTextColorFix = {
      text = ''
        .tabs::before,
        .tabs::after {
          border: 0px !important;
        }

        #tab-bar-container .tab {
          background: inherit !important;
          color: inherit !important;
          border-color: ${themeColor "darkgray"} !important;
          border-radius: 3px !important;
          border-left: 0px !important;
          border-right: 0px !important;
          margin-left: 1px !important;
          margin-right: 1px !important;
        }
        #tab-bar-container .tab-close {
          display: none !important;
        }

        #tab-bar-container .tab.selected {
          background-color: ${themeColor "darkgray"} !important;
          color: ${themeColor "foreground"} !important;
          border-top-color: ${themeColor "highlight"} !important;
        }

        #tab-bar-container .tab:not(.selected) {
          background-color: ${themeColor "black"} !important;
          color: ${themeColor "foreground"} !important;
          border-bottom: ${themeColor "darkgray"} !important;
        }

        #zotero-toolbar {
          background: inherit !important;
          border-bottom: inherit !important;
        }
      '';
      target = ".zotero/zotero/${profile.path}/chrome/userChrome.css";
    };
  };
}
