{ pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
  };

  # Puts the external monitor's DDC/CI bus under /dev/i2c-* (the connector buses
  # are the AMDGPU DM i2c adapters). Without it, COSMIC's external-monitor
  # brightness applet has nothing to talk to. The udev rule tags the devices
  # `uaccess`, so the logged-in seat gets write access without a group.
  hardware.i2c.enable = true;

  # brightnessctl writes the sysfs backlight directly; systemd only tags it for
  # the seat, which grants no ACL on sysfs attributes. Hand it to the video
  # group so ivan can dim the internal panel from a keybind.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
}
