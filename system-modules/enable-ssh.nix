{
  pkgs,
  config,
  inputs,
  ...
}:
let
  package-groups = import ../packages.nix { inherit pkgs config inputs; };
in
{
  environment.systemPackages = with pkgs; [
    google-authenticator
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = true;
      AllowUsers = [ "mercury" ];
    };
    ports = [
      22
      25525
    ];
    openFirewall = true;
  };

  security.pam.services.sshd.googleAuthenticator = {
    enable = true;
    allowNullOTP = true;
  };

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        25525
      ];
      allowedUDPPorts = [
        9
        25525
      ];
    };
  };
}
