{ config, pkgs, inputs, username, host, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hardware.graphics.enable = true;
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.open = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.pam.services = {
    sddm.enableKwallet = true;
    sddm.enableGnomeKeyring = true;
    login.enableKwallet = true;
    login.enableGnomeKeyring = true;
  };

  services.resolved = {
    enable = true;
    # Disable local broadcasting which can confuse some routers
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.1.1.1 8.8.8.8
      LLMNR=false
      MulticastDNS=false
    '';
  };

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  networking = {
    hostName = host;
    networkmanager.enable = true;
    enableIPv6 = false;
    nameservers = [ 
      "1.1.1.1"
      "8.8.8.8" 
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    glib
    util-linux
  ];

  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  console.keyMap = "pt-latin1";
  services.xserver = {
    enable = true;
    xkb = {
      layout = "pt";
      variant = "";
    };
  };
  
  services.libinput.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "main user";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.bash;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.waybar.enable = true;
  programs.hyprlock.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  services.upower.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    kitty
    rofi
    dunst
    hyprpolkitagent
    swww
    lm_sensors
    bluetui
    bluez
    bluez-tools
    libnotify
    brightnessctl
    lenovo-legion
    playerctl
    unzip
    kdePackages.kwallet-pam
  ];

  qt.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
