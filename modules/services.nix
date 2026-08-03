{ config, lib, pkgs, ... }:

{
  # ── Databases ─────────────────────────────────────────────────────────
  services.postgresql.enable = true;
  services.postgresql.ensureDatabases = [ "Base" ];
  services.postgresql.ensureUsers = [
    {
      name = "Base";
      ensureDBOwnership = true;
    }
  ];
  services.postgresql.authentication = ''
    local all all trust
    host all all 127.0.0.1/32 trust
    host all all ::1/128 trust
  '';

  services.pgadmin = {
    enable = true;
    port = 5050;
    openFirewall = false;
    initialEmail = "ivan@bitmosfera.com";
    initialPasswordFile = pkgs.writeText "pgadmin-initial-password" "change-me";
  };

  environment.etc."pgadmin/servers.json".text = builtins.toJSON {
    Servers = {
      "1" = {
        Name = "Local PostgreSQL";
        Group = "Development";
        Host = "127.0.0.1";
        Port = 5432;
        Username = "Base";
        MaintenanceDB = "Base";
        SSLMode = "prefer";
      };
    };
  };

  systemd.services.pgadmin = lib.mkMerge [
    {
      after = [ "postgresql.target" ];
      requires = [ "postgresql.target" ];
    }
    {
      preStart = lib.mkAfter ''
        ${lib.getExe' config.services.pgadmin.package "pgadmin4-cli"} load-servers /etc/pgadmin/servers.json \
          --replace \
          --user "${config.services.pgadmin.initialEmail}"
      '';
    }
  ];

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

  # ── Livebook ───────────────────────────────────────────────────────────
  services.livebook = {
    enableUserService = true;
    extraPackages = with pkgs; [
      git
      gnutar
      gzip
      curl
      gcc
      gnumake
      patch
    ];
  };
}
