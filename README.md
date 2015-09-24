# x11docker/lxde-wine

LXDE desktop containing wine, wine-mono and gecko

Run wine on LXDE desktop in docker. Use script x11docker to run image. 

Creates a user 'xduser'; username can be changed with '-e XDUSER=username'<br>
Examples: <br>
x11docker --desktop run --rm x11docker/lxde-wine<br>
to include your host ~/.wine folder and run dockered desktop with same user name as on host:<br>
x11docker --desktop run -e XDUSER=$USER -v $HOME/.wine:$HOME/.wine:rw xdocker/lxde-wine 

known issues:
 - wine-gecko2.40 is installed, but seems to be not recognized
