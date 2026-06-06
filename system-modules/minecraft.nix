{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.neoforge = {
      enable = true;
      package = pkgs.neoforgeServers.neoforge-1_21_1;
      autoStart = false;
      jvmOpts = "-Xms4G -Xmx6G";
      serverProperties = {
        max-players = 2;
        level-seed = "6804046977792434697";
        motd = "Our Minecraft Server :)";
      };

    };
  };

  networking.firewall.allowedTCPPorts = [ 8100 ];

  systemd.timers."update-server-perms" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "update-server-perms.service";
    };
  };
  systemd.services."update-server-perms" = {
    script = ''
      chmod a+rwx /srv -R
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

  };

  systemd.services."send_message_to_minecraft" =
    let
      message = "TIME TO GET DRESSED";
      color = "red";
    in
    {
      script = ''
        /etc/profiles/per-user/mercury/bin/tmux -S /run/minecraft/neoforge.sock send 'title @a title {"text":"${message}","color":"${color}","bold":true}' ENTER
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };

    };

}
