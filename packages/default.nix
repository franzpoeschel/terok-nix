{ pkgs }:
{
  default = pkgs.terok;
  inherit (pkgs) terok terok-clearance terok-shield;
  inherit (pkgs.python3Packages)
    agent-client-protocol
    asyncvarlink
    dbus-fast
    mkdocs-terok
    properdocs
    terok-executor
    terok-sandbox
    terok-util
    unique-namer
    ;
}
