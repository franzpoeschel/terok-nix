{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage {
  pname = "unique-namer";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "aziele";
    repo = "unique-namer";
    rev = "fdf18f25ecefa566c2c755659ad06965633d6765";
    sha256 = "sha256-gPG3gbusBsUGlhCouzdI8oUbubxhYViD+kj3n7sP8zI=";
  };

  propagatedBuildInputs = [ ];

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
  ];

  doCheck = true;

  meta = with lib; {
    description = "Generate unique and memorable names and ids across various categories";
    homepage = "https://github.com/aziele/unique-namer";
    license = licenses.mit;
  };
}
