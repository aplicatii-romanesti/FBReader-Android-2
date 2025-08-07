#!/bin/bash
#set -vx
REL_FILE_NAMES=$@
# If no param, defaulting to:
#REL_FILE_NAMES=${REL_FILE_NAMES:-"branch_x_latest.apk"}

if [[ -z $REL_FILE_NAMES ]]; then
  REL_FILE_NAMES=($(ls -d ../molitfelnic_to_any_app_res/[A-Z]* | cut -d/ -f3 | awk '{print $1 ".apk" }' ))
fi 
. ~/ftp_upload_apk_to_phone.env

for HOST in $HOSTS; do
  #echo "########  attempting ftp upload to host $HOST 128=a70 39=n6#####"
  timeout 1 bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT"
  ANS=$?
  [[ $ANS -gt 0 ]] && echo "HOST ERROR: $ANS - skipping $HOST" && continue

  for REL_FILE_NAME in "${REL_FILE_NAMES[@]}" ; do
  [[ ! -r "/home/aplicatii-romanesti/$REL_FILE_NAME" ]] && echo "file $REL_FILE_NAME is not in /home/aplicatii-romanesti/" && exit 1
  echo "File: $REL_FILE_NAME "
  ftp -in $HOST $PORT <<EOF
    user $USER $PASSWORD
    binary
    lcd /home/aplicatii-romanesti
    cd Download
    mput "$REL_FILE_NAME"
    bye
EOF
  cp -p "/home/aplicatii-romanesti/$REL_FILE_NAME" /m/backup/el/pixel8_2024Nov/2way/
  #put branch_bibliotecaortodoxa_version_*_at_*.apk
 done


done

