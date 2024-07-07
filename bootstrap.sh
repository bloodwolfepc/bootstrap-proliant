nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/bootstrap-proliant/disko.nix --arg device '"/dev/sda"'

nixos-generate-config --no-filesystems --root /mnt

cd /mnt/etc/nixos
rm configuration.nix
cp -r /tmp/bootstrap-proliant/* ./

cd
nixos-install --root /mnt --flake /mnt/etc/nixos#default

#reboot
#trust generated keys after reboot

#ssh-to-age -i $HOME/.ssh/id_ed25519.pub -o pub-key.txt
#ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 -o key.txt
#sudo cp /persist/system/var/lib/sops-nix/key.txt /persist/home/bloodwolfe/.config/sops/key.txt
#sudo chown -R $(id -u):$(id -g) /persist/home/bloodwolfe/.config/sops/age/key.txt
#
#
#
#
#
#$FLAKE=/home/bloodwolfe/projects/flake
#
#
#mkdir -p /persist/system/var/lib/sops-nix/key.txt
#ssh-to-age -private-key -i /persist/system/etc/ssh/ssh_host_ed25519_key -o /persist/system/var/lib/sops-nix/key.txt
#mkdir -p /persist/$HOME/.config/sops
#cp /persist/system/var/lib/sops-nix/key.txt /persist/$HOME/.config/sops/
#
#mkdir /persist/$FLAKE
#cd /persist/$FLAKE
#git clone https://github.com/bloodwolfepc/flake
#cp /etc/nixos/hardware-configuration.nix /persist/$FLAKE/$HOSTNAME
#
#SSH TO AGE PUBKEY .sops
#
#sops updatekeys $FLAKE/secrets/*
#CHOWN
