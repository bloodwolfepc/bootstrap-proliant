{ pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];
  filesystems = {
    "/" = {
      device = "/dev/mapper/root_vg-root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd" "subvol=root" ]; 
      neededForBoot = true;
    };
    "/nix" = {
      device = "dev/mapper/root_vg-root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd" "subvol=nix" ]; 
      neededForBoot = true;
    };
    "/persist" = {
      device = "dev/mapper/root_vg-root";
      fsType = "btrfs";
      options = [ "defaults" "compress-force=zstd" "noatime" "ssd" "subvol=persist" ]; 
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F511-1DCD";
      fsType = "vfat";
    };
  };
  boot.loader.grub = {
    enable = true;
    gfxmodeEfi= "text";
    gfxmodeBios= "text";
    device = "/dev/disk/by-id/ata-T-FORCE_240GB_TPBF2312190010101467";
  };
  programs.fuse.userAllowOther = true;
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
    authorizedKeys.keys = [
      (builtins.readFile ./keys/id_angel.pub)
    ];
    enable = true;
    settings = {
      #PasswordAuthentication = true;
      PermitrootLogin = true;
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
