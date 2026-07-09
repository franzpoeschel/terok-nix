{ pkgs }:
{
  edit-packaging = pkgs.mkShell
    {
      nativeBuildInputs = with pkgs; [
        git
        pre-commit
        nixpkgs-fmt
      ];
    };
}
