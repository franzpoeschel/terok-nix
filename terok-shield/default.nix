{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage {
  pname = "terok-shield";
  version = "v0.6.42a9";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-shield";
    rev = "v0.6.42a9";
    sha256 = "sha256-iU4TsaFWb/FFagjdHGcL29WxEkg8ci7UjU78AMeTqSQ=";
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

  doCheck = false;
}

