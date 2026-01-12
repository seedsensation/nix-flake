{pkgs, ...}:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = true;
    };
  };

  security.pam.services.sshd.googleAuthenticator.enable = true;

  networking.firewall.allowedTCPPorts = [ 22  25522 25525 ];
  networking.firewall.allowedUDPPorts = [ 9 ];
}
