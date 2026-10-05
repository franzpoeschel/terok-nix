{
  lib,
  fetchFromGitHub,
  python3Packages,
  nftables,
  enable-terok-checks,
  writeShellScriptBin,
}:

let
  pname = "terok-shield";
  version = "v0.9.0";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-shield";
    rev = version;
    sha256 = "sha256-GImp3irGKfb66pV2fhKL5gP37REIzn/rQ0dS1uq4MzA=";
  };

  test-python-env = python3Packages.python.withPackages (
    p: with p; [
      pytest
      pytest-asyncio
      ruamel-yaml
      pydantic
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
    export PATH="${nftables}/bin:$PATH"
    ${test-python-env}/bin/python \
      -m pytest tests/integration/dns \
      -v
  '';

  pkg = python3Packages.buildPythonPackage {
    inherit pname version src;

    patches = [ ./terok-shield-pydantic.patch ];

    propagatedBuildInputs = with python3Packages; [
      pydantic
      pyyaml
      terok-util
    ];

    pyproject = true;
    build-system = with python3Packages; [
      hatchling
      hatch-vcs
    ];

    nativeCheckInputs = with python3Packages; [
      pytest
      pytest-asyncio
      ruamel-yaml
      nftables
    ];

    doCheck = enable-terok-checks;
    installCheckPhase = ''
      runHook preInstallCheck
      export PYTHONPATH="${src}:$PYTHONPATH"
      TMPDIR=/tmp pytest tests/ -v --ignore=tests/integration/dns
      runHook postInstallCheck
    '';

    passthru = { inherit integration-tests; };

    meta = with lib; {
      description = "nftables-based egress firewalling for podman containers with domain-based allowlists";
      homepage = "https://github.com/terok-ai/terok-shield";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };

in
pkg
