{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication {
  pname = "terok";
  version = "v0.7.9";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok";
    rev = "v0.7.9";
    sha256 = "sha256-Byo4Er0vi7dQe5dZZLUFV0vuVMOwWhV382sPO6o9R4Y=";
  };

  patches = [ ./terok-version.patch ];

  format = "pyproject";

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    platformdirs
    pydantic
    pyyaml
    requests
    rich
    ruamel-yaml
    terok-clearance
    terok-executor
    terok-sandbox
    terok-shield
    terok-util
    textual
    textual-serve
    unique-namer
    jinja2
    poetry-core
    poetry-dynamic-versioning
  ];
}
