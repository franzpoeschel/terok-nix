{
  description = "Terok Nix package distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      make-outputs = { nixpkgs }: system:
        let pkgs = import ./. { pkgs = import nixpkgs; inherit system; };
        in {
          legacyPackages = pkgs;
        };
    in
    flake-utils.lib.eachDefaultSystem (make-outputs { inherit nixpkgs; });
}
