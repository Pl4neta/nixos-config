{ pkgs, config, ... }:
let 
  monolisa = pkgs.callPackage ../../pkgs/monolisa/monolisa.nix {}; 
  monolisa-nerd = pkgs.callPackage ../../pkgs/monolisa/monolisa-nerd.nix { inherit monolisa; }; 
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [
      "JetBrainsMono"
      "FiraCode"
      "CascadiaCode"
      "NerdFontsSymbolsOnly"
    ]; })
    #twemoji-color-font
    #noto-fonts-emoji
    # monolisa
    # monolisa-nerd

    noto-fonts
    montserrat
    jetbrains-mono
    open-sans
    commit-mono
  ];

  gtk = {
    enable = true;
    font = {
      name = "CaskaydiaCove Nerd Font";
      size = 12;
    };
    theme = {
      name = "Catppuccin-Macchiato";
      package = pkgs.catppuccin-gtk.override {
        variant = "macchiato";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "black";
      };
    };
    cursorTheme = {
      name = "catppuccin-macchiato-light-cursors";
      package = pkgs.catppuccin-cursors.macchiatoLight;
      size = 24;
    };
  };
  
  home.pointerCursor = {
    name = "catppuccin-macchiato-light-cursors";
    package = pkgs.catppuccin-cursors.macchiatoLight;
    size = 24;
  };
}
