{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" ];
  services.xserver.desktopManager.gnome.enable = true;  

  # ─── Boot ────────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ─── Host & Network ─────────────────────────────────────────────────────────
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  services.timesyncd.enable = true;
  time.timeZone = "Asia/Kolkata";

  # ─── Locale ─────────────────────────────────────────────────────────────────
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # ─── Allow unfree software ──────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport  = true;

  # ─── Audio (PipeWire) ───────────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable          = true;
    alsa.enable     = true;
    alsa.support32Bit = true;
    pulse.enable    = true;
    jack.enable     = true;
  };

  # ─── NVIDIA ─────────────────────────────────────────────────────────────────
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open    = false;   # Changed to false for better Hyprland compatibility
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ─── Printing / Scanning ────────────────────────────────────────────────────
  services.printing = {
    enable       = true;
    webInterface = true;
    drivers      = [ pkgs.hplipWithPlugin ];
  };
  hardware.sane = {
    enable        = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  networking.firewall.allowedTCPPorts = [ 631 ];

  # ─── Display ────────────────────────────────────────────────────────────────
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # ─── Hyprland (STABLE VERSION - NO RATE LIMIT) ─────────────────────────────
  programs.hyprland.enable = true;

  # XDG portals
  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ─── Environment Variables for NVIDIA + Wayland ────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    __GL_VRR_ALLOWED = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };

  # ─── Keyboard layout ────────────────────────────────────────────────────────
  services.xserver.xkb.layout = "us";

  # ─── Users & Shells ─────────────────────────────────────────────────────────
  users.users.sunless = {
    isNormalUser = true;
    description  = "sunless";
    shell        = pkgs.zsh;
    extraGroups  = [ "networkmanager" "wheel" "libvirtd" "kvm" "docker" ];
  };
  programs.zsh.enable = true;

  # ─── Virtualisation ─────────────────────────────────────────────────────────
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable   = true;
  programs.virt-manager.enable   = true;

  # ─── Packages ───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Dev tools
    gcc clang gnumake cmake nasm flex bison m4
    gdb lldb valgrind strace binutils elfutils patchelf
    rustc cargo rust-analyzer zig
    llvmPackages_18.llvm llvmPackages_18.clang llvmPackages_18.libllvm catch2
    cudatoolkit
    pkgsCross.gnu32.buildPackages.gcc
    python3Full python3Packages.pip python3Packages.virtualenv nodejs

    # Editors / IDEs
    neovim vscode

    # CLI utilities
    git curl wget unzip pciutils usbutils stow
    tmux ripgrep fd bat eza yazi ghostty

    # Browsers
    google-chrome firefox

    # Desktop apps
    spotify davinci-resolve pavucontrol file-roller nautilus blueman

    # Hyprland ecosystem
    kitty rofi-wayland waybar swww mako grim slurp wl-clipboard
    brightnessctl pamixer playerctl networkmanagerapplet
    xdg-desktop-portal-hyprland   
];

  # ─── Fonts ──────────────────────────────────────────────────────────────────
fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];
};

  system.stateVersion = "25.05";
}
