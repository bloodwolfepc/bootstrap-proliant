{ pkgs, inputs, ... }:

{ 
  imports = [
    #inputs.impermanence.nixosModules.home-manager.impermanence
    ./gpg.nix
  ];
  home.stateVersion = "23.11"; 
}
