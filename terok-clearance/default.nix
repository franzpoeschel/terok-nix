{
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-clearance";
  version = "v0.7.1";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-clearance";
    rev = version;
    sha256 = "sha256-shq0XMyic9+bNsFI8o2C24005y5Znm2UyepKq4Sdx3g=";
  };

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

  doCheck = true;
}
