{ source, lib, python3Packages }: with python3Packages; buildPythonPackage {
  inherit (source) pname version src;

  propagatedBuildInputs = [ appdirs colorama python-telegram-bot ];

  meta = {
    homepage = "https://github.com/rahiel/telegram-send";
    description = "Send messages and files over Telegram from the command-line.";
    license = lib.licenses.gpl3;
  };
}
