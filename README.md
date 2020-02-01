# mbentley/libresonic

**Note**: This repository has been deprecated in favor of [mbentley/docker-airsonic](https://github.com/mbentley/docker-airsonic).  Please update your images.

docker image for libresonic (https://github.com/Libresonic/libresonic); fork of subsonic

To pull this image:
`docker pull mbentley/libresonic`

Example usage:
`docker run -d -p 4040:4040 -v /data/libresonic:/data --name libresonic mbentley/libresonic`
