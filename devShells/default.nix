{ pkgs, checks }:
let
  inherit (checks.pre-commit-check) shellHook enabledPackages;
  shells = {
    default = shells.edit-packaging;
    edit-packaging = pkgs.mkShell {
      nativeBuildInputs =
        with pkgs;
        [
          git
          pre-commit
          nixfmt
        ]
        ++ enabledPackages;
      inherit shellHook;
    };
  };
in
shells
