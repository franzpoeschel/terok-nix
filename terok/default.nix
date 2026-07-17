{
  fetchFromGitHub,
  python3Packages,
  nftables,
  enable-terok-checks,
  buildFHSEnv,
  coreutils,
  writeShellScript,
}:

let
  version = "v0.8.4";
  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok";
    rev = version;
    sha256 = "sha256-0KEIsF3QIh/h46L148Gx4XqQfn8VIFKl2Da3qKes4Uw=";
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
      poetry-core
      poetry-dynamic-versioning
    ];

    nativeCheckInputs = with python3Packages; [
      pytest
      pytest-asyncio
      httpx
      mkdocs
      mkdocs-terok
      nftables
      terok-executor
    ];

    doCheck = enable-terok-checks;
    installCheckPhase = ''
      runHook preInstallCheck
      # TODO Nix build env is too restrictive for Terok tests,
      # find some other solution
      runHook postInstallCheck
    '';
    passthru = { inherit test-env; };
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

  test-env = buildFHSEnv {
    name = "terok-test-env";
    targetPkgs =
      pkgs: with pkgs; [
        podman
        coreutils
        nftables
        test-python-env
      ];

    runScript = writeShellScript "run" ''
      set -eo pipefail

      unset TMPDIR
      dir="$(mktemp -d)"
      trap "rm -r $dir; echo 'removed test dir'" EXIT

      cp -a ${src}/. "$dir"
      cd "$dir"
      chmod -R a+w ./

      export PYTHONPATH="$dir/src:$PYTHONPATH"
      export PATH="${terok}/bin:$PATH"
      pytest tests/ -v --ignore=tests/integration --ignore=tests/unit/tui/test_version_branch_detection.py
    '';
  };

in
terok
