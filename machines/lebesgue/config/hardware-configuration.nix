{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  services.qemuGuest.enable = true;

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["btrfs"];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = ["subvol=root" "defaults" "noatime" "compress=zstd:1" "discard=async" "nodatacow"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    neededForBoot = true;
    options = ["subvol=nix" "defaults" "noatime" "compress=zstd:3" "discard=async" "nodatacow"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    neededForBoot = true;
    options = ["subvol=persist" "defaults" "noatime" "compress=zstd:1" "discard=async" "nodatacow"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
