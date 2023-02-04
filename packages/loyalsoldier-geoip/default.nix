# Shared nix expression for loyalsoldier-geo{ip,site}
{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation rec {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm444 $src $out/share/v2ray/${builtins.head (lib.reverseList (lib.splitString "-" pname))}.dat
  '';

  meta = {
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    description = ''
      Enhanced edition of V2Ray rules dat files, compatible with Xray-core, Shadowsocks-windows,
      Trojan-Go and leaf.
    '';
    license = lib.licenses.gpl3;
  };
}
