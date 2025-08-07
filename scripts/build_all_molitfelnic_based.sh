#!/bin/bash
set -eo pipefail

DATE_NOW=$(date +%Y%m%d%H%M%S)
if [[ -z $1 ]]; then
  #APPS_M_BASED_MANUAL_LIST=(Molitfelnic Apostolul BibliaOrtodoxa BibliotecaOrtodoxa ColindeUraturiPlugusor Evanghelia Liturghier Mineiele Pidalion Sinaxar Triodul VietileSfintilor )
  echo "Going to autodetect entire set"
  APPS_M_BASED=(Molitfelnic $(ls -d ../molitfelnic_to_any_app_res/[A-Z]* | cut -d/ -f3) )
else
  echo "input received, cancel autodetect, processing requested only:"
  APPS_M_BASED=("$@")
fi

echo "Processing    : ${APPS_M_BASED[@]}"

echo "0. this script works only when run in forlder ~/FBReader-Android-2/scripts"
#if [[ `pwd` != '/home/aplicatii-romanesti/FBReader-Android-2/scripts' ]]; then
#  echo "ERROR: This script works only when run in forlder ~/FBReader-Android-2/scripts"
#  exit 1
#fi

echo "1. Copy the ~/Books_with_HowTO (howto image incorporated) to the ~/Books folder (which we use)"

if [[ -d ~/Books/ ]]; then
  rm -rf ~/Books.old 2>/dev/null || true
  mv ~/Books ~/Books.old #${DATE_NOW}
fi

### COPY BOOKS
unzip -q ~/ToateCartile_EPUB_latest.zip -d ~/
cp -rp ~/Books_with_HowTO/* ~/Books/
#cd -

echo "2. Going to start build one by one:"

for app in "${APPS_M_BASED[@]}"; do
  echo "Building $app"
  echo "$app" >../current_app.txt~
  git reset --hard HEAD
  ./molitfelnic_to_any_app.sh "$app" && ./dockerbuild.sh "$app"
done

echo "Trying also ftp upload using ./ftp_upload_apk_to_phone.sh .apk"
for app in "${APPS_M_BASED[@]}"; do
  echo "ftp-ing $app"
  ./ftp_upload_apk_to_phone.sh ${app}.apk
  ./ftp_upload_apk_to_phone.sh ${app}.aab
done

echo "list them all"
for app in "${APPS_M_BASED[@]}"; do
  ls -lart ~/${app}.apk
done

echo "TO retry ftp upload, do: "
for app in "${APPS_M_BASED[@]}"; do
  echo "./ftp_upload_apk_to_phone.sh ${app}.apk"
  echo "./ftp_upload_apk_to_phone.sh ${app}.aab"
done
