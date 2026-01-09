final: prev: {
  discord = prev.discord.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        wrapProgram $out/bin/Discord \
          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --proxy-server='socks5://127.0.0.1:7890'"
      '';
  });
}
