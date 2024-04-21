# TODO: https://unix.stackexchange.com/questions/379632/how-to-set-the-default-browser-in-nixos
{ config, pkgs, username, ... }:
let
  astroNvim = builtins.fetchGit {
    url = "https://github.com/AstroNvim/AstroNvim";
    ref = "refs/tags/v3.36.9";
    rev = "dad0bec1fef2833561d04ea446a544fbfde92539";
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
    terraform
    terraform-docs
    shellcheck
    jetbrains.idea-ultimate

    buildpack
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ibm-plex
  ];
  home.file.".config/nvim" = {
    source = "${astroNvim}";
    recursive = true;
  };
  home.file.".config/nvim/lua/user" = {
    source = ./source/.nvim;
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
      # see: https://stackoverflow.com/questions/18600188/home-end-keys-do-not-work-in-tmux
      bindkey  "^[OH"   beginning-of-line
      bindkey  "^[OF"   end-of-line

      bindkey  "^[[1~"   beginning-of-line
      bindkey  "^[[4~"   end-of-line
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
      # vimPlugins.telescope-fzf-native-nvim

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
    plugins = with pkgs.tmuxPlugins; [
      # vim-tmux-navigator
      # sensible
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_with_mouse off # or 'on'
          set -g @yank_action 'copy-pipe' # or 'copy-pipe-and-cancel' for the default

        '';
      }
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | (wl-copy || xsel -i --clipboard || xclip -selection clipboard || pbcopy || putclip || cat | clip.exe )'
        '';
      }

      {
        plugin = prefix-highlight;

        extraConfig = ''
          set -g @prefix_highlight_fg 'black'
          set -g @prefix_highlight_bg '#ff5f00'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    sensibleOnTop = true;
    extraConfig = ''
      setw -g mode-keys vi

      set -g pane-border-status top
      set-option -g repeat-time 200

      # Start windows and panes index at 1, not 0.
      set -g base-index 1
      setw -g pane-base-index 1

      # Ensure window index numbers get reordered on delete.
      set-option -g renumber-windows on

      # don't rename windows automatically
      set-option -g allow-rename off
      setw -g automatic-rename off
      set-window-option -g automatic-rename off


      set -g pane-border-style 'fg=#ff5f00,bg=black'
      set -g pane-active-border-style 'fg=black,bg=#ff5f00'
      set -g pane-border-status top
      set -g pane-border-format " #{pane_index} #{pane_title} "
      set-option -s set-clipboard on

      set -g @prefix_highlight_fg 'black'
      set -g @prefix_highlight_bg '#ff5f00'

      set -g status-interval 10
      set -g status on
      set -g status-left '#[fg=#ff5f00,bg=#444444] #(bash -c "printf \"\Uf011b\"") #[fg=white]#{=7:session_name} '
      set -g status-left-length 17


      set -g status-right '#{?pane_synchronized, #[bg=#ff5f00]#[fg=black]Sync Panes,}'
      set -ag status-right '#{prefix_highlight} #{window_flags}  '
      # set -ag status-right '#[fg=#ff5f00]#{continuum_status}#[default]  '
      set -ag status-right '#[fg=white]#(bash -c "printf \"\Uf02ca\"") #(timeout 1 df -h /root | tail -1 | awk "{ print \$3\"/\"\$2}") '
      set -ag status-right '#[fg=white]#(bash -c "printf \"\Uf035b\"") #(timeout 1 free -mh | head -n 2 | tail -n 1 | awk "{ print \$3\"/\"\$2}" ) '
      set -ag status-right '#[fg=white]#(timeout 1 cat /proc/loadavg | cut -f1 -d" ") '
      set -ag status-right '#[fg=white]#(timeout 1 date +"%d-%m-%Y %H:%M") '
      set -g status-right-length 150

      set -g message-command-style 'fg=black,bg=#ff5f00'
      set -g status-style 'fg=#ff5f00,bg=black'
      set -g message-style 'fg=black,bg=#ff5f00'
      set -g mode-style 'fg=black,bg=#ff5f00'

      # synchronize panes
      bind-key C-x set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"


      # history
      set-option -g history-limit 20000

      # window status
      setw -g window-status-format         "#[bg=colour235]#[fg=white] #{window_index} #{window_name} "
      setw -g window-status-current-format "#[bg=#ff5f00]#[fg=black] #{window_index} #{window_name} "

      # Scrolling for less etc.
      # @see https://www.reddit.com/r/tmux/comments/925w9t/how_to_scroll_the_pager_less_in_copy_mode/
      tmux_commands_with_legacy_scroll="nano less man bat"

      # Sane scrolling

      set -g @scroll-in-moused-over-pane "on"
      set -g @scroll-down-exit-copy-mode "on"
      set -g @scroll-speed-num-lines-per-scroll 3
      set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'


      bind-key -n C-S-Left swap-window -t -1\; select-window -t -1
      bind-key -n C-S-Right swap-window -t +1\; select-window -t +1

      bind-key -n C-S-M-Up resize-pane -U 10
      bind-key -n C-S-M-Down resize-pane -D 10
      bind-key -n C-S-M-Left resize-pane -L 10
      bind-key -n C-S-M-Right resize-pane -R 10


      
      unbind C-PageUp
      unbind C-PageDown
      # https://github.com/tmux/tmux/issues/140#issuecomment-302742783
      # 2.4+
      unbind -T copy-mode MouseDragEnd1Pane
      # 2.5+
      unbind -T copy-mode-vi MouseDragEnd1Pane
      
      # home/end
      bind-key -n Home send Escape "OH"
      bind-key -n End send Escape "OF"
    '';
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;
    mouse = true;
    clock24 = true;
    escapeTime = 10;
    keyMode = "vi";
    terminal = "tmux-256color";
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
