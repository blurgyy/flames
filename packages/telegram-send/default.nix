{ source, lib, python3Packages }: with python3Packages; buildPythonPackage {
  inherit (source) pname version src;

  propagatedBuildInputs = [ appdirs colorama python-telegram-bot ];
  
  # REF: <https://github.com/rahiel/telegram-send/issues/115#issuecomment-1371790720>
  postPatch = ''
    substituteInPlace telegram_send/telegram_send.py \
      --replace "from telegram.constants import MAX_MESSAGE_LENGTH" \
                "from telegram.constants import MessageLimit" \
      --replace "MAX_MESSAGE_LENGTH" "MAX_TEXT_LENGTH"
  '';

  meta = {
    homepage = "https://github.com/rahiel/telegram-send";
    description = "Send messages and files over Telegram from the command-line.";
    license = lib.licenses.gpl3;
  };
}
