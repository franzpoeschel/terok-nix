{
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "terok-executor";
  version = "v0.2.1";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-executor";
    rev = version;
    sha256 = "sha256-z7uXWrsXv41gAgRJo+rbZRBLUauI4HuFePpZoi4q9ZU=";
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
    poetry-core
    poetry-dynamic-versioning
  ];

  patches = [ ./terok-executor-version.patch ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  doCheck = true;

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
}
