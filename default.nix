{
  pkgs ? import <nixpkgs>,
  overlays ? [ ],
  system ? builtins.currentSystem,
}:

let
  terok-overlay = import ./terok-overlay.nix;

in
pkgs {
  overlays = overlays ++ [ terok-overlay ];
  inherit system;
}
