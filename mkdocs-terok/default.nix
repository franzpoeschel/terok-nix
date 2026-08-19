{
  lib,
  fetchFromGitHub,
  python3Packages,
  enable-terok-checks,
}:

python3Packages.buildPythonPackage rec {
  pname = "mkdocs-terok";
  version = "v0.8.1";

  src = fetchFromGitHub {
    owner = "terok-ai";
    repo = "mkdocs-terok";
    rev = version;
    sha256 = "sha256-nnlCL4DxsKhTaVYoIud+rVgtvm3MJwaFmg9xOX7tvII=";
  };

  patches = [ ./mkdocs-terok-version.patch ];

  buildInputs = with python3Packages; [
    hatchling
    hatch-vcs
  ];
  propagatedBuildInputs = with python3Packages; [
    properdocs
    pyyaml
    squarify
  ];

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  nativeCheckInputs = with python3Packages; [
    pytest
    pydantic
  ];

  doCheck = enable-terok-checks;
  installCheckPhase = ''
    runHook preInstallCheck
    export PYTHONPATH="${src}:$PYTHONPATH"
    pytest tests/ -v
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Importable modules for mkdocs-gen-files";
    homepage = "https://github.com/terok-ai/mkdocs-terok";
    license = licenses.bsd0;
  };
}
