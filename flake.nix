{
  description = "My Nix config for all of my devices";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-emacs = {
      url = "github:nix-giant/nix-darwin-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-packages = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    darwin-emacs,
    emacs-packages,
    hyprland,
    hyprland-plugins,
    hy3
  }: 
  let
    globalModules = [
      {
        system.configurationRevision = self.rev or self.dirtyRev or null;
        nix.settings.experimental-features = ["nix-command" "flakes"];
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.mercury = ./home.nix;
          backupFileExtension = ".bak";
        };

	      nixpkgs.overlays = [ emacs-packages.overlays.emacs ];
      }
      ./configuration.nix
    ];

    nixosModules = [
      home-manager.nixosModules.home-manager
      ./system-modules/nixos.nix

      { 
      home-manager.users.mercury = {inputs, ...}: {
        imports = [
          inputs.hyprland.homeManagerModules.default
          ./home-modules/hyprland.nix
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
      modules = globalModules ++ nixosModules ++
      [ 
      # Device specific configs
      ./system-modules/device-info/biggest-baby.nix

      # Modules to enable
      ./system-modules/docker.nix
      ./system-modules/enable-ssh.nix
      ./system-modules/razer.nix
      ./system-modules/remote-desktop.nix
      ];
    };

    #################### OLD LAPTOP CONFIG ####################
    # SYSTEM CONFIG
    nixosConfigurations.slowest-baby = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = globalModules ++ nixosModules ++
      [ 
	    ## TODO: Replace with this laptop's hardware-config.nix
      #./system-modules/device-info/slowest-baby.nix
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
	      ./system-modules/darwin.nix
	      { 
	      nixpkgs.overlays = [ darwin-emacs.overlays.emacs ];
	      home-manager.users.mercury = { pkgs, ... }: {
	        imports = homeModules;
	      };
	      }
      ];
    };
  };
}

