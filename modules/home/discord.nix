{ pkgs, ... }: 
{
  home.packages = with pkgs; [
    # discord
    /*(discord.override { 
     withVencord = true; 
    })*/
    vesktop
  ];
}
