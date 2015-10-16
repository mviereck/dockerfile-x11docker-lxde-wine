# x11docker/lxde-wine

LXDE desktop containing wine, wine-mono and wine-gecko

 - Run LXDE desktop in docker. 
 - Use x11docker to run image. 
 - Get x11docker script from github: 
https://github.com/mviereck/x11docker 
 - Raw x11docker script:
https://raw.githubusercontent.com/mviereck/x11docker/e49e109f9e78410d242a0226e58127ec9f9d6181/x11docker

# Examples:
 - Run LXDE desktop including wine on separate, new X server:
  - x11docker --desktop x11docker/lxde-wine

 - Use host folder to preserve installed Windows applications. Create a container user similar to your host user to avoid file permission issues:
   - x11docker --desktop --hostuser --home x11docker/lxde-wine 

# known issues:
 - wine-gecko2.40 is installed, but seems to be not recognized
