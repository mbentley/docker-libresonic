mbentley/subsonic
=================

docker image for subsonic; utilizes libresonic from https://github.com/Libresonic/libresonic

To pull this image:
`docker pull mbentley/subsonic`

Example usage:
`docker run -d -p 4040:4040 -p 4443:4443 -v /data/subsonic:/data --name subsonic mbentley/subsonic`
