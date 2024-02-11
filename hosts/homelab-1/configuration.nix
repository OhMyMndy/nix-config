{ config, lib, pkgs, modulesPath, ... }:

{

  users.users.mandy = {
    isNormalUser = true;
    description = "Mandy";
    shell = pkgs.zsh;
    initialPassword = "123";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.neovim
    pkgs.vscode
    pkgs.google-chrome
    pkgs.tailscale
    pkgs.argocd
    pkgs.youtube-dl
    pkgs.yt-dlp
    pkgs.quickemu
    pkgs.virt-manager
    pkgs.virt-viewer
  ];

  # sudo virsh net-autostart default  
  programs.virt-manager = {
    enable = true;
  };
  virtualisation.libvirtd.enable = true;
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  services.openssh = {
    openFirewall = true;
    enable = true;
  };
  # systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    whitelist = {
      OhMyMndy = "811a12e1-b638-4af3-b7d1-a1aceac88e85";
      AlsoNoexi = "be3c8d48-4aa9-4394-a759-32a794466e8e";
    };
  };

  services.k3s = {
    enable = false;
    package = pkgs.unstable.k3s_1_28;
    extraFlags = "--write-kubeconfig-mode 644";
  };

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
