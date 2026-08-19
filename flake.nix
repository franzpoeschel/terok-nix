{
  description = "Terok Nix package distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      git-hooks,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = self.legacyPackages.${system};
      in
      {
        legacyPackages = import ./. {
          pkgs = import nixpkgs;
          inherit system;
        };
        devShells = import ./devShells {
          inherit pkgs;
          checks = self.checks.${system};
        };
        formatter = import ./formatter {
          inherit pkgs;
          checks = self.checks.${system};
        };
        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
            };
          };
          inherit (pkgs.with-checks) terok;
          terok-without-checks = pkgs.terok;
        };
      }
    )
    // {
      overlays.default = import ./terok-overlay.nix { };
    };
}
