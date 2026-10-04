{ ... }:

{
  # Keep the pack out of the 100%-and-hot regime while the laptop is docked.
  # The Lenovo EC exposes its charge cap through the generic power-supply
  # `charge_types` attribute (kernel 6.15+): it reads `[Standard] Long_Life`,
  # so the cap is supported and was off. There is no charge_control_end_threshold
  # on this model, and ideapad_laptop's own `conservation_mode` node is deprecated
  # in favour of this attribute.
  #
  # power-profiles-daemon cannot drive it: its `trickle_charge` action writes a
  # singular `charge_type`, which this ACPI battery does not expose.
  #
  # A one-shot instead of an udev rule: the extension that creates the attribute
  # is registered after the battery's `add` uevent, so a rule can run too early.
  systemd.services.battery-care = {
    description = "Cap battery charging at the EC's Long Life threshold";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      attr=/sys/class/power_supply/BAT0/charge_types
      read -r current < "$attr" || exit 0
      case "$current" in
        *"[Long_Life]"*) ;;
        *) echo Long_Life > "$attr" ;;
      esac
    '';
  };
}
