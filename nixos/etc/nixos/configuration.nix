# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "nixos";

  # Networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Asia/Kolkata";

  # Locale settings
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

  # Keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing support
  services.printing.enable = true;

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users.sunless = {
    isNormalUser = true;
    description = "sunless";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "docker" ];
    packages = with pkgs; [
      # Add user-specific packages here if needed
    ];
  };

  # NVIDIA + Wayland + GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
  };

  hardware.opengl.enable = true;

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  # Development tools and common software
  environment.systemPackages = with pkgs; [
    # Compilers & toolchains
    gcc clang llvm rustc cargo rust-analyzer zig
    gdb lldb valgrind strace binutils elfutils patchelf

    # CUDA
    cudatoolkit

    # Editors
    vscode neovim

    # Terminal
    ghostty

    # Shell
    zsh

    # Browsers
    google-chrome firefox

    # Python & Node.js
    python3Full
    python3Packages.pip
    python3Packages.virtualenv
    nodejs

    # Container tools
    docker docker-compose

    # Modern CLI tools
    tmux ripgrep fd bat eza

    # Utilities
    git curl wget unzip pciutils usbutils
    pkgs.spotify
    pkgs.stow
    pkgs.yazi
];


  programs.zsh.enable = true;
  # Virtualization (KVM + libvirt)
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Docker support
  virtualisation.docker.enable = true;

  # Fonts
  #fonts = {
  #  enableDefaultPackages = true;
  #  packages = with pkgs; [
  #    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  #  ];
  #};

  # Ghostty configuration (optional, if not using Home Manager)
  #environment.etc."ghostty/config".text = ''
  #  theme = "Catppuccin Mocha"
  #  font-family = "FiraCode Nerd Font"
  #  font-size = 13
  #  padding-x = 6
  #  padding-y = 4
  #'';

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System version
  system.stateVersion = "25.05"; # Do not change after installation!
}
