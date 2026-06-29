{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "terok";
  version = "v0.8.3";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok";
    rev = version;
    sha256 = "sha256-DNkW38dw2Xgtyxe8+Ytz5YV2YfLfogOOfnB7rzLgRpc=";
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
