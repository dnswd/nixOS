{
  description = "dnswd's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

    extraSpecialArgs = {
      inherit pkgs system lib;
    };

  in {
    homeManagerConfigurations = {
      alice = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = [
          ./users/alice/home.nix {
	    home = {
              username = "alice";
	      homeDirectory = "/home/alice";
	      stateVersion = "22.11";
	    };
	  }
	];
      };
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Nix config modules
          ./system/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alice = {
                imports = [ 
                  (import ./users/alice/home.nix)
                  (import ./apps/xinit.nix) 
                  (import ./apps/xdg.nix) 
                  (import ./apps/git.nix) 
                  (import ./apps/kitty.nix) 
                  (import ./apps/zsh) 
                  (import ./apps/variable.nix) 
                ];
              };
            };
          }
        ];
      };
    };

  };
}
