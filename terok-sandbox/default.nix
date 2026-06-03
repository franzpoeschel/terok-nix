{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage {
  pname = "terok-sandbox";
  version = "v0.0.124a20";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-sandbox";
    rev = "v0.0.124a20";
    sha256 = "sha256-1ica2ii6+nWDUPo1jZFKGea2R5EA3dJ7DTpTYtjHqZ0=";
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

  doCheck = false;
}

