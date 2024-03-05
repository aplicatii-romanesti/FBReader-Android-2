#!/bin/bash
set -xeo pipefail

DATE_NOW=$(date +%Y%m%d%H%M%S)
if [[ -z $1 ]]; then
  APPS_M_BASED=(BibliaOrtodoxa VietileSfintilor BibliotecaOrtodoxa Pidalion Liturghier ColindeUraturiPlugusor)
else
  APPS_M_BASED=($@)
fi

set -u
echo "Processing: $APPS_M_BASED"

echo "1. Copy the ~/Books_with_HowTO (howto image incorporated) to the ~/Books folder (which we use)"

if [[ -d ~/Books/ ]]; then
  mv ~/Books/ ~/Books.${DATE_NOW}
else
  mkdir -p ~/Books/
fi

cp -rp ~/Books_with_HowTO/* ~/Books/

echo "2. Going to start build one by one:"

for app in ${APPS_M_BASED[@]}; do
  echo "Building $app"
  echo "$app" >../current_app.txt~
  git reset --hard HEAD
  ./molitfelnic_to_any_app.sh $app && ./dockerbuild.sh $app
done


