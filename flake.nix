{
  description = "Terok Nix package distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
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
        devShells = import ./devShells { inherit pkgs; };
        formatter =
          let
            config = self.checks.${system}.pre-commit-check.config;
            inherit (config) package configFile;
            script = ''
              ${pkgs.lib.getExe package} run --all-files --config ${configFile}
            '';
          in
          pkgs.writeShellScriptBin "pre-commit-run" script;
        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
            };
          };
        };
      }
    )
    // {
      overlays.default = import ./terok-overlay.nix;
    };
}
