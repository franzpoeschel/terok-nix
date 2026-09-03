{
  pkgs ? import <nixpkgs>,
  overlays ? [ ],
  system ? builtins.currentSystem,
}:

let
  make-packages =
    # boolean
    enable-terok-checks:
    pkgs {
      overlays = overlays ++ [
        (import ./terok-overlay.nix { inherit enable-terok-checks; })
      ];
      inherit system;
    };

in
make-packages false
// {
  with-checks = make-packages true;
}
