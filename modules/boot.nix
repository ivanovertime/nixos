{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  # 5 of the 24 s of boot time was the boot menu waiting. One second still leaves
  # room to press a key, and older generations stay selectable.
  boot.loader.timeout = 1;

  # AMD Barcelo (Vega) APU + dual display (eDP + HDMI).
  # sg_display=0 avoids scatter-gather display buffers that glitch on APUs
  # using system RAM as VRAM. dcdebugmask=0x10 was REMOVED: it disables pipe
  # split and made the dcn21 secondary-pipe path (the one that warns/resets) worse.
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 160;

    # With zram, swapping in 8 contiguous pages (the default) means touching
    # eight separately-compressed blocks. One page at a time is the cheaper
    # access pattern for compressed swap.
    "vm.page-cluster" = 0;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
