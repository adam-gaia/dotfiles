{config, pkgs, lib, ...}:
{
  systemd.user.services = {
    protonmail-bridge = {
      Unit = {
        Description = "ProtonMail Bridge";
        Documentation = [ "https://proton.me/mail/bridge" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "offlineimap.service" ];
      };
    };
    offlineimap = {
      Unit = {
        Description = "Offlineimap";
        Documentation = [ "https://github.com/OfflineIMAP/offlineimap3" ];
        Wants = [ "protonmail-bridge.service" ];
        After = [ "protonmail-bridge.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.offlineimap}/bin/offlineimap";
        Restart = "always";
      };
    };
  }; 
}
