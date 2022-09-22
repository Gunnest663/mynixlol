{ pkgs, config, lib, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Installed Packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.arcmenu
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
    osu-lazer
    github-desktop
    nix-index
    git
    neofetch
    htop
    wget
    protontricks
    fd
    unzip
    nixfmt
    spotify
    qt5ct
  ];

  # Enable Flatpak
  services.flatpak.enable = true;
}
