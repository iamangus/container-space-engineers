FROM archlinux

ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/home/steam/wineserver

RUN \
  # Enable multilib
  printf "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist">> /etc/pacman.conf && \
  # update
  pacman -Syyu --noconfirm && \
  # install packages
  pacman -S --noconfirm git vi xorg-server-xvfb sudo base-devel wine-staging winetricks giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox  && \
  # create steam user
  useradd -m steam  && \
  # remove password
  passwd -d steam  && \
  # add steam user to wheel
  usermod -aG wheel steam && \
  # wheel stuff
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel


USER 1000
ENV USER=steam
WORKDIR /home/steam

RUN \
  #install steamcmd
  git clone https://aur.archlinux.org/steamcmd.git && \
  cd steamcmd  && \
  makepkg -si --noconfirm && \
  #initial steamcmd configuration
  steamcmd +quit && \
  cd ..

# Winetricks (This block uses most of the build time)
COPY winetricks.sh /home/steam/
RUN \
  /home/steam/winetricks.sh && \
  rm -f /home/steam/winetricks.sh

COPY entrypoint.sh /home/steam/

ENTRYPOINT /home/steam/entrypoint.sh
