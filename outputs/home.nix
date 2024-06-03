{ self, nixpkgs, inputs }: let
  lib = nixpkgs.lib;
  apply = userName: attrs: lib.mapAttrs' (hostName: params: {
    name = "${userName}@${hostName}";
    value = import ../home (params // { inherit userName hostName; });
  }) attrs;
  x86_64-non-headless = {
    system = "x86_64-linux";
    headless = false;
    inherit self nixpkgs inputs;
  };
  x86_64-headless = {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
  aarch64-headless = {
    system = "aarch64-linux";
    inherit self nixpkgs inputs;
  };

  getProxyEnvVars = proxyCfg: hostName: let
    _http_proxy_addr = if hostName == proxyCfg.http.addr then "127.0.0.2" else proxyCfg.http.addr;
    _http_proxy_port = toString proxyCfg.http.port;
    _socks_proxy_addr = if hostName == proxyCfg.socks.addr then "127.0.0.2" else proxyCfg.socks.addr;
    _socks_proxy_port = toString proxyCfg.socks.port;
  in {
    http = let _ = "http://${_http_proxy_addr}:${_http_proxy_port}"; in {
      _proxy_addr = _http_proxy_addr;
      _proxy_port = _http_proxy_port;
      all_proxy = _;
      http_proxy = _;
      https_proxy = _;
      ftp_proxy = _;
      rsync_proxy = _;
    };
    socks = let _ = "socks5h://${_socks_proxy_addr}:${_socks_proxy_port}"; in {
      _proxy_addr = _socks_proxy_addr;
      _proxy_port = _socks_proxy_port;
      all_proxy = _;
      http_proxy = _;
      https_proxy = _;
      ftp_proxy = _;
      rsync_proxy = _;
    };
    no_proxy = lib.concatStringsSep "," proxyCfg.ignore;
  };

  labProxy = {
    ignore = [
      "localhost"
      "127.0.0.1/8"
      "::1"
      "cc98.org"
      "nexushd.org"
      "zju.edu.cn"
    ] ++ (builtins.attrNames self.nixosConfigurations);
    socks = {
      addr = "winston";
      port = 1999;
    };
    http = {
      addr = "winston";
      port = 1990;
    };
    envVarsFor = getProxyEnvVars labProxy;
  };

  homeCfg4gy = apply "gy" {
    "morty" = x86_64-non-headless;
    "rpi" = aarch64-headless;
    "opi" = aarch64-headless;
    "copi" = aarch64-headless;

    "winston" = x86_64-non-headless // { proxy = labProxy; };
    "meda" = x86_64-headless;

    # set IP of winston in hosts
    "cadliu" = x86_64-headless // { proxy = labProxy; };
    "cad-liu" = x86_64-headless // { proxy = labProxy; };
    "mono" = x86_64-headless // { proxy = labProxy; };

    "peterpan" = x86_64-headless;
    "quad" = x86_64-headless;
    "rubik" = x86_64-headless;
    "hexa" = x86_64-headless;
    "octa" = x86_64-headless;
    "velo" = x86_64-headless;
  };

  homeCfg4root = apply "root" {
    "vdm0" = x86_64-headless;
  };

in

  homeCfg4gy // homeCfg4root
