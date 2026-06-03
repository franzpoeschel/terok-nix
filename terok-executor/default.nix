{ fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage {
  pname = "terok-executor";
  version = "v0.0.149a24";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "terok-executor";
    rev = "v0.0.149a24";
    sha256 = "sha256-S9Nks5+EOvzMU0GTmcl+pnxGQGn5q5livfC2ty2KTTw=";
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

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  doCheck = false;

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

