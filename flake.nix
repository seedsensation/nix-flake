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
      }
      ./configuration.nix
      ];
    homeDefault = [{
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }];
  in {


    #################### DESKTOP CONFIG ####################
    # SYSTEM CONFIG
    nixosConfigurations.biggest-baby = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = 
        globalModules ++ 
        homeDefault ++
        [ 
          home-manager.nixosModules.home-manager
          ./modules/system/home-manager-config.nix
          ./modules/system/nixos.nix
          ./modules/system/openssh.nix
          ./hardware/biggest-baby.nix
          { 
            home-manager.users.mercury = {inputs, ...}: {
              imports = [
                inputs.hyprland.homeManagerModules.default
        	./modules/home/global-home.nix
        	./modules/home/hyprland.nix
        	{home.file.".hushlogin".text = "";}
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
    };

    #################### OLD LAPTOP CONFIG ####################
    # SYSTEM CONFIG
    nixosConfigurations.slowest-baby = nixpkgs.lib.nixosSystem {
      modules = globalModules ++ 
                homeDefault ++
                [ 
		  home-manager.nixosModules.home-manager
                  ./devices/slowest-baby.nix 
		  { home-manager.users.mercury = ./home-manager/slow-laptop.nix; }
                ];
    };
    
    #################### MACBOOK CONFIG ####################
    # SYSTEM CONFIG
    darwinConfigurations.big-mac = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = globalModules ++ 
                homeDefault ++
                [
	          home-manager.darwinModules.home-manager
	          ./devices/darwin.nix
		  { home-manager.users.mercury = ./home-manager/macbook.nix; }
                ];
    };
  };
}

