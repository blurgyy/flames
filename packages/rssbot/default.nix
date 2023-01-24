{ source, lib, rustPlatform }: rustPlatform.buildRustPackage {
  inherit (source) pname version src;
  cargoLock = source.cargoLock."Cargo.lock";

  patches = [
    ./remove-backtrace.patch
  ];

  meta = {
    homepage = "https://github.com/iovxw/rssbot";
    description = "Lightweight Telegram RSS notification bot. 用于消息通知的轻量级 Telegram RSS 机器人";
    license = lib.licenses.unlicense;
  };
}
