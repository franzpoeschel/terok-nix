{
  lib,
  fetchFromGitHub,
  python3Packages,
  enable-terok-checks,
  nftables,
  podman,
  git,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-executor";
  version = "v0.3.1";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-executor";
    rev = version;
    sha256 = "sha256-+CcHHeVEAguGLZ5byuWWxMUQYsf5y+WBzZmRySAtd4c=";
  };

  propagatedBuildInputs = with python3Packages; [
    agent-client-protocol
    prompt-toolkit
    rich
    pyyaml
    pydantic
    ruamel-yaml
    terok-sandbox
    tomli-w
  ];

  patches = [ ./terok-executor-version.patch ];

  pyproject = true;
  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-asyncio
    nftables
    podman
    git
  ];

  doCheck = enable-terok-checks;
  installCheckPhase = ''
    runHook preInstallCheck
    export PYTHONPATH="${src}:$PYTHONPATH"
    pytest tests/ -v
    runHook postInstallCheck
  '';

  # Nix is a bit eager in patching shell interpreter locations.
  # Undo the patch for the in-container scripts (such as opencode).
  # There is no Nix inside the containers, hence no patching needed.
  postFixup = ''
    find \
      "$out/${python3Packages.python.sitePackages}/terok_executor/resources/scripts" \
      -type f -print0 |
    while IFS= read -r -d "" file; do
      sed -i 's|#!${python3Packages.python}/bin/python3|#!/usr/bin/env python3|' "$file"
    done
  '';

  meta = with lib; {
    description = "AI agent repository and instrumentation for running agents in a terok-sandbox environment";
    homepage = "https://github.com/terok-ai/terok-executor";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
