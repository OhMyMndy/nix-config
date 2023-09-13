# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
    ];


  # enable Nix Flakes and the new nix-command command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  programs.sysdig.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (python311.withPackages(ps: with ps; [ packaging google-cloud-asset google-cloud-compute google-cloud-bigquery ]))
    unstable.skaffold
    unstable.minikube
    file
    vscode
    git
    tig
    difftastic
    unzip
    bat
    tmux
    htop
    iftop
    iotop
    glances
    yq
    jq
    gnumake
    curl
    wget
    direnv
    fzf
    sops
    gnome.gnome-tweaks
    flatpak
    neovim
    gnumake
    cmake # to build nvim fzf-native
    gcc
    go
    nodejs_20
    rustc
    cargo
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.alpha
      google-cloud-sdk.components.beta
      google-cloud-sdk.components.kubectl
      google-cloud-sdk.components.skaffold
      google-cloud-sdk.components.minikube
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.config-connector
      google-cloud-sdk.components.cbt
    ])
    mariadb_1011
    terraform
    tflint
    nodePackages.nodemon
    shellcheck
    mutagen
    mutagen-compose
    docker-compose
    skopeo

    steampipe
  ];

  # virtualisation.podman = {
  #   dockerCompat = true;
  #   dockerSocket.enable = true;
  #   enable = true;
  # };

  virtualisation.vmware.guest.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # SEE: https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 2;
    };
  };

}
