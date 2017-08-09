# x11docker/lxde-wine

LXDE desktop containing wine, winetricks, q4wine and playonlinux

 - Get [x11docker from github](https://github.com/mviereck/x11docker) to run GUI applications and desktop environments in docker images.
 - Use x11docker to run image. 

# Examples:
Run LXDE desktop including wine:
  - `x11docker --desktop x11docker/lxde-wine`

Use host folder to preserve installed Windows applications: 
  - `x11docker --desktop --home x11docker/lxde-wine`

Run Playonlinux with pulseaudio sound. Use host folder to preserve installed Windows applications:
 - `x11docker --home --pulseaudio x11docker/lxde-wine playonlinux`
 
# Fonts: chinese, japanese, korean
To enable chinese, japanese and korean fonts in wine, run `winetricks cjkfonts`. You can also use a starter provided on the desktop  for this. 

# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "lxde-wine desktop running in Xephyr window using x11docker")
