# TODO: https://unix.stackexchange.com/questions/379632/how-to-set-the-default-browser-in-nixos
{ config, pkgs, username, ... }:
let
  astroNvim = builtins.fetchGit {
    url = "https://github.com/AstroNvim/AstroNvim";
    ref = "main"; # replace with desired branch, tag, or commit hash
    rev = "26aedacec6a3d2aeba44c365360b3ba3637b20ca";
  };
in
{

  home.stateVersion = "23.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";
  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    openssl
    wireshark
    binutils
    nixpkgs-fmt
    tree-sitter-grammars.tree-sitter-nix
    ripgrep
    thefuck
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.space-bar
    gnomeExtensions.sound-output-device-chooser
    albert
    google-cloud-sdk
    terraform
    shellcheck
    jetbrains.idea-ultimate
    jetbrains.phpstorm

    buildpack
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ibm-plex
  ];
  home.file.".config/nvim" = {
    source = "${astroNvim}";
    recursive = true;
  };
  home.file.".ideavimrc".source = ./source/.ideavimrc;

  # config.lib.file.mkOutOfStoreSymlink 
  home.file.".config/albert/albert.conf".source = ./source/albert.conf;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "terraform"
        "tmux"
        "fzf"
        "gcloud"
        "thefuck"
        "direnv"
        "docker"
        "docker-compose"
        "kubectl"
      ];
      theme = "robbyrussell";

    };
    initExtra = ''
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[F"   end-of-line
      
      export MANPAGER='nvim +Man!' 
      export PAGER='nvim +Man!'
    '';
  };

  programs.neovim = {
    enable = true;
    #   defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs; [
      vimPlugins.nvim-treesitter
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-treesitter-textobjects
      vimPlugins.nvim-treesitter-refactor
      vimPlugins.telescope-nvim

      vimPlugins.tokyonight-nvim

      vimPlugins.vim-nix
    ];
    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = "a"
      vim.opt.colorcolumn = "80"

    '';
  };
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    extraConfig = ''
      	  set -g mouse on
      	  set -g pane-border-status top
      	  setw -g mode-keys vi
      	  set -g default-terminal "xterm-256-color"
      	'';
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;
    #    mouse = true;
    # clock24 = true;
  };

  # see https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      "switch-input-source" = [ ];
      "switch-input-source-backward" = [ ];
      "switch-to-workspace-1" = [ "<Super>1" ];
      "switch-to-workspace-2" = [ "<Super>2" ];
      "switch-to-workspace-3" = [ "<Super>3" ];
      "switch-to-workspace-4" = [ "<Super>4" ];
      "switch-to-workspace-5" = [ "<Super>5" ];
      "switch-to-workspace-6" = [ "<Super>6" ];
      "switch-to-workspace-7" = [ "<Super>7" ];
      "switch-to-workspace-8" = [ "<Super>8" ];
      "switch-to-workspace-9" = [ "<Super>9" ];
      "switch-to-workspace-10" = [ "<Super>10" ];
    };
    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = "10";
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };
    "org/gnome/desktop/interface" = {
      "enable-hot-corners" = false;
      "monospace-font-name" = "JetBrainsMonoNL Nerd Font Mono 10";
      "font-name" = "IBM Plex Sans 11";
      "document-font-name" = "IBM Plex Sans 11";
      "titlebar-font" = "IBM Plex Sans Bold 11";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      "binding" = "<Super>space";
      "command" = "albert toggle";
      name = "Albert";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "caffeine@patapon.info"
        "space-bar@luchrioh"
        "sound-output-device-chooser@kgshank.net"
      ];
      "favorite-apps" = [
        "org.gnome.Nautilus.desktop"
        "vivaldi-stable.desktop"
        "microsoft-edge.desktop"
        "org.gnome.Console.desktop"
        "code.desktop"
        "idea-ultimate.desktop"
        "carla.desktop"
        "org.rncbc.qjackctl.desktop"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      "dash-max-icon-size" = 32;
      "preferred-monitor" = -2;
      "dock-position" = "BOTTOM";
      "dock-fixed" = true;
      "show-trash" = false;
      "show-mounts" = false;
      "hot-keys" = false;
      "click-action" = "focus-minimize-or-appspread";
      "disable-overview-on-startup" = true;
      "custom-theme-shrink" = true;
    };
  };


}
