# x11docker/lxde-wine
#
# Run wine on LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Use option --home to create a persistant home folder 
# in ~/x11docker to preserve your wine installations.
#
# Examples: 
#   - Run desktop:
#       x11docker --home --desktop x11docker/lxde-wine
#   - Run PlayOnLinux only:
#       x11docker --home x11docker/lxde-wine playonlinux
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Sound support with option                    --alsa
# With pulseaudio in image, sound support with --pulseaudio
#
# Look at x11docker --help for further options.

FROM x11docker/lxde:latest
ENV DEBIAN_FRONTEND noninteractive
# ENTRYPOINT and CMD are already defined in x11docker/lxde

# contrib for winetricks, stretch-backports for latest wine
RUN echo "deb http://deb.debian.org/debian stretch contrib" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

# Multiarch for wine32, wine, some often needed dependencies:
RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get -t stretch-backports install -y wine

RUN apt-get install -y fonts-wine winetricks ttf-mscorefonts-installer winbind

# wine gecko and mono
RUN mkdir -p /usr/share/wine/gecko && \
    cd /usr/share/wine/gecko && wget https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi && \
    wget https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi && \
    mkdir -p /usr/share/wine/mono && \
    cd /usr/share/wine/mono  && wget https://dl.winehq.org/wine/wine-mono/4.7.1/wine-mono-4.7.1.msi

# PlayOnLinux, q4wine
RUN apt-get install -y playonlinux xterm gettext q4wine gnome-icon-theme

# OpenGL / MESA
RUN apt-get install -y mesa-utils mesa-utils-extra libxv1

# pulseaudio
RUN apt-get install -y --no-install-recommends pulseaudio pasystray pavucontrol

# Enable this for chinese, japanese and korean fonts in wine
#winetricks -q cjkfonts

# create desktop icons
#
RUN mkdir -p /etc/skel/Desktop && \
echo '#! /bin/bash \n\
datei="/etc/skel/Desktop/$(echo "$1" | LC_ALL=C sed -e "s/[^a-zA-Z0-9,.-]/_/g" ).desktop" \n\
echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=$1\n\
Exec=$2\n\
Icon=$3\n\
" > $datei \n\
chmod +x $datei \n\
' >/usr/local/bin/createicon && chmod +x /usr/local/bin/createicon && \
\
createicon "PlayOnLinux"        "playonlinux"       playonlinux && \
createicon "Q4wine"             "q4wine"            q4wine && \
createicon "Internet Explorer"  "wine iexplore"     applications-internet && \
createicon "Console"            "wineconsole"       utilities-terminal && \
createicon "File Explorer"      "wine explorer"     folder && \
createicon "Notepad"            "wine notepad"      wine-notepad && \
createicon "Wordpad"            "wine wordpad"      accessories-text-editor && \
createicon "winecfg"            "winecfg"           wine-winecfg && \
createicon "WineFile"           "winefile"          folder-wine && \
createicon "Mines"              "wine winemine"     face-cool && \
createicon "winetricks"         "winetricks -gui"   wine && \
createicon "Registry Editor"    "regedit"           preferences-system && \
createicon "UnInstaller"        "wine uninstaller"  wine-uninstaller && \
createicon "Taskmanager"        "wine taskmgr"      utilities-system-monitor && \
createicon "Control Panel"      "wine control"      preferences-system && \
createicon "OleView"            "wine oleview"      preferences-system && \
createicon "CJK fonts installer chinese japanese korean"  "xterm -e \"winetricks cjkfonts\""  font

ENV DEBIAN_FRONTEND newt
