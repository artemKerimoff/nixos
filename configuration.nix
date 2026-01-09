# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    /home/artem/Happ/happ-desktop-nix/module.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-fc112f5c-1d11-403a-b02d-6b80fef1c28e".device = "/dev/disk/by-uuid/fc112f5c-1d11-403a-b02d-6b80fef1c28e";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.happd = {
    enable = true;

    # ВАЖНО: явно указываем пакет
    package = pkgs.callPackage /home/artem/Happ/happ-desktop-nix/default.nix {};
  };

  # Virtualization
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;

  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #  services.xserver.xkb = {
  #    layout = "ru";
  #    variant = "";
  #  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  programs.zsh.enable = true;

  users.users.artem = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "artem";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "kvm"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
  };

  # MongoDB service
  services.mongodb.enable = true;
  services.mongodb.package = pkgs.mongodb-ce;

  # PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureDatabases = ["mydatabase"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser    auth-method
      local all       postgres  peer
      local all       all       md5
      host  all postgres 127.0.0.1/32 md5
      host  all postgres ::1/128      md5
      host  all       student   127.0.0.1/32   md5
      host  all       student   ::1/128        md5
    '';
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs:
      with pkgs; [
        # Добавьте сюда libepoxy и любые другие недостающие библиотеки
        libepoxy
        # Возможно, вам понадобятся другие библиотеки в будущем, например:
        # xorg.libX11
        # stdenv.cc.cc.lib
        # zlib
        # icu
      ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  qt = {
    enable = true;
  };

  # kirigami path
  environment.variables = {
    # Append kirigami QML root (no hash in config)
    QML2_IMPORT_PATH =
      "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      + ":${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
      + ":${pkgs.qt6.qtbase}/lib/qt-6/qml"
      + ":$QML2_IMPORT_PATH";
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      material-symbols
      # material-icons  # можно оставить, но обычно не обязателен
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Основные системные
    stdenv.cc.cc
    zlib
    openssl

    # X11 / Графика
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXfixes
    libGL
    libglvnd
    mesa

    # GTK и Electron
    gtk3
    gtk2
    atk
    at-spi2-atk
    gdk-pixbuf
    pango
    cairo
    glib
    dbus

    # Шрифты и звук
    freetype
    fontconfig
    alsa-lib
    libpulseaudio

    # Браузерные (NSS, NSPR)
    nss
    nspr

    # Kerberos (из-за libcom_err ранее)
    e2fsprogs
    krb5

    # Другие частые
    cups
    expat
    libdrm
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [(import ./discord-overlay.nix)];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vscode
    git
    nodejs
    pnpm
    onlyoffice-desktopeditors
    telegram-desktop
    alsa-utils
    gh
    docker
    docker-compose
    python3
    python313Packages.pip
    python313Packages.virtualenv
    wl-clipboard
    nitch
    wine
    zed-editor
    dpkg
    libepoxy
    appimage-run
    steam-run
    nftables
    steam
    pgadmin4-desktopmode
    prisma
    prisma-engines
    nerd-fonts.jetbrains-mono
    p7zip
    libreoffice-qt
    ripgrep
    quickshell
    cliphist
    wireplumber
    grim
    slurp
    matugen
    kdePackages.qt5compat
    kdePackages.qtpositioning
    kdePackages.kirigami
    kdePackages.qtdeclarative
    kdePackages.qtbase
    kdePackages.syntax-highlighting
    foot
    material-symbols
    material-icons
    kdePackages.qtquicktimeline
    adementary-theme
    kdePackages.dolphin
    virtualbox
    go
    copilot-cli
    fastfetch
    v2rayn
    v2ray
    xray
    v2ray-geoip
    mihomo
    file
    xorg.xhost
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    libgccjit
    goreman
    bun
    dpkg
    jq
    obsidian
    helix
    discord
    tree
    typst
  ];

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
  system.stateVersion = "25.11"; # Did you read the comment?
}
