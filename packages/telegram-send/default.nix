{ source, lib, python3Packages }: with python3Packages; buildPythonPackage {
  inherit (source) pname version src;

  propagatedBuildInputs = [
    appdirs
    colorama
    python-telegram-bot
    urllib3
  ];

  postPatch = ''
    sed -Ee 's/python-telegram-bot==20.6/python-telegram-bot>=20/' -i setup.py
  '';

  meta = {
    homepage = "https://github.com/rahiel/telegram-send";
    description = "Send messages and files over Telegram from the command-line.";
    license = lib.licenses.gpl3;
  };
}
