{ pkgs, checks }:
let
  config = checks.pre-commit-check.config;
  inherit (config) package configFile;
  script = ''
    if (( $# == 0 )); then
      files=(--all-files)
    else
      files=(--files "$@")
    fi
    ${pkgs.lib.getExe package} run --config ${configFile} "''${files[@]}"
  '';
in
pkgs.writeShellScriptBin "pre-commit-run" script
