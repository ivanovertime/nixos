{ ... }:

{
  # ── Printing ───────────────────────────────────────────────────────────
  services.printing.enable = true;

  # ── Firmware updates ───────────────────────────────────────────────────
  services.fwupd.enable = true;

  # ── Audio (PipeWire) ───────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Containers ─────────────────────────────────────────────────────────
  virtualisation.docker.enable = true;
}
