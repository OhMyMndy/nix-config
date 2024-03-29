# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  environment.systemPackages = with pkgs; [
    microsoft-edge
    # xrdp
  ];

  # networking.firewall.allowedTCPPorts = [
  #   3389
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   3389
  # ];
  # services.xrdp = {
  #   enable = true;
  #   openFirewall = true;
  # };


  users.users.mschoep = {
    isNormalUser = true;
    description = "mschoep";
    shell = pkgs.zsh;
    initialPassword = "123";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    ];
  };
}
