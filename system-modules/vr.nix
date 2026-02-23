{ pkgs, inputs, ... }:
let
  pkgs-legacy = import inputs.nixpkgs-legacy {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  programs.alvr = {
    enable = true;
    openFirewall = true;
    package = pkgs-legacy.alvr;
  };


  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };


}
