# x11docker/lxde-wine 24.9.2015
# Run wine on LXDE desktop in docker. Use script x11docker to run image.
# Creates a user 'xduser'; username can be changed with '-e XDUSER=username'
# Examples: x11docker --desktop run --rm x11docker/lxde-wine
#      to include your host ~/.wine folder and run dockered desktop with same user name as on host:
#      x11docker --desktop run --rm  -e XDUSER=$USER  -v $HOME/.wine:$HOME/.wine:rw  xdocker/lxde-wine

# known issues:
#  * wine-gecko2.40 seems to be not recognized

FROM phusion/baseimage:latest

RUN apt-get  update

# Set environment variables 
ENV HOME /root 
ENV DEBIAN_FRONTEND noninteractive 
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8

# fix problems with dictionaries-common
# See https://bugs.launchpad.net/ubuntu/+source/dictionaries-common/+bug/873551
RUN apt-get install -y apt-utils
RUN /usr/share/debconf/fix_db.pl
RUN apt-get install -f

RUN apt-get install -y --no-install-recommends lxde-core   # eneough to have a desktop
RUN apt-get install -y lxterminal                          # you will need it in lxde-core to do anything
RUN apt-get install -y --no-install-recommends lxde        # disable if you want the core only
#RUN apt-get install -y lxde                                # enable to get full LXDE environment

# include wine ppa
RUN echo "deb http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu trusty main"        > /etc/apt/sources.list.d/wine_ppa.list
RUN sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com     883E8688397576B6C509DF495A9A06AEF9CB8DB0

RUN dpkg --add-architecture i386
RUN apt-get update

RUN apt-get install -y wine1.7
RUN apt-get install -y winetricks
RUN apt-get install -y wine-gecko2.40
RUN apt-get install -y wine-mono4.5.6

RUN apt-get clean


# default user 'xduser'. Can be changed with docker run option -e XDUSER=$USER 
ENV XDUSER xduser


# create startscript
ENV STARTSCRIPT=/usr/local/bin/startx11docker
RUN echo '#! /bin/bash                                                  \n\
adduser --disabled-password --gecos "" --home /home/$XDUSER $XDUSER     \n\
adduser $XDUSER sudo                                                    \n\
chown   $XDUSER:root /home/$XDUSER                                      \n\
mkdir   /home/$XDUSER/Desktop                                           \n\
chown   $XDUSER -R /home/$XDUSER/Desktop                                \n\ 
su      $XDUSER -c create-desktop-icons                                 \n\
su      $XDUSER -c x-session-manager                                    \n\
' > $STARTSCRIPT
RUN chmod +x $STARTSCRIPT

# No password for sudo needed
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL'                          >> /etc/sudoers


# create script that creates desktop icons
ENV DESKTOPICONS /usr/local/bin/create-desktop-icons
RUN echo '#! /bin/bash                                           \n\
echo [Desktop Entry]     > $HOME/Desktop/WineExplorer.desktop    \n\
echo Version=1.0         >> $HOME/Desktop/WineExplorer.desktop   \n\
echo Type=Application    >> $HOME/Desktop/WineExplorer.desktop   \n\
echo Name=Wine Explorer  >> $HOME/Desktop/WineExplorer.desktop   \n\
echo Exec=wine explorer  >> $HOME/Desktop/WineExplorer.desktop   \n\
echo Icon=wine           >> $HOME/Desktop/WineExplorer.desktop   \n\

echo [Desktop Entry]     > $HOME/Desktop/WineNotepad.desktop     \n\
echo Version=1.0         >> $HOME/Desktop/WineNotepad.desktop    \n\
echo Type=Application    >> $HOME/Desktop/WineNotepad.desktop    \n\
echo Name=Wine Notepad   >> $HOME/Desktop/WineNotepad.desktop    \n\
echo Exec=notepad        >> $HOME/Desktop/WineNotepad.desktop    \n\
echo Icon=wine-notepad   >> $HOME/Desktop/WineNotepad.desktop    \n\

echo [Desktop Entry]     > $HOME/Desktop/WineCfg.desktop         \n\
echo Version=1.0         >> $HOME/Desktop/WineCfg.desktop        \n\
echo Type=Application    >> $HOME/Desktop/WineCfg.desktop        \n\
echo Name=Configure Wine >> $HOME/Desktop/WineCfg.desktop        \n\
echo Exec=winecfg        >> $HOME/Desktop/WineCfg.desktop        \n\
echo Icon=wine-winecfg   >> $HOME/Desktop/WineCfg.desktop        \n\

echo [Desktop Entry]     > $HOME/Desktop/WineFile.desktop        \n\
echo Version=1.0         >> $HOME/Desktop/WineFile.desktop       \n\
echo Type=Application    >> $HOME/Desktop/WineFile.desktop       \n\
echo Name=Wine File Manager  >> $HOME/Desktop/WineFile.desktop   \n\
echo Exec=winefile       >> $HOME/Desktop/WineFile.desktop       \n\
echo Icon=folder-wine    >> $HOME/Desktop/WineFile.desktop       \n\

echo [Desktop Entry]     > $HOME/Desktop/WineMine.desktop        \n\
echo Version=1.0         >> $HOME/Desktop/WineMine.desktop       \n\
echo Type=Application    >> $HOME/Desktop/WineMine.desktop       \n\
echo Name=Mines          >> $HOME/Desktop/WineMine.desktop       \n\
echo Exec=winemine       >> $HOME/Desktop/WineMine.desktop       \n\
echo Icon=wine           >> $HOME/Desktop/WineMine.desktop       \n\
