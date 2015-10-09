FROM debian:jessie
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# Install pre-reqs
RUN (apt-get update && apt-get install -y openjdk-7-jre wget)

# Install the official subsonic 5.2.1 .deb and add subsonic.war from https://github.com/EugeneKay/subsonic
RUN (wget "http://sourceforge.net/projects/subsonic/files/subsonic/5.2.1/subsonic-5.2.1.deb/download" -O /tmp/subsonic-5.2.1.deb &&\
  dpkg -i /tmp/subsonic-5.2.1.deb &&\
  useradd subsonic &&\
  rm /tmp/subsonic-5.2.1.deb &&\
  wget "https://github.com/EugeneKay/subsonic/releases/download/v5.2.1-kang/subsonic-v5.2.1.war" -O /usr/share/subsonic/subsonic.war)

USER subsonic
WORKDIR /usr/share/subsonic
EXPOSE 4040
VOLUME ["/var/subsonic"]

ENTRYPOINT ["java","-Xmx1024m","-Dsubsonic.home=/var/subsonic","-Dsubsonic.host=0.0.0.0","-Dsubsonic.port=4040","-Dsubsonic.httpsPort=0","-Dsubsonic.contextPath=/","-Dsubsonic.defaultMusicFolder=/var/music","-Dsubsonic.defaultPodcastFolder=/var/music/Podcast","-Dsubsonic.defaultPlaylistFolder=/var/playlists","-Djava.awt.headless=true","-verbose:gc","-jar","subsonic-booter-jar-with-dependencies.jar"]
