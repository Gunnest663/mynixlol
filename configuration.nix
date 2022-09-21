{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---  Workaround for Nvidia suspending on Wayland
  systemd.services.gnome-shell-suspend = {
    enable = true;
    script = ''
      ${pkgs.killall}/bin/killall -STOP .gnome-shell-wr
    '';
    before = [
      "systemd-suspend.service"
      "systemd-hibernate.service"
      "nvidia-suspend.service"
      "nvidia-hibernate.service"
    ];
    serviceConfig = { Type = "oneshot"; };
    wantedBy = [ "systemd-suspend.service" "systemd-hibernate.service" ];
  };

  systemd.services.gnome-shell-resume = {
    enable = true;
    script = ''
      ${pkgs.killall}/bin/killall -CONT .gnome-shell-wr
    '';
    after = [
      "systemd-suspend.service"
      "systemd-hibernate.service"
      "nvidia-suspend.service"
      "nvidia-hibernate.service"
    ];
    serviceConfig = { Type = "oneshot"; };
    wantedBy = [ "systemd-suspend.service" "systemd-hibernate.service" ];
  };
  # ---

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root C0B4-0696
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  # networking.wireless.enable = true;

  # Time Zone
  time.timeZone = "Australia/Perth";

  # Internationalisation properties
  i18n.defaultLocale = "en_AU.utf8";

  # X11 windowing system.
  services.xserver.enable = true;

  # Enable Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Enable GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  # Enable Printing
  services.printing.enable = true;

  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # User Account
  users.users.sensokaku = {
    isNormalUser = true;
    description = "Sensokaku";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Installed Packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.arcmenu
    steam
    (pkgs.writeShellApplication {
      name = "discord";
      text = "${pkgs.discord}/bin/discord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "discord";
      desktopName = "Discord";
    })
    google-chrome
    obs-studio
    vscode
    nix-index
    git
    neofetch
    htop
    wget
    fd
    unzip
    nixfmt
    spotify
    qt5ct
  ];

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Qt Theme
  qt5 = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gnome";
  };

  # Enable OpenSSH daemon
  # services.openssh.enable = true;

  # Firewall Porting
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # NixOS Version
  system.stateVersion = "22.05";
}
