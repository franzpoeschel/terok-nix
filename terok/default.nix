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
      terok-shield = final.buildPythonPackage {
        pname = "terok-shield";
        version = "v0.6.42a9";

        src = builtins.fetchGit {
          url = "https://github.com/terok-ai/terok-shield.git";
          ref = "refs/tags/v0.6.42a9";
          rev = "987a2fe5c1a2a5ec87c2259ae9de1dc589909b8a";
        };

        buildInputs = with final; [
          terok-util
        ];

        propagatedBuildInputs = with final; [
          pydantic
          pyyaml
          poetry-core
          poetry-dynamic-versioning
        ];

        pyproject = true;
        build-system = [ final.setuptools ];

        doCheck = false;
      };

      terok-clearance = final.buildPythonPackage {
        pname = "terok-clearance";
        version = "v0.6.14a7";

        src = builtins.fetchGit {
          url = "https://github.com/terok-ai/terok-clearance.git";
          ref = "refs/tags/v0.6.14a7";
          rev = "26b5bf1e5f2183efec2b8723f7dc616c2d3305de";
        };

        patches = [ ./terok-clearance-version.patch ];

        buildInputs = with final; [
          terok-util
        ];

        propagatedBuildInputs = with final; [
          asyncvarlink
          dbus-fast
          pyyaml
          poetry-core
          poetry-dynamic-versioning
          terok-util
        ];

        pyproject = true;
        build-system = [ final.setuptools ];

        doCheck = false;
      };

      terok-sandbox = final.buildPythonPackage {
        pname = "terok-sandbox";
        version = "v0.0.124a20";

        src = builtins.fetchGit {
          url = "https://github.com/terok-ai/terok-sandbox.git";
          ref = "refs/tags/v0.0.124a20";
          rev = "a96d6ed60e47ae648c23eff864c6c076bb9b11c1";
        };

        patches = [ ./terok-sandbox-version.patch ];

        propagatedBuildInputs = with final; [
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
        build-system = [ final.setuptools ];

        doCheck = false;
      };

      terok-executor = final.buildPythonPackage {
        pname = "terok-executor";
        version = "v0.0.149a24";

        src = builtins.fetchGit {
          url = "https://github.com/terok-ai/terok-executor.git";
          ref = "refs/tags/v0.0.149a24";
          rev = "b039b44c8c349acfa28361f2ed2af5f2daadca55";
        };

        propagatedBuildInputs = with final; [
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
        build-system = [ final.setuptools ];

        doCheck = false;

        # Nix is a bit eager in patching shell interpreter locations.
        # Undo the patch for the in-container scripts (such as opencode).
        # There is no Nix inside the containers, hence no patching needed.
        postFixup = ''
          find \
            "$out/${final.python.sitePackages}/terok_executor/resources/scripts" \
            -type f -print0 |
          while IFS= read -r -d "" file; do
            sed -i 's|#!${final.python}/bin/python3|#!/usr/bin/env python3|' "$file"
          done
        '';
      };

      terok-util = final.buildPythonPackage {
        pname = "terok-util";
        version = "v0.0.2a1";

        src = builtins.fetchGit {
          url = "https://github.com/terok-ai/terok-util.git";
          ref = "refs/tags/v0.0.2a1";
          rev = "5bc833a0e01e35423522e4f727592711ffd25071";
        };

        patches = [ ./terok-util-version.patch ];

        buildInputs = with final; [
          platformdirs
          ruamel-yaml
        ];

        propagatedBuildInputs = with final; [
          pydantic
          poetry-core
          poetry-dynamic-versioning
        ];

        pyproject = true;
        build-system = [ final.setuptools ];

        doCheck = false;
      };

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
