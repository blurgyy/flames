{ config }: let
  inherit (config.ricing.headful) themeColor;
in ''
@define-color nocolor rgba(0, 0, 0, 0);
* {
  min-height: 0;
  font-family: slab-serif;
  /*
   * Adding this will make workspace border to be vertical, while omitting
   * this will make workspasce border to be a trapezoid.
   *
   * border: none;
   * */
  /*
   * font-weight: bold;
   */
}

tooltip {
  background-color: ${themeColor "background"};
  color: ${themeColor "foreground"};
  border: 2px solid ${themeColor "blue"};
}

window#waybar {
  background-color: ${themeColor "background"};
  color: ${themeColor "foreground"};
}

window#waybar.hidden {
  opacity: 0.2;
}

#workspaces button {
  color: ${themeColor "gray"};
  border-radius: 0px;
  border-top: 4px solid transparent;
  border-bottom: 4px solid transparent;
  /* margin: vertical | horizontal */
  margin: 0px 2px;
  transition-duration: 256ms;
  transition-property: all;
}

#workspaces button:hover {
  background: inherit;
  color: ${themeColor "lightgray"};
  border-bottom: 4px solid ${themeColor "gray"};
  /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
  box-shadow: inherit;
  text-shadow: inherit;
}

#workspaces button.focused,
#workspaces button.active {
  background: inherit;
  color: ${themeColor "foreground"};
  border-bottom: 4px solid ${themeColor "white"};
  /* font-weight: bold; */
  /* border-bottom: 5px solid #547daf; */
}

#workspaces button.focused:hover,
#workspaces button.active:hover {
  background-color: ${themeColor "darkgray"};
}

#workspaces button.urgent {
  border-bottom: 4px solid ${themeColor "orange"};
  background-color: inherit;
  color: ${themeColor "white"};
  animation: blinker 0.7s linear infinite;
}

#workspaces button.urgent:hover {
  background-color: ${themeColor "red"};
}

/* https://stackoverflow.com/a/16344389/13482274 */
@keyframes blinker {
  50% {
    opacity: 0.7;
  }
}

#mode {
  padding: 0em 1em;
  border-radius: 4px;
  color: ${themeColor "red"};
  font-weight: bold;
  animation: blinker 1s linear infinite;
  transition-property: all;
}

.modules-left widget+widget {
  border-left: solid @nocolor 4px;
}

.modules-right widget+widget {
  border-left: solid @nocolor 4px;
}

#custom-menu {
  font-family: 'Symbols Nerd Font';
  padding-left: 12px;
  padding-right: 4px;
  color: ${themeColor "cyan"};
}

#custom-separator {
  color: ${themeColor "darkgray"};
}

#backlight,
#pulseaudio,
#cpu,
#memory,
#temperature,
#battery,
#network,
#tray {
  min-width: 4em;
  /* margin: vertical | horizontal */
  margin: 0px 8px;
}

#clock {
  font-family: "system-ui";
  margin: 0px 8px;
}

#window {
  padding-left: 0.5em;
}

#backlight {
  margin-right: 0;
}
#pulseaudio {
  margin-left: 0;
}

#memory {
  margin-right: 0;
}
#cpu {
  margin-left: 0;
}

#network {
  min-width: 6em;
  margin: 0;
}
#network.disconnected {
  font-weight: bold;
  color: ${themeColor "orange"};
  animation: blinker 3s linear infinite;
}
#tray {
  min-width: 0;
  margin-left: 6px;
  margin-right: 12px;
}
''
