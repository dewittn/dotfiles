{
  ## ---- SYSTEM SETTINGS ---- 
  ## systemSettings = {
  #   system = "x86_64-linux"; # system arch
  #   hostname = "snowfire"; # hostname
  #   profile = "personal"; # select a profile defined from my profiles directory
  #   timezone = "America/Chicago"; # select timezone
  #   locale = "en_US.UTF-8"; # select locale
  #   bootMode = "uefi"; # uefi or bios
  #   bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
  #   grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
  #   gpuType = "amd"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
  # };
  # 
  # # ----- USER SETTINGS ----- #
  # userSettings = rec {
  #   username = "emmet"; # username
  #   name = "Emmet"; # name/identifier
  #   email = "emmet@librephoenix.com"; # email (used for certain configurations)
  #   dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
  #   theme = "io"; # selcted theme from my themes directory (./themes/)
  #   wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
  #   # window manager type (hyprland or x11) translator
  #   wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
  #   browser = "qutebrowser"; # Default browser; must select one from ./user/app/browser/
  #   spawnBrowser = if ((browser == "qutebrowser") && (wm == "hyprland")) then "qutebrowser-hyprprofile" else (if (browser == "qutebrowser") then "qutebrowser --qt-flag enable-gpu-rasterization --qt-flag enable-native-gpu-memory-buffers --qt-flag num-raster-threads=4" else browser); # Browser spawn command must be specail for qb, since it doesn't gpu accelerate by default (why?)
  #   defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
  #   term = "alacritty"; # Default terminal command;
  #   font = "Intel One Mono"; # Selected font
  #   fontPkg = pkgs.intel-one-mono; # Font package
  #   editor = "neovide"; # Default editor;
  # };

}