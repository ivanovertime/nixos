{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  # the menu was 5 of the 24 s boot time
  boot.loader.timeout = 1;

  # APU: sg_display=0 avoids scatter-gather glitches with shared VRAM
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 160;

    # zram: one page at a time is cheaper than eight
    "vm.page-cluster" = 0;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # hibernate: resume from the swap partition declared in hosts/spica/default.nix
  boot.resumeDevice = "/dev/disk/by-uuid/eab1711b-915f-4d96-b405-4c7d27423d2d";
}
