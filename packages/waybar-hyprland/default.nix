{ waybar, hyprland }: waybar.overrideAttrs (o: {
  pname = o.pname + "-hyprland";
  postPatch = ''
    # REF: <https://wiki.hyprland.org/Useful-Utilities/Status-Bars/#waybar>
    sed -Ee 's|zext_workspace_handle_v1_activate\(workspace_handle_\);|const std::string command = "${hyprland}/bin/hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());|g' -i src/modules/wlr/workspace_manager.cpp
  '';
  mesonFlags = o.mesonFlags ++ [ "-Dexperimental=true" ];
})
