{     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #impermanence = {
    #  url = "github:nix-community/impermanence";
    #};
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs:
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        #inputs.disko.nixosModules.default
        #(import ./disko.nix { device = "/dev/sda"; })
        ./configuration.nix       
        inputs.home-manager.nixosModules.default
        # inputs.impermanence.nixosModules.impermanence 
      ];
    };
  };
}
