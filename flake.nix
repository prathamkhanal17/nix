{

  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    };

  outputs = { self, nixpkgs, home-manager, nvf, ... }:
  {  
    nixosConfigurations = {
      legion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
        ./configuration.nix
        nvf.nixosModules.default
            ];
        };
      };
	
     homeConfigurations = {
	prathamk = home-manager.lib.homeManagerConfiguration {
		pkgs = nixpkgs.legacyPackages."x86_64-linux";
		modules = [ ./home.nix ];
		};
	};	

   };

}
