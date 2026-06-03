final: prev:

# we get the right callPackge version this way,
# even when adding further overrides down the line
with final;
let
  packages =
    {
      terok = callPackage ./terok { };

      # python overlay as in
      # https://discourse.nixos.org/t/add-python-package-via-overlay/19783/3
      pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
        (python-final: python-prev: {
          asyncvarlink = callPackage ./asyncvarlink { };
          unique-namer = callPackage ./unique-namer { };
          terok-shield = callPackage ./terok-shield { };
          terok-util = callPackage ./terok-util { };
        })
      ];

      python3 =
        let
          self = prev.python3.override {
            inherit self;
            packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
          };
        in
        self;

      python3Packages = final.python3.pkgs;
    };
in
packages

