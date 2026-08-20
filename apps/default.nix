{ pkgs }:
{
  default = {
    type = "app";
    program = "${pkgs.terok}/bin/terok";
  };
  terok = {
    type = "app";
    program = "${pkgs.terok}/bin/terok";
  };
  terok-integration-tests = {
    type = "app";
    program = "${pkgs.terok.passthru.integration-tests}/bin/run";
  };
  terok-clearance-integration-tests = {
    type = "app";
    program = "${pkgs.python3Packages.terok-clearance.passthru.integration-tests}/bin/run";
  };
  terok-shield-integration-tests = {
    type = "app";
    program = "${pkgs.python3Packages.terok-shield.passthru.integration-tests}/bin/run";
  };
}
