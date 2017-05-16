# x11docker/lxde-wine
# Run wine on Xfce desktop in docker. 
# Use x11docker to run image. 
# Get x11docker script and x11docker-gui from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --wm=none x11docker/lxde-wine
#           x11docker x11docker/lxde-wine playonlinux
#
# Use option --home to create a persistant home folder preserving your wine installations.
# Examples: x11docker --wm=none --home x11docker/lxde-wine
#           x11docker --home x11docker/lxde-wine playonlinux
#
# To have pulseaudio sound, add option --pulseaudio.
# To have hardware accelerated graphics, use option --gpu.


FROM x11docker/lxde:latest
RUN echo "deb http://deb.debian.org/debian stretch contrib" >> /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt-get update

# install wine
RUN apt-get install -y wine wine32 wine64
RUN apt-get install -y fonts-wine winetricks ttf-mscorefonts-installer winbind
# wine gecko
RUN mkdir -p /usr/share/wine/gecko
RUN cd /usr/share/wine/gecko && wget http://dl.winehq.org/wine/wine-gecko/2.40/wine_gecko-2.40-x86.msi
# wine mono
RUN mkdir -p /usr/share/wine/mono
RUN cd /usr/share/wine/mono && wget https://dl.winehq.org/wine/wine-mono/4.7.0/wine-mono-4.7.0.msi

# install playonlinux
RUN apt-get install -y playonlinux xterm gettext

# install q4wine, another frontend for wine
RUN apt-get install -y q4wine

## some X libs, f.e. allowing videos in Xephyr
RUN apt-get install -y --no-install-recommends x11-utils libxv1

## OpenGL support
RUN apt-get install -y mesa-utils mesa-utils-extra libgl1-mesa-glx libglew2.0 libglu1-mesa libgl1-mesa-dri libdrm2 libgles2-mesa libegl1-mesa

## Pulseaudio support
RUN apt-get install -y --no-install-recommends pulseaudio
# enable one of the following to get sound controls
RUN apt-get install -y --no-install-recommends pasystray
# RUN apt-get install -y --no-install-recommends pavucontrol

# dillo browser: not needed for wine, but useful to download windows applications
RUN apt-get install -y dillo

# PDF viewer evince-gtk
RUN apt-get install -y evince-gtk

# create desktop icons that will be copied to every new user
#
RUN mkdir /etc/skel/Desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Play on Linux\n\
Exec=playonlinux\n\
Icon=playonlinux\n\
" > /etc/skel/Desktop/PlayOnLinux.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Q4wine\n\
Exec=q4wine\n\
Icon=q4wine\n\
" > /etc/skel/Desktop/Q4wine.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Internet Explorer\n\
Exec=wine iexplore\n\
Icon=applications-internet\n\
" > /etc/skel/Desktop/WineInternetExplorer.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=WineConsole\n\
Exec=wineconsole\n\
Icon=utilities-terminal\n\
" > /etc/skel/Desktop/WineConsole.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=File Explorer\n\
Exec=wine explorer\n\
Icon=folder\n\
" > /etc/skel/Desktop/WineExplorer.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Notepad\n\
Exec=wine notepad\n\
Icon=wine-notepad\n\
" > /etc/skel/Desktop/WineNotepad.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Wordpad\n\
Exec=wine wordpad\n\
Icon=accessories-text-editor\n\
" > /etc/skel/Desktop/WineWordpad.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Configure Wine\n\
Exec=winecfg\n\
Icon=wine-winecfg\n\
" > /etc/skel/Desktop/WineCfg.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Wine File Manager\n\
Exec=winefile\n\
Icon=folder-wine\n\
" > /etc/skel/Desktop/WineFile.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Mines\n\
Exec=wine winemine\n\
Icon=face-cool\n\
" > /etc/skel/Desktop/WineMine.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=winetricks\n\
Exec=winetricks --gui\n\
Icon=wine\n\
" > /etc/skel/Desktop/winetricks.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=RegEdit\n\
Exec=regedit\n\
Icon=preferences-system\n\
" > /etc/skel/Desktop/WineRegEdit.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=UnInstaller\n\
Exec=wine uninstaller\n\
Icon=wine-uninstaller\n\
" > /etc/skel/Desktop/WineUnInstaller.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=TaskManager\n\
Exec=wine taskmgr\n\
Icon=utilities-system-monitor\n\
" > /etc/skel/Desktop/WineTaskmgr.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Wine Control Panel\n\
Exec=wine control\n\
Icon=preferences-system\n\
" > /etc/skel/Desktop/WineControl.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=OleView\n\
Exec=wine oleview\n\
Icon=preferences-system\n\
" > /etc/skel/Desktop/WineOleView.desktop


# create startscript 
RUN echo '#! /bin/bash\n\
[ "$HOME" = "/tmp" ] && export HOME=/tmp/fakehome && mkdir -p $HOME
if [ ! -e "$HOME/.config" ] ; then\n\
  cp -R /etc/skel/. $HOME/ \n\
  cp -R /etc/skel/* $HOME/ \n\
fi\n\
if [ "$*" = "" ] ; then \n\
  openbox --sm-disable &\n\
  pcmanfm --desktop &\n\
  lxpanel \n\
else \n\
  eval $* \n\
fi \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
