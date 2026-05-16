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

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    jupyter = {
      url = "github:kirelagin/jupyter.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";

  };
  outputs =
    inputs@{
      self,

      # general setup
      nixpkgs,
      nixpkgs-legacy,
      nixpkgs-stable,
      home-manager,

      # emacs
      emacs-flake,
      emacs-packages,

      # nixos specific
      foundryvtt,
      jupyter,
      nix-flatpak,
      stylix,

      # macos
      darwin,
      darwin-emacs,
    }:
    let
      # Code that will be run on every device I set up
      globalModules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          # enable home manager
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.mercury = ./home.nix;
            extraSpecialArgs = {
              inherit inputs;
            };
            backupFileExtension = ".bak";
          };

          # set up emacs with packages
          nixpkgs.overlays = [ emacs-packages.overlays.emacs ];
        }

        # basic config for every device
        ./configuration.nix

        # theming
        ./system-modules/stylix.nix
      ];

      # Code that will be run on every NixOS device I set up
      nixosModules = [
        # modules for specific flakes
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        stylix.nixosModules.stylix

        # basic nixos setup + sway window manager
        ./system-modules/nixos.nix
        ./system-modules/sway.nix

        # home manager modules
        {
          home-manager.users.mercury =
            { inputs, ... }:
            {
              imports = [
                # more granular nixos setup using home-manager
                ./home-modules/flatpaks.nix
                ./home-modules/nixos.nix
                ./home-modules/sway.nix
                ./home-modules/kitty.nix
              ]
              ++ homeModules;
            };
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }

      ];

      # home-manager modules for every device
      homeModules = [
        ./home.nix
        { home.file.".hushlogin".text = ""; }
        nix-flatpak.homeManagerModules.nix-flatpak
      ];
    in
    {

      #################### DESKTOP CONFIG ####################
      # SYSTEM CONFIG
      nixosConfigurations.biggest-baby = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules =
          globalModules
          ++ nixosModules
          ++ [
            foundryvtt.nixosModules.foundryvtt

            # Device specific configs
            ./system-modules/device-info/biggest-baby.nix

            # Modules to enable
            ./system-modules/enable-ssh.nix
            ./system-modules/razer.nix
            ./system-modules/remote-desktop.nix
            ./system-modules/foundry.nix
            ./home-modules/flatpaks.nix

            # Specific modules for specific tasks
            #  Comment a module out to disable it
            ./system-modules/jupyter.nix
            #./system-modules/file-transfer.nix
            #./system-modules/docker.nix

          ];
      };

      #################### OLD LAPTOP CONFIG ####################
      # SYSTEM CONFIG
      nixosConfigurations.slowest-baby = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules =
          globalModules
          ++ nixosModules
          ++ [
            ## TODO: Replace with this laptop's hardware-config.nix
            #./system-modules/device-info/slowest-baby.nix
          ];
      };

      #################### MACBOOK CONFIG ####################
      # SYSTEM CONFIG
      darwinConfigurations.big-mac = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = globalModules ++ [
          home-manager.darwinModules.home-manager
          stylix.darwinModules.stylix
          ./system-modules/darwin.nix
          {
            nixpkgs.overlays = [ darwin-emacs.overlays.emacs ];
            home-manager.users.mercury =
              { pkgs, ... }:
              {
                imports = homeModules;
              };
          }
        ];
      };
    };
}
