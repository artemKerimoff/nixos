# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Swap + zram
  swapDevices = [
    { device = "/.swapvol/swapfile"; }
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # hybrid sleep
  boot.resumeDevice = "/dev/mapper/crypted";
  boot.kernelParams = [ "resume_offset=269568" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = false;
  networking.firewall.extraPackages = with pkgs; [
    iptables
  ];

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  services.upower.enable = true;

  programs.fuse.userAllowOther = true;

  virtualisation.waydroid.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  
  services.flatpak.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };


  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    ensureDatabases = ["mydatabase"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser    auth-method
      local all       postgres  peer
      local all       all       md5
      host  all       postgres  127.0.0.1/32 md5
      host  all       postgres  ::1/128      md5
      host  all       student   127.0.0.1/32 md5
      host  all       student   ::1/128      md5
    '';
  };

  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  services.input-remapper.enable = true;

  services.syncthing = {
    enable = true;
    user = "artem";
    dataDir = "/home/artem";
    configDir = "/home/artem/.config/syncthing";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.artem = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };

  programs.gamemode.enable = true;

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  programs.fish.enable = true;

  programs.niri = {
    enable = true;
    useNautilus = true;
  };
   
  programs.appimage.enable = true;

  programs.throne.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Добавьте сюда библиотеки, которые нужны вашей программе
    stdenv.cc.cc
    zlib
    fuse3
    fuse
    icu
    nss
    openssl
    curl
    expat
  ];


  # environment.sessionVariables = {
  #   _JAVA_AWT_WM_NONREPARENTING = "1";
  #   _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit";
  #   GDK_BACKEND = "wayland";
  # };


  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    helix
    kitty
    telegram-desktop
    v2rayn
    xwayland-satellite
    jetbrains.pycharm
    neovim-unwrapped
    libreoffice-fresh
    protonup-qt
    nur.repos.Ev357.helium
    android-studio
    flutter
    hydralauncher
    fuse3
    nautilus
    fish
    cool-retro-term
    qbittorrent
    input-remapper
    fishPlugins.tide
    labwc
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    wezterm
    foot
    dbeaver-bin
    scrcpy
    android-tools
    bun
    bubblewrap
    python3
    zip
    unzip
    onlyoffice-desktopeditors
    jq
    affinity-v3
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
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 3000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

