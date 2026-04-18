{
  description = "My Nix config for all of my devices";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-legacy.url = "github:NixOS/nixpkgs/nixos-24.05";

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

    emacs-flake = {
      url = "github:seedsensation/emacs-flake";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ################################################################
    ### PINNED SPECIFIC VERSION OF HYPRLAND UNTIL HY3 IS PATCHED ###
    ################################################################

    #hyprland = {
    #  #url = "github:hyprwm/Hyprland?submodules=1&ref=v0.53.3";
    #  url = "github:hyprwm/Hyprland?submodules=1&ref=v0.54.2";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #hy3 = {
    #  url = "github:outfoxxed/hy3?ref=hl0.54.2";
    #  #url = "github:outfoxxed/hy3?ref=hl0.53.0.1";
    #  inputs.hyprland.follows = "hyprland";
    #};

    ################################################################
    ############## ONCE HY3 IS PATCHED, REMOVE &REF.. ##############
    ################################################################

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";

  };
  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-legacy,
    home-manager,
    darwin,
    darwin-emacs,
    emacs-packages,
    emacs-flake,
    #hyprland,
    #hyprland-plugins,
    #hy3,
    nix-flatpak,
    foundryvtt
  }: 
  let
    # Code that will be run on every device I set up
    globalModules = [
      {
        system.configurationRevision = self.rev or self.dirtyRev or null;
        nix.settings.experimental-features = ["nix-command" "flakes"];
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.mercury = ./home.nix;
          extraSpecialArgs = {
            inherit inputs;
          };
          backupFileExtension = ".bak";
        };

	      nixpkgs.overlays = [ emacs-packages.overlays.emacs ];
      }
      ./configuration.nix
      ./options.nix
    ];

    # Code that will be run on every NixOS device I set up
    nixosModules = [
      home-manager.nixosModules.home-manager
      ./system-modules/nixos.nix
          ./system-modules/sway.nix

      { 
      home-manager.users.mercury = {inputs, ...}: {
        imports = [
          #inputs.hyprland.homeManagerModules.default
          ./home-modules/flatpaks.nix
          ./home-modules/sway.nix
	        #./home-modules/hyprland.nix
        ] ++ homeModules;
      };
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };
      }

    ];

    # home-manager code for every device
    homeModules = [
      ./home.nix
      ./options.nix
      {home.file.".hushlogin".text = "";}
      nix-flatpak.homeManagerModules.nix-flatpak
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
      ./system-modules/foundry.nix
      ./system-modules/file-transfer.nix
      #./system-modules/vr.nix
      ./home-modules/flatpaks.nix
      nix-flatpak.nixosModules.nix-flatpak
      foundryvtt.nixosModules.foundryvtt

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

