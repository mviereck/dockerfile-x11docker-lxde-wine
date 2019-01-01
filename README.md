# x11docker/lxde-wine

LXDE desktop containing wine, winetricks, q4wine and playonlinux

 - Get [x11docker from github](https://github.com/mviereck/x11docker) to run GUI applications and desktop environments in docker images.
 - Use x11docker to run image. 

# Examples:
Run LXDE desktop including wine:
  - `x11docker --desktop x11docker/lxde-wine`

Use host folder to preserve installed Windows applications with option `--home`: 
  - `x11docker --desktop --home x11docker/lxde-wine`

Run PlayOnLinux only:
  - `x11docker --home x11docker/lxde-wine playonlinux`

# Options:
 - Persistent home folder stored on host with   `--home`
 - Shared host folder with                      `--sharedir DIR`
 - Hardware acceleration with option            `--gpu`
 - Clipboard sharing with option                `--clipboard`
 - Sound support with option                    `--pulseaudio` or `--alsa`
 - Language setting with                        `--lang=$LANG`
 - Printing over CUPS with                      `--printer`
 - Webcam support with                          `--webcam`
 
See `x11docker --help` for further options.

# Language
The default language locale setting is `en_US.UTF-8`. You can change to your desired locale with x11docker option `--lang`. 

 - Example for german: `--lang de`
 - Example for chinese: `--lang zh_CN`
 - Example for host setting: `--lang $LANG`
 
# Fonts: chinese, japanese, korean
To enable chinese, japanese and korean fonts in wine, run `winetricks cjkfonts`. There is also a starter provided on the desktop  for this. 

# Extend image
To add your desired applications, create your own Dockerfile with this image as a base. Example:
```
FROM x11docker/lxde-wine
RUN apt-get update
RUN apt-get install -y vlc
```

# Screenshot

![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxde-wine.png "lxde-wine desktop running in Xephyr window using x11docker")
