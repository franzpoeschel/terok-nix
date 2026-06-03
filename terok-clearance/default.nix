{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage {
  pname = "terok-clearance";
  version = "v0.6.14a7";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-clearance";
    rev = "v0.6.14a7";
    sha256 = "sha256-IHCR5oC9YcFLzndF34PHkBvB+L9oBEIKl3PpjJKyB3E=";
  };

  patches = [ ./terok-clearance-version.patch ];

  buildInputs = with python3Packages; [
    terok-util
  ];

  propagatedBuildInputs = with python3Packages; [
    asyncvarlink
    dbus-fast
    pyyaml
    poetry-core
    poetry-dynamic-versioning
    terok-util
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  doCheck = false;
}

