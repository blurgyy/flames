{ pkgs, ... }: {
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [ minecraft ];
  networking.firewall-tailored = {
    acceptedPorts = [{
      port = 27036;
      protocols = [ "tcp" ];
      comment = "steam remote play";
    } {
      port = "27031-27036";
      protocols = [ "udp" ];
      comment = "steam remote play";
    } {
      port = 27015;
      protocols = [ "tcp" "udp" ];
      comment = "steam dedicated server";
    }];
  };
}
