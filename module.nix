{withSystem, ...}: {
  flake.modules.nixos.default = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.seercat.services.http-debug-server;
    pkg = withSystem pkgs.stdenv.hostPlatform.system (
      {config, ...}:
        config.packages.default
    );
  in {
    options.seercat.services.http-debug-server = {
      enable = lib.options.mkEnableOption "http-debug-server";

      port = lib.options.mkOption {
        default = 8080;
        type = lib.types.port;
        description = "What port the service should listen on for HTTP";
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.services."seercat.http-debug-server" = {
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Restart = "on-failure";
          ExecStart = "${pkg}/bin/http-debug-server ${toString cfg.port}";
          DynamicUser = "yes";
        };
      };
    };
  };
}
