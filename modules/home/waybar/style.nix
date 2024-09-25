{ ... }:
let custom = {
  font = "JetBrainsMono Nerd Font";
  font_size = "18px";
  font_weight = "bold";
  text_color = "#FBF1C7";
  background_0 = "#1D2021";
  background_1 = "#282828";
  border_color = "#928374";
  red = "#CC241D";
  green = "#98971A";
  yellow = "#FABD2F";
  blue = "#458588";
  magenta = "#B16286";
  cyant = "#689D6A";
  orange = "#D65D0E";
  opacity = "1";
  indicator_height = "2px";
};
in 
{
  programs.waybar.style = with custom; ''
  * {
    font-family: "JetBrains Mono Nerd Font";
    /*font-family: "JetBrainsMono Nerd Font";*/
    font-weight: bold; 
    font-size: 15px;
}

#custom-notification {
  font-family: "JetBrains Mono Nerd Font";
  font-size: 17px;
 color: #A1BDCE;
 margin: 2px 0px 0px 0px;
}

window#waybar {
    background: #0F0F17; 
  /*  border-radius: 15px; */
 /*  border: 2px solid #124323; */
/* border: 0px solid #A1BDCE; */
 border: 3px solid rgba(255, 255, 255, 0.1);
 border-radius: 10px;
}


tooltip {
        background: #171717;
        color: #A1BDCE;
        font-size: 13px;
        border-radius: 7px;
       border: 2px solid #101a24;


    }
#workspaces{
background: rgba(23, 23, 23, 0.0);
    color: #888789;
    box-shadow: none;
	text-shadow: none;
    border-radius: 9px;
    transition: 0.2s ease;
    padding-left: 4px;
    padding-right: 4px;
    padding-top: 1px;
}


#workspaces button {
background: rgba(23, 23, 23, 0.0);
    color: #A1BDCE;
    box-shadow: none;
	text-shadow: none;
    border-radius: 9px;
    transition: 0.2s ease;
    padding-left: 4px;
    padding-right: 4px;
 /*   animation: ws_normal 20s ease-in-out 1; */
}



#workspaces button.active {

 
  /* background-image: url("/home/anik/Documents/bar1.png");*/
    color: #A1BDCE;   
    transition: all 0.3s ease;
    padding-left: 4px;
    padding-right: 4px;
  /*  transition: all 0.4s cubic-bezier(.55,0.68,.48,1.682); */
}

#workspaces button:hover {
    background: none;
    color: #72D792;
    animation: ws_hover 20s ease-in-out 1;
    transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
}

#taskbar button {
    box-shadow: none;
	text-shadow: none;
	font-size: 4px;
    padding: 0px;
    border-radius: 9px;
    margin-bottom: 3px;
    margin-left: 0px;
    padding-left: 3px;
    padding-right: 3px;
    margin-right: 0px;
    color: @wb-color;
    animation: tb_normal 20s ease-in-out 1;
}

#taskbar button.active {
    background: @wb-act-bg;
    color: @wb-act-color;
    margin-left: 3px;
    padding-left: 12px;
    padding-right: 12px;
    margin-right: 3px;
    animation: tb_active 20s ease-in-out 1;
    transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
    min-height: 9px; 
}

#taskbar button:hover {
    background: @wb-hvr-bg;
    color: @wb-hvr-color;
    animation: tb_hover 20s ease-in-out 1;
    transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
}

#tray menu * {
    min-height: 16px;
    font-weight: bold;
    font-size: 13px;
    color: #9488e3;
}

#tray menu separator {
    min-height: 10px
}


#custom-spacer{
opacity: 0.0;
}
#custom-smallspacer{
opacity: 0.0;
}


#custom-mouse{
font-size: 14px;
margin-bottom: 6px;
background:  #161320;
}


#custom-power{
    font-size: 15px;
    color: #FFFFFF;
    background:  rgba(22, 19, 32, 0.9);
    margin: 6px 0px 6px 0px;
    padding-left: 4px;
    padding-right: 4px;
    }

#backlight{
    color: #2096C0;
    background: rgba(23, 23, 23, 0.0);
    font-weight: normal;
    font-size: 19px;
    margin: 1px 0px 0px 0px;
    padding-left: 0px;
    padding-right: 2px;
 
}
#bluetooth,
#custom-cliphist{
    color: #E6E7E7;
    background:  #161320;
    opacity: 1;
    margin: 4px 0px 4px 0px;
    padding-left: 4px;
    padding-right: 4px;
 
}
#battery{
    font-weight: normal;
    font-size: 22px;
    color: #a6d189;
    background:  rgba(23, 23, 23, 0.0);
    opacity: 1;
    margin: 0px 0px 0px 0px;
    padding-left: 0px;
    padding-right: 0px;
 
}

#idle_inhibitor{
color: #24966e;
background: @bar-bg;
    opacity: 1;
    margin: 4px 0px 4px 0px;
    padding-left: 4px;
    padding-right: 4px;

}
#clock{
    color: #A1BDCE;
    font-size: 15px;
    font-weight: 900;
    font-family: "JetBrains Mono Nerd Font";
    background: rgba(23, 23, 23, 0.0);
    opacity: 1;
    margin: 3px 0px 0px 0px;
    padding-left: 10px;
    padding-right: 10px;
    border: none;
    
}
#pulseaudio{
font-weight: normal;
font-size: 18px;
color: #6F8FDB;
    background:  rgba(22, 19, 32, 0.0);
    opacity: 1;
    margin: 0px 0px 0px 0px;
    padding-left: 3px;
    padding-right: 3px;
}
#cpu{
font-weight: normal;
font-size: 22px;
color: #915CAF;
}
#custom-led{
background: #427287;
color: #FFFFFF;
margin-top: 7px;
margin-bottom: 7px;
padding-left: 6px;
border-radius: 7px;
margin-right: 6px;
}
#custom-gpuinfo,
#custom-keybindhint,
#language,
#memory{
font-weight: normal;
font-size: 22px;
color: #E4C9AF;
}
#mpris{
color: white;
animation: repeat;
	animation-name: blink;
	animation-duration: 3s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

@keyframes blink {
    to {
        color: #4a4a4a;
        
    }
}
#network{
color: #A1BDCE;
font-weight: normal;
font-size: 19px;
padding-right: 0px;
padding-left: 4px
}
#custom-notifications,
#custom-spotify,
#taskbar,
#custom-theme,
#custom-menu{
color: #E8EDF0;
background:  rgba(23, 23, 23, 0.0);
margin: 0px 0px 0px 0px;
    padding-left: 1px;
    padding-right: 1px;
    opacity: 0.1
}
#tray,
#custom-updates,
#custom-wallchange,
#custom-wbar,
#window{
color: #A1BDCE;
font-family: "Martian Mono";
}
#custom-l_end,
#custom-r_end,
#custom-sl_end,
#custom-sr_end,
#custom-rl_end,
#cava,
#upower#headset,
#upower{
color: #a6d189;
}
#mpris{
font-size: 15px;
font-weight: bold
}
#custom-rr_end {
font-weight: normal;
    color: #E8EDF0;
    background:  rgba(23, 23, 23, 0.0);
    opacity: 1;
    margin: 0px 0px 0px 0px;
    padding-left: 4px;
    padding-right: 4px;
  ;
    
}

#backlight-slider slider,
#pulseaudio-slider slider {
  background: #A1BDCE;
  background-color: transparent;
  box-shadow: none;
  margin-right: 7px;
}

#backlight-slider trough,
#pulseaudio-slider trough {
  margin-top: -3px;
  min-width: 90px;
  min-height: 10px;
  margin-bottom: -4px;
  border-radius: 8px;
  background: #343434;
}

#backlight-slider highlight,
#pulseaudio-slider highlight {
  border-radius: 8px;
  background-color: #2096C0;
}

#battery.charging, #battery.plugged {
	color: #E8EDF0;
	
}


#battery.critical:not(.charging) {
    color: red;
}


#taskbar {
    padding: 1px;
}

#custom-r_end {
    border-radius: 0px 7px 7px 0px;
    margin-right: 1px;
    padding-right: 3px;
}

#custom-l_end {
    border-radius: 7px 0px 0px 7px;
    margin-left: 1px;
    padding-left: 3px;
}

#custom-sr_end {
    border-radius: 0px;
    margin-right: 1px;
    padding-right: 3px;
}

#custom-sl_end {
    border-radius: 0px;
    margin-left: 1px;
    padding-left: 3px;
}

#custom-rr_end {
    border-radius: 0px 7px 7px 0px;
    margin-right: 1px;
    padding-right: 3px;
}

#custom-rl_end {
    border-radius: 7px 0px 0px 7px;
    margin-left: 1px;
    padding-left: 3px;
}


/* Style for launchers */

#custom-expand {
    min-width: 25px;
    color: #A1BDCE;
    font-size: 16px;
}

#group-minimized {
    border-left: solid;
    border-left-width: 0.5;
}
  '';
}
