{
  fetchFromGitHub,
  python3Packages,
  enable-terok-checks,
  writeShellScriptBin,
}:

let
  pname = "terok-clearance";
  version = "v0.7.3";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-clearance";
    rev = version;
    sha256 = "sha256-KWCDPhF8iDBOYnXM7bYro1/IxYe5P8fHiIPpj0rJwww=";
  };

  test-python-env = python3Packages.python.withPackages (
    p: with p; [
      pytest
      pytest-asyncio
      pydantic
      python-dbusmock
      ruamel-yaml
      asyncvarlink
      dbus-fast
      pyyaml
      terok-util
    ]
  );

  integration-tests = writeShellScriptBin "run" ''
    set -eo pipefail

    unset TMPDIR
    dir="$(mktemp -d)"
    trap "rm -r $dir; echo 'removed test dir'" EXIT

    cp -a ${src}/. "$dir"
    cd "$dir"
    chmod -R a+w ./

    export PYTHONPATH="$dir/src:''${PYTHONPATH:-}"
    ${test-python-env}/bin/python \
      -m pytest tests/integration \
      -v
  '';

  pkg = python3Packages.buildPythonPackage {
    inherit pname version src;

    patches = [ ./terok-clearance-asyncvarlink.patch ];

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

    nativeCheckInputs = with python3Packages; [
      pytest
      pytest-asyncio
      pydantic
      python-dbusmock
      ruamel-yaml
    ];

    doCheck = enable-terok-checks;
    installCheckPhase = ''
      runHook preInstallCheck
      export PYTHONPATH="${src}:$PYTHONPATH"
      pytest tests/ -v --ignore=tests/integration
      runHook postInstallCheck
    '';

    pythonRuntimeDepsCheckHook = null;
    passthru = { inherit integration-tests; };
  };

in
pkg
