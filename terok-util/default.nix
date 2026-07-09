{
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-util";
  version = "v0.2.0";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-util";
    rev = version;
    sha256 = "sha256-8k8W92+VbZtxLmbtNJdYb5U23DX7vayZVzkvE2CNVhM=";
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

  doCheck = true;
}
