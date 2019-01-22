FROM ubuntu:14.04
MAINTAINER mental667

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install -y software-properties-common python-software-properties \
      && add-apt-repository multiverse && add-apt-repository ppa:no1wantdthisname/ppa && add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get upgrade -y \
      && apt-get install -y unixodbc libgsf-1-114 imagemagick libglib2.0-dev libt1-5 t1utils openjdk-8-jdk \
          libwebkit-dev libwebkitgtk-3.0-0 libcanberra-gtk-module unzip fontconfig-infinality gtk2-engines-murrine gtk2-engines-pixbuf dialog nano \
      && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ENV PLT_VERSION 8.3.13-1644
ENV PLT_ARCH amd64
ENV LANG ru_RU.utf8

ADD ./dist/ /opt/
ADD ./start.sh /opt/

RUN dpkg -i  /opt/1c-enterprise83-thin-client_${PLT_VERSION}_${PLT_ARCH}.deb \
      && unzip /opt/mscorefonts.zip -d /usr/share/fonts/TTF \
      && unzip /opt/ttf-fira-code.zip -d /usr/share/fonts/TTF \
      && unzip /opt/otf-fira-code.zip -d /usr/share/fonts/OTF \
      && unzip /opt/zukitwo-themes.zip -d /usr/share/themes \
      && unzip /opt/yltra-icons.zip -d /usr/share/icons \
      && unzip /opt/ultraflat-icons.zip -d /usr/share/icons \
      && rm /opt/*.deb && rm /opt/*.zip && chmod +x /opt/start.sh \
      && /bin/bash /etc/fonts/infinality/infctl.sh setstyle linux

RUN export uid=1000 gid=1000 && \
      mkdir -p /home/user && \
      echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
      echo "user:x:${uid}:" >> /etc/group && \
      echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
      chmod 0440 /etc/sudoers.d/user && \
      chown user:user -R /home/user && \
      find /home/ -type d -exec chmod 775 {} +

USER user
ENV HOME /home/user
CMD /opt/start.sh
