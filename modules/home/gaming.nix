{ pkgs, config, inputs, ... }: 
{
  home.packages = with pkgs;[
    ## Utils
    gamemode
    gamescope
    # winetricks
    # inputs.nix-gaming.packages.${pkgs.system}.wine-ge

    ## Minecraft
    # prismlauncher

    ## Cli games
    vitetris
    
    ## Celeste
    #celeste-classic error
    #celeste-classic-pm

    ## Doom
    # gzdoom
    crispy-doom

    ## Emulation
    #sameboy
    #snes9x
    # cemu
    # dolphin-emu
    #rpcs3
    heroic
  ];
}
