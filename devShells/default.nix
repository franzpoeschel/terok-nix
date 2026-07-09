{ pkgs, checks }:
{
  edit-packaging =
    let
      inherit (checks.pre-commit-check) shellHook enabledPackages;
    in
    pkgs.mkShell {
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
}
