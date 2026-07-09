{
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-shield";
  version = "v0.7.1";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-shield";
    rev = version;
    sha256 = "sha256-9Zb83FrzJ7YcDb52OuHM0+jfLddQ7D17FlmXzb0SmME=";
  };

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
