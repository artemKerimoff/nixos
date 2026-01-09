{
  inputs,
  pkgs,
  ...
}: {
  home.username = "artem";
  home.homeDirectory = "/home/artem";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  programs.zsh.initContent = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
  '';

  home.packages = [
    inputs.ambxst.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.zsh-powerlevel10k
    pkgs.discord
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
    };
  };

  xdg.desktopEntries.discord = {
    name = "Discord (wl version)";
    exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland --proxy-server=socks5://127.0.0.1:7890 %U";
    icon = "discord";
    terminal = false;
    categories = ["Network" "InstantMessaging"];
  };
}
