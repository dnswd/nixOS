# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix Configuration
  nix = {
    settings = {
      trusted-users = ["root" "halcyon"];
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Nixpkgs allow unfree
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Keychron function keys
  # tells modprobe to pass fnmode=0 by default when loading the hid_apple kernel module
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=0
  '';

  networking.hostName = "msi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.utf8";
    LC_IDENTIFICATION = "id_ID.utf8";
    LC_MEASUREMENT = "id_ID.utf8";
    LC_MONETARY = "id_ID.utf8";
    LC_NAME = "id_ID.utf8";
    LC_NUMERIC = "id_ID.utf8";
    LC_PAPER = "id_ID.utf8";
    LC_TELEPHONE = "id_ID.utf8";
    LC_TIME = "id_ID.utf8";
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager = {
      sddm = {
        enable = true;
      };

      # Defer to home-manager configuration
      #  defaultSession = "home-manager";
      #  session = [
      #    {
      #      name = "home-manager";
      #      manage = "desktop";
      #      start = "exec $HOME/.xsession";
      #    }
      #  ];
    };
  };

  # services = {
  #   gnome.at-spi2-core.enable = true;
  #   gnome.gnome-keyring.enable = true;
  # };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable bluetooth support
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
    };
  };

  # Fonts
  fonts = {
    fonts = with pkgs; [
      fira-code
      twitter-color-emoji
      my.apple-nerd-fonts
    ];
    fontconfig = {
      defaultFonts = {
        emoji = ["Twitter Color Emoji"];
        monospace = ["LigaSF Mono Nerd Font" "FiraCode"];
        serif = [
          "New York Small"
          "New York Medium"
          "New York Large"
          "New York Extra Large"
        ];
        sansSerif = ["SF Pro Text" "SF Pro Display"];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "halcyon";
    extraGroups = ["networkmanager" "wheel" "docker" "audio"];

    # Authorized OpenSSH Keys
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCu47r2gzeMMc3PEJj7CVovonXpY6xOo+gUyeMNi6XzShlUqkBVoybQsZGP1y04EfqfylXIr6sIrV6GK0R+ucvFgIvg8FAiPXGFsxIQ5RHfT9cZcPwgQRMcWGc4+qKvdO7tYwu12eHRXeIgR8JaPvMJc5AguwSMNevFhWlVzdVZYOiYdj+hhJek+A/0BfTaQwUzSoMz28s+fSE3rILIbDu6wTYCvxnRyddV0B4/3VY87JZjeQgeLBNiXYRiACtqU1KQ7fDmYYfVTOgJVZL9uZ8Wr16OV/Jkcy0E9y3j/5NMi5g1gQmclRca8e+FZ5EsORNL5tBLFUJeWe9Jh2J/mb9WQOlJXyDLzMfyh6lTQdHlRN/c9rm03XHxFzcDa6qPVJQcCHrEsZwkPUt3mTEIK/EBrKpPsB/nq1IQtQgsM8FUlnGf9NHHsK2Cd5TeN/mHyTlEeG3PtGpZfIbR7I3DOgkCHNhkzE08mk8Gor7N2mtX7hTNT27rZuBJepbqK/qQcLM= halcyon"
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = ["/share/zsh"];

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "halcyon";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   xbomb
  # ];

  # Enable dconf for GTK
  programs.dconf.enable = true;
  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable docker
  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    # settings.kbdInteractiveAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
