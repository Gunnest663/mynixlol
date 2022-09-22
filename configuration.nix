{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix 
    ./steam.nix 
    ./packages.nix
  ];

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
  networking.hostName = "KakuPC";
  # networking.wireless.enable = true;

  # Time Zone
  time.timeZone = "Australia/Perth";

  # Internationalisation properties
  i18n.defaultLocale = "en_AU.utf8";

  # X11 windowing system.
  services.xserver.enable = true;

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
