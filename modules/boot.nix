{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # AMD Barcelo (Vega) APU + dual display (eDP + HDMI).
  # sg_display=0 avoids scatter-gather display buffers that glitch on APUs
  # using system RAM as VRAM. dcdebugmask=0x10 was REMOVED: it disables pipe
  # split and made the dcn21 secondary-pipe path (the one that warns/resets) worse.
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  zramSwap.enable = true;
}
