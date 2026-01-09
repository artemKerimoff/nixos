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
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
    };
  };
}
