{
  lib,
  fetchFromGitHub,
  python3Packages,
  enable-terok-checks,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-util";
  version = "v0.4.0";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-util";
    rev = version;
    sha256 = "sha256-rPKxhEu4leUg3MPmgTw1IRBZf6Wxw+0919EhqnLL2HU=";
  };

  patches = [ ./terok-util-version.patch ];

  buildInputs = with python3Packages; [
    platformdirs
  ];

  propagatedBuildInputs = with python3Packages; [
    jinja2
    packaging
    platformdirs
    ruamel-yaml
  ];

  pyproject = true;
  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-asyncio
  ];

  doCheck = enable-terok-checks;

  installCheckPhase = ''
    runHook preInstallCheck
    export PYTHONPATH="${src}:$PYTHONPATH"
    # A short TMPDIR keeps AF_UNIX socket paths under the kernel's 108 byte limit.
    # The Landlock cross-directory rename probe fails with EXDEV on the Nix
    # sandbox's overlayfs, so it is deselected here and covered by the
    # integration suite on a real host.
    TMPDIR=/tmp pytest tests/unit -v \
      --deselect tests/unit/test_hardening.py::TestConfineFilesystem::test_confines_reads_and_writes_to_the_lane
    runHook postInstallCheck
  '';

  pythonRuntimeDepsCheckHook = null;

  meta = with lib; {
    description = "Common utility library for the terok ecosystem packages";
    homepage = "https://github.com/terok-ai/terok-util";
    license = licenses.asl20;
  };
}
