#!/bin/sh

set -e

echo "======================================"
echo "Starting libresonic initialization."

if [ ! -d /data ]
then
  echo "Directory /data doesn't exist; this is not expected!"
  exit 1
else
  echo "INFO - found directory /data"
fi

(cd /data
for DIR in db lucene2 lastfmcache thumbs music Podcast playlists .cache .java
do
  if [ ! -d "${DIR}" ]
  then
    printf "WARN - %s missing; creating..." ${DIR}
    mkdir "${DIR}"
    echo "done"
  else
    echo "INFO - found directory ${DIR}"
  fi
done

for FILE in libresonic.properties libresonic.log rollback.sql
do
  if [ ! -f "${FILE}" ]
  then
    printf "WARN - %s missing; creating..." ${FILE}
    touch "${FILE}"
    echo "done"
  else
    echo "INFO - found file ${FILE}"
  fi
done)

echo "libresonic initialization complete!"
echo "======================================";echo

exec "${@}"
