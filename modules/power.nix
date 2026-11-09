{ pkgs, ... }:

let
  # Toggle the EC "Long Life" charge ceiling (80 %) from Linux. The BIOS of this
  # laptop has no switch for it, and the EC keeps the mode across reboots, so
  # this script is the only way to flip it. Kernel >= 6.18 exposes charge_types
  # ("Standard" / "Long_Life"); older kernels use the deprecated conservation_mode
  # node (0 / 1) — fall back to it when charge_types is absent.
  batteryCharge = pkgs.writeShellScriptBin "battery-charge" ''
    set -eu

    node=/sys/class/power_supply/BAT0/charge_types
    max=Standard
    cap=Long_Life

    if [ ! -w "$node" ]; then
      node=/sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/conservation_mode
      max=0
      cap=1
    fi

    [ -w "$node" ] || { echo "battery-charge: no writable charge node" >&2; exit 1; }

    case "''${1:-}" in
      max)      echo "$max" > "$node" ;;
      longlife) echo "$cap" > "$node" ;;
      status)   : ;;
      *) echo "usage: battery-charge {max|longlife|status}" >&2; exit 1 ;;
    esac

    echo "mode:  $(cat "$node")"
    [ -r /sys/class/power_supply/BAT0/capacity ] &&
      echo "level: $(cat /sys/class/power_supply/BAT0/capacity)%"
  '';
in
{
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    # 5 % ~= 1.7 Wh: enough to write the hibernation image even on a worn pack
    percentageAction = 5;
    # HybridSleep would leave the session in RAM, which dies with the battery
    criticalPowerAction = "Hibernate";
  };

  # Lid close suspends; after 2 h on the worn pack it hibernates instead of
  # trickling the battery down to the 5 % critical floor.
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  systemd.sleep.settings.Sleep.HibernateDelaySec = "2h";

  environment.systemPackages = [ batteryCharge ];

  # Passwordless toggle for the charge ceiling; the script only writes one
  # sysfs node. sudo compares resolved path strings, so match the PATH symlink
  # users actually invoke — the store path alone never matches.
  security.sudo.extraRules = [
    {
      users = [ "ivan" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/battery-charge";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
