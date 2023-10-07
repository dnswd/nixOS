{
  description = "dnswd's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

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
    nix-ld,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "halcyon";
    hostname = "msi";

    mkPkgs = c: o:
      import c ({
          # options: https://github.com/NixOS/nixpkgs/blob/2657fbd90d791e10196de892f24c17b8d2ce8eda/pkgs/top-level/config.nix#L84
          config.allowUnfree = true;
          config.warnUndeclaredOptions = true;
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

    pkgs = mkPkgs nixpkgs {
      overlays = [
        (final: prev: rec {
          # custom packages under pkgs.my
          my = lib.my.mapModules ./pkgs (p:
            prev.callPackage p {
              inherit inputs;
              inherit (lib) my scheme;
            });
          unstable = mkPkgs nixpkgsUnstable {};
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

    homeModules = [(import ./users/${username}/home.nix)] ++ lib.my.importFrom ./home;

    nixModules = u: [
      nixConfig
      home-manager.nixosModules.home-manager {
        home-manager = {
          inherit extraSpecialArgs;
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${u} = {imports = homeModules;};
        };
      }
      nix-ld.nixosModules.nix-ld
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
