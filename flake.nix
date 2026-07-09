{
  description = "Terok Nix package distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import ./. { pkgs = import nixpkgs; inherit system; };
        in {
          legacyPackages = pkgs;
          devShells = import ./devShells {
            pkgs = self.legacyPackages.${system};
          };
        })
    //
    {
      overlays.default = import ./terok-overlay.nix;
    };
}
