FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install ca-certificates, ffmpeg, and java7
RUN (apk --no-cache add ca-certificates ffmpeg ttf-dejavu openjdk8)

# set tomcat version
ENV TOMCATVER="8.5.9"

# set libresonci version
ENV LIBRESONICVER="6.2"

# set default CATALINA_OPTS
ENV CATALINA_OPTS="-Xmx1024m -Djava.awt.headless=true"

# create libresonic user
RUN (mkdir /var/libresonic &&\
  addgroup -g 504 libresonic &&\
  adduser -h /var/libresonic -D -u 504 -g libresonic -G libresonic -s /sbin/nologin libresonic &&\
  chown -R libresonic:libresonic /var/libresonic)

# install tomcat
RUN (mkdir /opt &&\
  apk --no-cache add wget &&\
  wget -O /tmp/tomcat8.tar.gz http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCATVER}/bin/apache-tomcat-${TOMCATVER}.tar.gz &&\
  cd /opt &&\
  tar zxf /tmp/tomcat8.tar.gz && \
  mv /opt/apache-tomcat* /opt/tomcat && \
  rm /tmp/tomcat8.tar.gz &&\
  rm -rf /opt/tomcat/webapps/* &&\
  chown -R libresonic:libresonic /opt/tomcat)

# install libresonic.war from https://github.com/Libresonic/libresonic
RUN (wget "https://github.com/Libresonic/libresonic/releases/download/v${LIBRESONICVER}/libresonic-v${LIBRESONICVER}.war" -O /opt/tomcat/webapps/ROOT.war &&\
  chown libresonic:libresonic /opt/tomcat/webapps/ROOT.war)

# create transcode folder and add ffmpeg
RUN (mkdir /var/libresonic/transcode &&\
  ln -s /usr/bin/ffmpeg /var/libresonic/transcode/ffmpeg &&\
  chown -R libresonic:libresonic /var/libresonic/transcode)

# create data directories and symlinks to make it easier to use a volume
RUN (mkdir /data &&\
  cd /data &&\
  mkdir db lucene2 lastfmcache thumbs music Podcast playlists .cache .java &&\
  touch libresonic.properties libresonic.log rollback.sql &&\
  cd /var/libresonic &&\
  ln -s /data/db &&\
  ln -s /data/lucene2 &&\
  ln -s /data/lastfmcache &&\
  ln -s /data/thumbs &&\
  ln -s /data/music &&\
  ln -s /data/Podcast &&\
  ln -s /data/playlists &&\
  ln -s /data/.cache &&\
  ln -s /data/.java &&\
  ln -s /data/libresonic.properties &&\
  ln -s /data/libresonic.log &&\
  ln -s /data/rollback.sql &&\
  chown -R libresonic:libresonic /data)

USER libresonic
WORKDIR /var/libresonic
EXPOSE 8080
VOLUME ["/data"]

CMD ["/opt/tomcat/bin/catalina.sh","run"]
