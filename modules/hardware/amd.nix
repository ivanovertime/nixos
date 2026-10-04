{ ... }:

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
}
