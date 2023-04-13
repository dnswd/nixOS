{
  description = "dnswd's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    apple-nerd-fonts = {
      flake = false;
      url = "https://github.com/EzequielRamis/apple-nerd-fonts/releases/download/1.0/apple-nerd.tar.gz";
    };

    whitesur = {
      flake = false;
      # 2022-02-21 release
      url = "github:vinceliuice/WhiteSur-gtk-theme/3dca2b10d0a24bd111119c3eb94df512d7e067f5";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgsUnstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "halcyon";
    hostname = "msi";

    mkChannel = c: o:
      import c ({
          config.allowUnfree = true;
          localSystem = {inherit system;};
        }
        // o);

    lib = nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit pkgs inputs;
        lib = final;
      };

      scheme = import ./scheme {
        inherit pkgs inputs;
        lib = final;
      };
    });

    pkgs = mkChannel nixpkgs {
      overlays = [
        (final: prev: rec {
          my = lib.my.mapModules ./pkgs (p:
            prev.callPackage p {
              inherit inputs;
              inherit (lib) my scheme;
            });
          unstable = mkChannel nixpkgsUnstable {};
        })
      ];
    };

    extraSpecialArgs = {
      inherit pkgs system hostname username;
      inherit (lib) my scheme;
    };

    nixConfig =
      import ./system/${hostname}/configuration.nix
      (extraSpecialArgs // {inherit lib;});

    homeModules = lib.my.importFrom ./home ++ [(import ./users/${username}/home.nix)];

    nixModules = u: [
      nixConfig
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          inherit extraSpecialArgs;
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${u} = {imports = homeModules;};
        };
      }
    ];
  in rec {
    # Run `nix fmt` to reformat the nix files
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = nixModules username;
    };
  };
}
