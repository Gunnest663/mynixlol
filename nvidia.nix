{ pkgs, config, lib, ... }:

{
  # Enable Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Workaround for Nvidia suspending on Wayland
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
}
