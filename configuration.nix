{ pkgs, lib, inputs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.grub.gfxmodeEfi= "text";
  boot.loader.grub.enable = true;
  boot.loader.grub.gfxmodeBios= "text";
  programs.fuse.userAllowOther = true;
  #networking.networkmanager.enable = true;
  networking.useDHCP = true;
  
  system.stateVersion = "23.11";

    users.users."bloodwolfe" = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [ "wheel" ];
  };

  #Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  #keygen
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
    hostKeys = [
      {
        bits = 4096;
        path = "/persist/system/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/system/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      } 
    ];
  };
  sops = {
    validateSopsFiles = false;
    age = {
     sshKeyPaths = [ "/persist/system/etc/ssh/ssh_host_ed25519_key" ];
     keyFile = "/persist/system/var/lib/sops-nix/key.txt";
     generateKey = true;
    };
  };
  home-manager = {
    extraSpecialArgs = {inherit inputs;}; 
    users = {
      "bloodwolfe" = import ./home.nix;
    };
  }; 
  environment.systemPackages = with pkgs; [
    git 
    sops 
    neovim 
    gnupg 
    age 
    ssh-to-age
  ];
}
