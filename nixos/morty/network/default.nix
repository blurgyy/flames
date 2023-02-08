{ pkgs, ... }: {
  imports = [
    ./rathole.nix
    ../../_parts/vclient.nix
    ./wlan.nix
  ];
  systemd.services.hp-keycodes = {
    wantedBy = [
      "multi-user.target"
      "rescue.target"
      "graphical.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      # REF: <https://itectec.com/ubuntu/ubuntu-does-airplane-mode-keep-toggling-on-the-hp-laptop-in-ubuntu-18-04/>
      ExecStart = "${pkgs.kbd}/bin/setkeycodes e057 240 e058 240";
    };
  };
}
