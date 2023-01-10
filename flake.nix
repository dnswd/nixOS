{
  description = "dnswd's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    apple-nerd-fonts = {
      flake = false;
      url =
        "https://github.com/EzequielRamis/apple-nerd-fonts/releases/download/1.0/apple-nerd.tar.gz";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";
    username = "alice";
    hostname = "nixos";

    mkPkgs = o:
      import nixpkgs ({
        config.allowUnfree = true;
        localSystem = { inherit system; };
      } // o);

    pkgs = mkPkgs {
      overlays = [
        (final: prev: rec {
          my = lib.my.mapModules ./pkgs (p:
            prev.callPackage p {
              inherit inputs;
              inherit (lib) my;
            });
          unstable = mkPkgs { };
        })
      ];
    };
    
    lib = nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit pkgs inputs;
        lib = final;
      };
    });

    extraSpecialArgs = {
      inherit pkgs system hostname username secrets;
      inherit (lib) my;
    };

    nixConfig = import ./system/configuration.nix
      (extraSpecialArgs // { inherit lib; });

  in rec {
    homeManagerConfigurations = {
      alice = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./users/alice/home.nix
        ];
      };
    };

    nixosConfigurations.${system} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nixConfig
        home-manager.nixosModules.home-manager {
          home-manager = {
            inherit extraSpecialArgs;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports = [ 
                (import ./users/alice/home.nix)
                (import ./apps/xinit.nix) 
                (import ./apps/xdg.nix) 
                (import ./apps/git.nix) 
                (import ./apps/kitty.nix) 
                (import ./apps/zsh)
                (import ./apps/variable.nix) 
                # (import ./apps/nvim.nix) 
                (import ./apps/direnv.nix) 
              ];
            };
          };
        }
      ];
    };

  };
}
