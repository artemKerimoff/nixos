{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.zen-browser.homeModules.beta
    inputs.codex-desktop.homeManagerModules.default
  ];

  programs.zen-browser.enable = true;
  programs.noctalia-shell.enable = true;
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

  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
    obsidian
    vesktop
    bibata-cursors
  ];
}
