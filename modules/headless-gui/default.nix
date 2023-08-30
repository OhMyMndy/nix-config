{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    x2goserver

  ];

}
