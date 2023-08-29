{ source, lib, fetchFromGitHub, python3Packages }: with python3Packages; let
  python-telegram-bot-135 = buildPythonPackage rec {
    pname = "python-telegram-bot";
    version = "13.5";
    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-y18YUcAG4jffs9M2g6r9OZnQ0+fwj6n2SfD2Fh4mAlk=";
    };
    patches = [
      ./python-telegram-bot-do-not-build-raw.patch
    ];

    format = "setuptools";
    disabled = pythonOlder "3.7";

    nativeBuildInputs = [ setuptools ];
    propagatedBuildInputs = [
      tornado
      aiolimiter
      (APScheduler.overridePythonAttrs (o: {
        version = "3.6.3";
        src = fetchPypi {
          pname = "APScheduler";
          version = "3.6.3";
          hash = "sha256-O7Uinu1vu9r8E86WJxKuZuF1qiFMab7TWga//PDF4kQ=";
        };
      }))
      cachetools
      cryptography
      httpx
      pytz
    ];

    doCheck = false;
  };
in buildPythonPackage {
  inherit (source) pname version src;

  propagatedBuildInputs = [
    appdirs
    colorama
    python-telegram-bot-135
    urllib3
  ];
  

  meta = {
    homepage = "https://github.com/rahiel/telegram-send";
    description = "Send messages and files over Telegram from the command-line.";
    license = lib.licenses.gpl3;
  };
}
