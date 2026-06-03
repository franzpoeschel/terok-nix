{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage {
  pname = "terok-util";
  version = "v0.0.2a1";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-util";
    rev = "v0.0.2a1";
    sha256 = "sha256-FyWZCcB4R0ebz+qDymQY7sL2KPI53t0AuzRSM8+HAwo=";
  };

  patches = [ ./terok-util-version.patch ];

  buildInputs = with python3Packages; [
    platformdirs
    ruamel-yaml
  ];

  propagatedBuildInputs = with python3Packages; [
    pydantic
    poetry-core
    poetry-dynamic-versioning
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  doCheck = false;
}

