{
  description = "My Nix config for all of my devices";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

  };
  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    darwin,
    hyprland,
    hyprland-plugins,
    hy3
  }: let
    globalModules = [
      {
        system.configurationRevision = self.rev or self.dirtyRev or null;
        nix.settings.experimental-features = ["nix-command" "flakes"];
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
      }
      ./configuration.nix
      ];

    nixosModules = [
      home-manager.nixosModules.home-manager
      ./modules/system/home-manager-config.nix
      ./modules/system/nixos.nix

      { 
        home-manager.users.mercury = {inputs, ...}: {
          imports = [
            inputs.hyprland.homeManagerModules.default
            ./modules/home/hyprland.nix
          ] ++ homeModules;
        };
        home-manager.extraSpecialArgs = {
          inherit inputs;
        };
      }

    ];

    homeModules = [
      ./home.nix
      {home.file.".hushlogin".text = "";}
    ];
  in {


    #################### DESKTOP CONFIG ####################
    # SYSTEM CONFIG
    nixosConfigurations.biggest-baby = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = 
        globalModules ++ 
	nixosModules ++
        [ 
          ./modules/system/enable-ssh.nix
          ./hardware/biggest-baby.nix
        ];
    };

    #################### OLD LAPTOP CONFIG ####################
    # SYSTEM CONFIG
    nixosConfigurations.slowest-baby = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = 
        globalModules ++ 
	nixosModules ++
        [ 
	  ## TODO: Replace with this laptop's hardware-config.nix
          #./hardware/biggest-baby.nix
        ];
    };
    
    #################### MACBOOK CONFIG ####################
    # SYSTEM CONFIG
    darwinConfigurations.big-mac = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = 
        globalModules ++ 
        [
	  home-manager.darwinModules.home-manager
	  ./devices/darwin.nix
	  { 
	    home-manager.users.mercury = { pkgs, ... }: {
	      imports = homeModules ++ [
	        (pkgs.writeShellScriptBin "rebuild-darwin" "sudo darwin-rebuild switch --flake ~/darwin#big-mac")
	        (pkgs.writeShellScriptBin "reload-darwin" "sudo darwin-rebuild test --flake ~/darwin#big-mac")
	      ];
	    };
	  }
        ];
    };
  };
}

