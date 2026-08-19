{
  # Overridable, e.g. true for a "with-checks" package set that runs tests.
  enable-terok-checks ? false,
}:
final: prev:

# we get the right callPackge version this way,
# even when adding further overrides down the line
with final;
let
  packages = {
    terok = callPackage ./terok { };
    terok-clearance = callPackage ./terok-clearance { };
    terok-shield = callPackage ./terok-shield { };

    # python overlay as in
    # https://discourse.nixos.org/t/add-python-package-via-overlay/19783/3
    pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
      (python-final: python-prev: {
        agent-client-protocol = callPackage ./agent-client-protocol { };
        asyncvarlink = callPackage ./asyncvarlink { };
        dbus-fast = callPackage ./dbus-fast {
          old-dbus-fast = python-prev.dbus-fast;
        };
        mkdocs-terok = callPackage ./mkdocs-terok { };
        properdocs = callPackage ./properdocs { };
        terok = python-final.toPythonModule final.terok;
        terok-clearance = callPackage ./terok-clearance { };
        terok-executor = callPackage ./terok-executor { };
        terok-sandbox = callPackage ./terok-sandbox { };
        terok-shield = callPackage ./terok-shield { };
        terok-util = callPackage ./terok-util { };
        unique-namer = callPackage ./unique-namer { };
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

    inherit enable-terok-checks;
  };
in
packages
