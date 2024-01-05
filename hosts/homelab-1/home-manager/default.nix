{ config, pkgs, username, ... }:

{
  imports =
    [
        ../../../modules/home-manager
    ];

  systemd.user.services.mutagen-daemon = {
    Unit = {
      Description = "Mutagen daemon";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "mutagen-daemon" ''
        #!/run/current-system/sw/bin/bash
        ${pkgs.mutagen}/bin/mutagen daemon run
      ''}";
    };
  };
  systemd.user.startServices = "sd-switch";

}
