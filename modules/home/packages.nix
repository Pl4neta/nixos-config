{ inputs, pkgs, ... }: 
{
  home.packages = with pkgs; [

    ## CLI utility
    /*
    ani-cli
    bitwise                           # cli tool for bit / hex manipulation
    caligula                          # User-friendly, lightweight TUI for disk imaging
    cliphist                          # clipboard manager
    eza                               # ls replacement
    entr                              # perform action when file change
    fd                                # find replacement
    ffmpeg
    file                              # Show file information 
    gtt                               # google translate TUI
    gifsicle                          # gif utility
    gtrash                            # rm replacement, put deleted files in system trash
    hexdump
    imv                               # image viewer
    killall
    lazygit
    libnotify
	  man-pages					            	  # extra man pages
    mpv                               # video player
    ncdu                              # disk space
    nitch                             # systhem fetch util
    openssl
    onefetch                          # fetch utility for git repo
    pamixer                           # pulseaudio command line mixer
    playerctl                         # controller for media players
    poweralertd
    programmer-calculator
    qview                             # minimal image viewer
    ripgrep                           # grep replacement
    tdf                               # cli pdf viewer
    tldr
    todo                              # cli todo list
    toipe                             # typing test in the terminal
    ttyper                            # cli typing test
    unzip
    valgrind                          # c memory analyzer
    wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
    wget
    yazi                              # terminal file manager
    yt-dlp-light
    xdg-utils
    xxd

    ## CLI 
    cbonsai                           # terminal screensaver
    cmatrix
    pipes                             # terminal screensaver
    sl
    tty-clock                         # cli clock

    ## GUI Apps
    audacity
    bleachbit                         # cache cleaner
    gimp
    libreoffice
    nix-prefetch-github
    pavucontrol                       # pulseaudio volume controle (GUI)
    qalculate-gtk                     # calculator
    soundwireserver                   # pass audio to android phone
    vlc
    winetricks
    wineWowPackages.wayland
    zenity

    # C / C++
    gcc
    gdb
    gnumake

    # Python
    python3
    python312Packages.ipython

    inputs.alejandra.defaultPackage.${system}
    */

        #bluez (bluetooth, alternative maybe)
        brightnessctl
        vscode
        ddcutil # control external monitor brightness
        eww
        firefox
        godot3
        inkscape
        kitty
        libresprite
        lf
        lutris
        mupdf
        obs-studio
        obsidian
        pavucontrol
        playerctl
        #qemu
        qjackctl
        rofi-wayland
        signal-desktop
	steam
        sunshine
        trashy
        unzip
        vlc
        wev
        wine-wayland
        wireplumber
        zip

	qimgv
	bat
	
	inputs.zen-browser.packages."${system}".default
	inputs.hyprpanel.packages."${system}".default
	inputs.nixvim.packages."${system}".default
	vesktop
	discord

	rustup
	gcc

	go

	wl-clipboard

	#qemu

	sway-contrib.grimshot

	ani-cli

	scarab #hollow knight mod manager
  ];
}
