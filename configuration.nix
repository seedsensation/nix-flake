## CONFIG FILE FOR GLOBAL SYSTEM CONFIGS
# This should be for config that is shared across every device, including Darwin

{
  inputs,
  config,
  lib,
  pkgs,
  nixpkgs,
  ...
}:
let
  package-groups = import ./packages.nix { inherit pkgs config inputs; };
in
{
  nix.settings.download-buffer-size = 5242888000; # 500MiB
  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/London";

  environment.systemPackages = with package-groups; global-utils;

  users.users.mercury.packages =
    with package-groups;
    emacs-deps ++ user-global ++ global-scripts ++ latex-docs;

  #services.emacs = {
  #  enable = true;
  #  defaultEditor = true;
  #  package = package-groups.emacs;

  #};

  fonts.packages = package-groups.fonts;

  environment.variables.PATH = "${pkgs.clang-tools}/bin:$PATH";

}
