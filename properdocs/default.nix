{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "properdocs";
  version = "v1.6.7";

  src = fetchFromGitHub {
    owner = "properdocs";
    repo = "properdocs";
    rev = version;
    sha256 = "sha256-ACEgR9oNMPEDMLxeSJhNO7dJZBpTOiusfpE7XaXuztE=";
  };

  buildInputs = with python3Packages; [
    hatchling
  ];
  propagatedBuildInputs = with python3Packages; [
    click
    ghp-import
    jinja2
    markdown
    markupsafe
    platformdirs
    pyyaml-env-tag
    pyyaml
    watchdog
  ];

  pyproject = true;
  build-system = [
    python3Packages.setuptools
  ];

  doCheck = false;

  meta = with lib; {
    description = "ProperDocs documentation toolbox";
    homepage = "https://properdocs.org/";
    license = licenses.bsd3;
  };
}
