{
  lib,
  fetchFromGitHub,
  python3Packages,
  enable-terok-checks,
  git,
  coreutils,
  nftables,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-sandbox";
  version = "v0.6.0";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-sandbox";
    rev = version;
    sha256 = "sha256-XtxJKJggh33yZXncZqcIbKzoSB3MuT0l0bzFUPxswf4=";
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
  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-asyncio
    git
    coreutils
    nftables
  ];

  doCheck = enable-terok-checks;

  installCheckPhase = ''
    runHook preInstallCheck
    export PYTHONPATH="${src}:$PYTHONPATH"
    for tool in sleep false echo; do
      while read -r file; do
        sed -i "s|/bin/$tool|${coreutils}/bin/$tool|g" "$file"
      done < <(grep -Rl "/bin/$tool" tests/ || true)
    done
    TMPDIR=/tmp pytest tests/ -v \
      --deselect 'tests/unit/test_supervisor_children.py::TestPolicyConfinesOnTheLiveKernel::test_gate_accepts_real_git_push_inside_scoped_policy'
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Hardening for podman containers";
    homepage = "https://github.com/terok-ai/terok-sandbox";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
