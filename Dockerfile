# x11docker/lxde-wine
#
# Run wine on LXDE desktop in Docker container. 
# Use x11docker to run image:  https://github.com/mviereck/x11docker 
#
# Use option --home to create a persistant home folder 
# in ~/x11docker to preserve your wine installations.
#
# Examples: 
#   - Run desktop:
#       x11docker --home --cap-default --desktop x11docker/lxde-wine
#   - Run PlayOnLinux only:
#       x11docker --home --cap-default x11docker/lxde-wine playonlinux
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host file or folder with              --share PATH
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Sound support with option                    --alsa
# With pulseaudio in image, sound support with --pulseaudio
# Language setting with                        --lang [=$LANG]
# Printing over CUPS with                      --printer
# Webcam support with                          --webcam
#
# Look at x11docker --help for further options.

FROM x11docker/lxde:latest

# cleanapt script for use after apt-get
RUN echo '#! /bin/sh\n\
env DEBIAN_FRONTEND=noninteractive apt-get autoremove -y\n\
apt-get clean\n\
find /var/lib/apt/lists -type f -delete\n\
find /var/cache -type f -delete\n\
find /var/log -type f -delete\n\
exit 0\n\
' > /cleanapt && chmod +x /cleanapt

RUN . /etc/os-release && \
    echo "deb http://deb.debian.org/debian $VERSION_CODENAME contrib non-free" >> /etc/apt/sources.list && \
    env DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 && \
    apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        fonts-wine \
        locales \
        ttf-mscorefonts-installer \
        wget \
        winbind \
        wine \
        winetricks && \
    /cleanapt

RUN mkdir -p /usr/share/wine/gecko && \
    cd /usr/share/wine/gecko && \
    wget http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi && \
    wget http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi

RUN mkdir -p /usr/share/wine/mono && \
    cd /usr/share/wine/mono && \
    wget https://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gettext \
        gnome-icon-theme \
        playonlinux \
        q4wine \
        xterm && \
    /cleanapt

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libpulse0 \
        libxv1 \
        mesa-utils \
        mesa-utils-extra \
        pasystray \
        pavucontrol && \
    /cleanapt

RUN apt-get update && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        xfwm4 && \
    /cleanapt && \
    mkdir -p /etc/skel/.config/lxsession/LXDE && \
    echo '[Session]\n\
window_manager=xfwm4\n\
' >/etc/skel/.config/lxsession/LXDE/desktop.conf

# Enable this for chinese, japanese and korean fonts in wine
#RUN winetricks -q cjkfonts

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
