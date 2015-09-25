# x11docker/lxde-wine

LXDE desktop containing wine, wine-mono and wine-gecko

Run wine on LXDE desktop in docker. <br>
Use x11docker to run image on new X server. <br>
Get x11docker script from github: https://github.com/mviereck/x11docker

Creates a user 'xduser'; username can be changed with option '-e XDUSER=username'<br>

#Examples: <br>
 - Run LXDE desktop including wine on separate, new X server:<br>
   x11docker --desktop run x11docker/lxde-wine<br>
 - Include your host ~/.wine folder and run dockered desktop with same user name as on host:<br>
   x11docker --desktop run -e XDUSER=$USER -v $HOME/.wine:$HOME/.wine:rw x11docker/lxde-wine 
 - Use host folder to preserve LXDE configurations and installed Windows applications:<br>
   x11docker --desktop run -e XDUSER=$USER -v $HOME/x11docker/lxde-wine:$HOME:rw x11docker/lxde-wine 


#known issues:
 - wine-gecko2.40 is installed, but seems to be not recognized
