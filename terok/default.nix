{
  lib,
  fetchFromGitHub,
  python3Packages,
  enable-terok-checks,
  writeShellScriptBin,
}:

let
  version = "v0.8.5";
  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok";
    rev = version;
    sha256 = "sha256-HhrEPOCIumHs14snepNyPwIvNS2qCxBstp+dd2aGJXQ=";
  };
  terok = python3Packages.buildPythonApplication rec {
    pname = "terok";
    inherit src version;

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
    ];

    build-system = with python3Packages; [
      poetry-core
      poetry-dynamic-versioning
    ];

    nativeCheckInputs = with python3Packages; [
      pytest
    ];
    doCheck = enable-terok-checks;
    # Only a basic install check for terok package, Nix build env is too
    # restrictive for Terok tests otherwise.
    # Run `nix run .#terok.integration-tests` instead
    # on some system that has the necessary tooling (nft, podman, ...).
    # However, the test_version_branch_detection test must run on
    # the installed package, so do that here.
    installCheckPhase = ''
      runHook preInstallCheck
      export PYTHONPATH="${src}:$PYTHONPATH"
      pytest tests/unit/tui/test_version_branch_detection.py
      runHook postInstallCheck
    '';
    passthru = { inherit integration-tests; };

    meta = with lib; {
      description = "Manager for podman containers for AI coding agents";
      homepage = "https://github.com/terok-ai/terok";
      license = licenses.asl20;
    };
  };

  test-python-env = python3Packages.python.withPackages (
    p:
    with p;
    [
      pytest
      pytest-asyncio
      mkdocs-terok
    ]
    ++ terok.propagatedBuildInputs
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
    export PATH="${terok}/bin:${python3Packages.terok-executor}/bin:$PATH"
    ${test-python-env}/bin/python \
      -m pytest tests/ \
      -v \
      --ignore=tests/unit/tui/test_version_branch_detection.py
  '';

in
terok
