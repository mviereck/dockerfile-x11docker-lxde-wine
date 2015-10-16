# x11docker/lxde-wine
# Run wine on LXDE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker script from github: 
#   https://github.com/mviereck/x11docker 
# Raw x11docker script:
#   https://raw.githubusercontent.com/mviereck/x11docker/e49e109f9e78410d242a0226e58127ec9f9d6181/x11docker
#
# Examples: x11docker --desktop x11docker/lxde-wine
#           x11docker --xephyr --desktop x11docker/lxde-wine

# known issues:
#  * wine-gecko2.40 seems to be not recognized

FROM x11docker/lxde:latest

RUN apt-get  update

# include wine ppa
RUN echo "deb http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu trusty main"        > /etc/apt/sources.list.d/wine_ppa.list
RUN sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com     883E8688397576B6C509DF495A9A06AEF9CB8DB0

# add multiarch support
RUN dpkg --add-architecture i386
RUN apt-get update

# install wine
RUN apt-get install -y wine1.7
RUN apt-get install -y winetricks
RUN apt-get install -y wine-gecko2.40
RUN apt-get install -y wine-mono4.5.6

RUN apt-get clean


# create desktop icons that will be copied to every new user
#
RUN mkdir /etc/skel/Desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/WineExplorer.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/WineExplorer.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/WineExplorer.desktop
RUN echo Name=Wine Explorer  >> /etc/skel/Desktop/WineExplorer.desktop
RUN echo Exec=wine explorer  >> /etc/skel/Desktop/WineExplorer.desktop
RUN echo Icon=wine           >> /etc/skel/Desktop/WineExplorer.desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/WineNotepad.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/WineNotepad.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/WineNotepad.desktop
RUN echo Name=Wine Notepad   >> /etc/skel/Desktop/WineNotepad.desktop
RUN echo Exec=notepad        >> /etc/skel/Desktop/WineNotepad.desktop
RUN echo Icon=wine-notepad   >> /etc/skel/Desktop/WineNotepad.desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/WineCfg.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/WineCfg.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/WineCfg.desktop
RUN echo Name=Configure Wine >> /etc/skel/Desktop/WineCfg.desktop
RUN echo Exec=winecfg        >> /etc/skel/Desktop/WineCfg.desktop
RUN echo Icon=wine-winecfg   >> /etc/skel/Desktop/WineCfg.desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/WineFile.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/WineFile.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/WineFile.desktop
RUN echo Name=Wine File Manager  >> /etc/skel/Desktop/WineFile.desktop
RUN echo Exec=winefile       >> /etc/skel/Desktop/WineFile.desktop
RUN echo Icon=folder-wine    >> /etc/skel/Desktop/WineFile.desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/WineMine.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/WineMine.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/WineMine.desktop
RUN echo Name=Mines          >> /etc/skel/Desktop/WineMine.desktop
RUN echo Exec=winemine       >> /etc/skel/Desktop/WineMine.desktop
RUN echo Icon=wine           >> /etc/skel/Desktop/WineMine.desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/Winetricks.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/Winetricks.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/Winetricks.desktop
RUN echo Name=winetricks     >> /etc/skel/Desktop/Winetricks.desktop
RUN echo Exec=winetricks     >> /etc/skel/Desktop/Winetricks.desktop
RUN echo Icon=winetricks     >> /etc/skel/Desktop/Winetricks.desktop
RUN echo [Desktop Entry]     > /etc/skel/Desktop/Wineregedit.desktop
RUN echo Version=1.0         >> /etc/skel/Desktop/Wineregedit.desktop
RUN echo Type=Application    >> /etc/skel/Desktop/Wineregedit.desktop
RUN echo Name=regedit        >> /etc/skel/Desktop/Wineregedit.desktop
RUN echo Exec=regedit        >> /etc/skel/Desktop/Wineregedit.desktop
RUN echo Icon=wine           >> /etc/skel/Desktop/Wineregedit.desktop

# doesn't work because it needs mouse clicks
#RUN msiexec /usr/share/wine/gecko/msiexec /i wine_gecko-2.40-x86_64.msi

# create startscript
# (will copy Desktop icons, if not already present, and start x-session-manager
RUN echo '#! /bin/bash                                                \n\
if [ ! -e "$HOME/Desktop" ] ; then cp -R /etc/skel/* $HOME ; fi       \n\
x-session-manager                                                     \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
