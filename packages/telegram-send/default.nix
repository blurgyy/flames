{ source, lib, python3Packages }: with python3Packages; buildPythonPackage {
  inherit (source) pname version src;

  propagatedBuildInputs = [ appdirs colorama python-telegram-bot ];
  
  # REF: <https://github.com/rahiel/telegram-send/issues/122#issuecomment-1450404377>
  postPatch = ''
    cp ${./telegram_send.py} telegram_send/telegram_send.py
  '';

  meta = {
    homepage = "https://github.com/rahiel/telegram-send";
    description = "Send messages and files over Telegram from the command-line.";
    license = lib.licenses.gpl3;
  };
}
