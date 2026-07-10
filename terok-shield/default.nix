{
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-shield";
  version = "v0.7.2";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-shield";
    rev = version;
    sha256 = "sha256-Fs7gyIVdD55q/hp64XL5yB++6LZsRmj3qj/gJi8+3/I=";
  };

  patches = [ ./terok-shield-pydantic.patch ];

  buildInputs = with python3Packages; [
    terok-util
  ];

  propagatedBuildInputs = with python3Packages; [
    pydantic
    pyyaml
    poetry-core
    poetry-dynamic-versioning
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  doCheck = true;
}
