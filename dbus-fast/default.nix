{ old-dbus-fast
, fetchFromGitHub
}:

old-dbus-fast.overrideAttrs (prev: final: rec {
  version = "v4.3.0";
  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "dbus-fast";
    tag = version;
    sha256 = "sha256-eFqsHbtSSyQ4nYSULB9MHJ2JrN0EgOiU4jS4ISDCZ44=";
  };
})
