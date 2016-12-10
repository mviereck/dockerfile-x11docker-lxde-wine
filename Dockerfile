# x11docker/lxde-wine
# Run wine and playonlinux with LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker and x11docker-gui from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop x11docker/lxde-wine
#           x11docker --xephyr --desktop x11docker/lxde-wine
#           x11docker --xpra x11docker/lxde-wine playonlinux
#
# To create a persistant home folder to preserve your wine installations, 
# use options --home --hostuser
# Examples: x11docker --desktop --home --hostuser x11docker/lxde-wine
#           x11docker --xephyr --desktop --home --hostuser x11docker/lxde-wine start
#           x11docker --xpra --home --hostuser x11docker/lxde-wine playonlinux


FROM x11docker/lxde

RUN apt-get update

# include wine ppa
RUN echo "deb http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu xenial main"        > /etc/apt/sources.list.d/wine_ppa.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com     883E8688397576B6C509DF495A9A06AEF9CB8DB0

# add multiarch support
RUN dpkg --add-architecture i386
RUN apt-get update

# install wine
RUN apt-get install -y wine1.8

# include playonlinux repo 
# (not needed right now. ubuntu 16.04 xenial includes actual playonlinux version)
# RUN wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
# RUN wget http://deb.playonlinux.com/playonlinux_trusty.list -O /etc/apt/sources.list.d/playonlinux.list
# RUN apt-get update

# include multiverse repository to get playonlinux
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ xenial multiverse' >> /etc/apt/sources.list
RUN apt-get update

# install playonlinux
RUN apt-get install -y playonlinux
# playonlinux wants to have this:
RUN apt-get install -y xterm gettext

# install q4wine, another frontend for wine
RUN apt-get install -y q4wine


## some additional installations

## some X libs, f.e. allowing videos in Xephyr
RUN apt-get install -y --no-install-recommends x11-utils

## OpenGl support in dependencies
RUN apt-get install -y mesa-utils mesa-utils-extra

## Pulseaudio support
RUN apt-get install -y --no-install-recommends pulseaudio
# enable one of the following to get sound controls
#RUN apt-get install -y --no-install-recommends pavucontrol
#RUN apt-get install -y --no-install-recommends pasystray

## Xrandr and some other goodies
RUN apt-get install -y x11-xserver-utils

# dillo browser: not needed for wine, but useful to download windows applications
RUN apt-get install -y dillo

# PDF viewer evince-gtk
RUN apt-get install -y evince-gtk

## VLC media player
# RUN apt-get install -y vlc


# clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


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
Exec=notepad\n\
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
Exec=winemine\n\
Icon=face-cool\n\
" > /etc/skel/Desktop/WineMine.desktop

RUN echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=winetricks\n\
Exec=winetricks\n\
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

# files in /etc/skel will automatically be added for new users. manual copy for root
RUN cp -R /etc/skel/. /root/
RUN cp -R /etc/skel/* /root/

CMD start
