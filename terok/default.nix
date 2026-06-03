let

  python_overrides =
    { fetchFromGitHub
    , fetchPypi
    , fetchurl
    , rustPlatform
    , pkg-config
    , lib
    , openssl
    , stdenv
    , libiconv
    }:
    final: prev: {
      terok = final.buildPythonApplication {
        pname = "terok";
        version = "v0.7.9";

        src = builtins.fetchGit {
          url = "https://github.com/terok-ai/terok.git";
          ref = "refs/tags/v0.7.9";
          rev = "d002b84804c47752d327358aaadd797ddce0ca78";
        };

        patches = [ ./terok-version.patch ];

        format = "pyproject";

        propagatedBuildInputs = with final; [
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
      };
    };

in
{ fetchFromGitHub
, fetchPypi
, fetchurl
, python3Packages
, rustPlatform
, lib
, stdenv
, callPackage
, libiconv
, openssl
, pkg-config
, symlinkJoin
, bash
}:

let

  pkgs_overridden = python3Packages.overrideScope
    (python_overrides {
      inherit
        fetchFromGitHub
        fetchPypi
        fetchurl
        rustPlatform
        pkg-config
        lib
        openssl
        stdenv
        libiconv;
    });

in
let python3Packages = pkgs_overridden;

in
python3Packages.terok
