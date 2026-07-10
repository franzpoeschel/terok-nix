{
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-sandbox";
  version = "v0.4.0";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-sandbox";
    rev = version;
    sha256 = "sha256-a3SnkqM34wT7ZwDzrby8rK+JvTcQkD3W/KHh6BCYe2g=";
  };

  patches = [ ./terok-sandbox-version.patch ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    cryptography
    jinja2
    keyring
    packaging
    platformdirs
    prompt-toolkit
    pydantic
    ruamel-yaml
    sqlcipher3
    terok-shield
    terok-clearance
    terok-util
    pyyaml
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  doCheck = true;
}
