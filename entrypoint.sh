#!/bin/sh

set -e

if [ ! -d /data ]
then
  echo "Directory /data doesn't exist; this is not expected!"
  exit 1
fi

(cd /data
for DIR in db lucene2 lastfmcache thumbs music Podcast playlists .cache .java
do
  if [ ! -d "${DIR}" ]
  then
    printf "%s not found; creating..." ${DIR}
    mkdir "${DIR}"
    echo "done"
  fi
done

for FILE in libresonic.properties libresonic.log rollback.sql
do
  if [ ! -f "${FILE}" ]
  then
    printf "%s not found; creating..." ${FILE}
    touch "${FILE}"
    echo "done"
  fi
done)

exec "${@}"
