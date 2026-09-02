{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    settings.port = 5432;

    ensureUsers = [
      {
        name = "dev";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          password = "dev";
        };
      }
    ];

    ensureDatabases = [
      "dev"
      "development"
    ];

    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  origin-address  auth-method
      local all       all     trust
      host  all       all     127.0.0.1/32    md5
      host  all       all     ::1/128         md5
    '';
  };
}
