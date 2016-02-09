FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install ca-certificates and java7
RUN (apk --update add ca-certificates openjdk7-jre-base && rm -rf /var/cache/apk/*)

# Install the official subsonic 5.3 standalone package and add subsonic.war from https://github.com/EugeneKay/subsonic
RUN (apk --update add wget && rm -rf /var/cache/apk/* &&\
  wget "http://sourceforge.net/projects/subsonic/files/subsonic/5.3/subsonic-5.3-standalone.tar.gz/download" -O /tmp/subsonic.tar.gz &&\
  mkdir /var/subsonic &&\
  tar zxf /tmp/subsonic.tar.gz -C /var/subsonic &&\
  rm /tmp/subsonic.tar.gz &&\
  apk del wget &&\
  adduser -h /var/subsonic -D subsonic &&\
  chown -R subsonic:subsonic /var/subsonic)

# create data directories and symlinks to make it easier to use a volume
RUN (mkdir /data &&\
  cd /data &&\
  mkdir db jetty lucene2 lastfmcache playlists thumbs transcode &&\
  touch subsonic.properties subsonic.log &&\
  cd /var/subsonic &&\
  ln -s /data/db &&\
  ln -s /data/jetty &&\
  ln -s /data/lucene2 &&\
  ln -s /data/lastfmcache &&\
  ln -s /data/playlists &&\
  ln -s /data/thumbs &&\
  ln -s /data/transcode &&\
  ln -s /data/subsonic.properties &&\
  ln -s /data/subsonic.log &&\
  chown -R subsonic:subsonic /data)

USER subsonic
WORKDIR /var/subsonic
EXPOSE 4040 4443
VOLUME ["/data"]

CMD ["java","-Xmx1024m","-Dsubsonic.home=/var/subsonic","-Dsubsonic.host=0.0.0.0","-Dsubsonic.port=4040","-Dsubsonic.httpsPort=4443","-Dsubsonic.contextPath=/","-Dsubsonic.defaultMusicFolder=/var/music","-Dsubsonic.defaultPodcastFolder=/var/music/Podcast","-Dsubsonic.defaultPlaylistFolder=/var/playlists","-Djava.awt.headless=true","-jar","subsonic-booter-jar-with-dependencies.jar"]
