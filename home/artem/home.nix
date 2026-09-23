{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.codex-desktop.homeManagerModules.default
  ];

  programs.zen-browser.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };
  programs.codexDesktopLinux = {
    enable = true;
    computerUseUi.enable = true;
    remoteMobileControl.enable = true;
    remoteControl.enable = true;
  };

  home.username = "artem";
  home.homeDirectory = "/home/artem";
  home.stateVersion = "25.11";
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.sessionVariables.EDITOR = "nvim";
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };  

  gtk = {
    enable = true;
    cursorTheme = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    };
  };

  programs.git = {
    enable = true;
    settings = {  
      user.name = "artemKerimoff";
      user.email = "4bsolutefleur@gmail.com";
    };
  };
  
  programs.zsh.enable = true;

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.minimal-tmux-status;
        extraConfig = ''
          set -g @minimal-tmux-use-arrow true
          set -g @minimal-tmux-right-arrow ""
          set -g @minimal-tmux-left-arrow ""
        '';
      }
    ];
  
    extraConfig = ''
      setw -g pane-base-index 1
      set -g renumber-windows on

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
  
      bind c new-window -c "#{pane_current_path}"
  
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
  
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
  
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
  
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };

  programs.nushell = {
    enable = true;

    extraConfig = ''
      $env.config.show_banner = false
      fastfetch
    '';
  };
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  services.easyeffects.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    obsidian
    vesktop
    bibata-cursors
    neovim
    
    go
    gopls
    gotools
    gofumpt
    golangci-lint
    delve
    gotestsum
  ];
}
