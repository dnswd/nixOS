{
  description = "dnswd's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    apple-nerd-fonts = {
      flake = false;
      url =
        "https://github.com/EzequielRamis/apple-nerd-fonts/releases/download/1.0/apple-nerd.tar.gz";
    };

    whitesur = {
      flake = false;
      # 2022-02-21 release
      url =
        "github:vinceliuice/WhiteSur-gtk-theme/3dca2b10d0a24bd111119c3eb94df512d7e067f5";
    };

  };

  outputs = { self, nixpkgs, nixpkgsUnstable, home-manager, ... }@inputs: 
  let
    system = "x86_64-linux";
    username = "halcyon";
    hostname = "msi";

    mkPkgs = o:
      import nixpkgs ({
        config.allowUnfree = true;
        localSystem = { inherit system; };
      } // o);

    mkUnstablePkgs = o:
      import nixpkgsUnstable ({
        config.allowUnfree = true;
        localSystem = { inherit system; };
      } // o);

    lib = nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit pkgs inputs;
        lib = final;
      };
    });

    pkgs = mkPkgs {
      overlays = [
        (final: prev: rec {
          my = lib.my.mapModules ./pkgs (p:
            prev.callPackage p {
              inherit inputs;
              inherit (lib) my;
            });
          unstable = mkUnstablePkgs { };
        })
      ];
    };

    extraSpecialArgs = {
      inherit pkgs system hostname username;
      inherit (lib) my;
    };

    nixConfig = import ./system/configuration.nix
      (extraSpecialArgs // { inherit lib; });

  in rec {
    homeManagerConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./users/${username}/home.nix
      ];
    };

    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nixConfig
        home-manager.nixosModules.home-manager {
          home-manager = {
            inherit extraSpecialArgs;
            backupFileExtension = "backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports = [ 
                (import ./users/${username}/home.nix)
                (import ./apps/xinit.nix) 
                (import ./apps/xdg.nix) 
                (import ./apps/git.nix)
                (import ./apps/tmux.nix)
                (import ./apps/kitty.nix) 
                (import ./apps/zsh)
                # (import ./apps/eww)
                (import ./apps/rofi)
                (import ./apps/variable.nix) 
                (import ./apps/nvim) 
                (import ./apps/direnv.nix)
                (import ./apps/gtk-theme.nix) 
                (import ./apps/other.nix) 
                # (import ./apps/bspwm.nix) 
                # (import ./apps/picom.nix) 
                (import ./apps/path.nix) 
                # (import ./apps/notification.nix) 
                # (import ./apps/file-manager.nix) 
                (import ./apps/vscode.nix)
                (import ./apps/java.nix)
                (import ./apps/firefox.nix)
                # (import ./apps/qtile.nix)
              ];
            };
          };
        }
      ];
    };

    packages.${system}.default = nixosConfigurations.${hostname};

  };
}
