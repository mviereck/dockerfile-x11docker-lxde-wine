# x11docker/lxde-wine

LXDE desktop containing wine, wine-mono, wine-gecko, winetricks and playonlinux

 - Use x11docker to run image. 
 - Get [x11docker and x11docker-gui from github](https://github.com/mviereck/x11docker) to be able to run GUI applications and desktops from within docker images.

# Examples:
 - Run LXDE desktop including wine on separate, new X server:
  - `x11docker --desktop x11docker/lxde-wine`

 - Use host folder to preserve installed Windows applications. Create a container user similar to your host user to avoid file permission issues:
  - `x11docker --desktop --hostuser --home x11docker/lxde-wine start`

- Use host folder to preserve installed Windows applications. Create a container user similar to your host user to avoid file permission issues. Show lxde-wine in a window on your main desktop:
 - `x11docker --xephyr --desktop --hostuser --home x11docker/lxde-wine start`

- Use host folder to preserve installed Windows applications. Create a container user similar to your host user to avoid file permission issues. Show PlayOnLinux in a window on your main desktop:
 - `x11docker --xpra --hostuser --home x11docker/lxde-wine playonlinux`


# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "lxde-wine desktop running in Xephyr window using x11docker")
