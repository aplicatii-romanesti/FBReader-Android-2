#!/bin/bash
set -Eexo pipefail
DATE_START=`date +'%Y%m%d_%H%M%S'`

if [[ -n $1 ]]; then
  echo "Name of the app being build provided as input is: $1"
  APP=$1
  echo $APP >../current_app.txt~ 
elif [[ -r ../current_app.txt~ ]]; then
  APP=$(cat ../current_app.txt~)
else
  echo "Please provide input, e.g. Pidalion"
  exit 1
fi

cd ~/
if [[ ! -d FBReader-Android-2 ]]; then
  #git clone -b ${1:-molitfelnic} --single-branch git@github.com:aplicatii-romanesti/FBReader-Android-2.git
  git clone -b molitfelnic --single-branch git@github.com:aplicatii-romanesti/FBReader-Android-2.git
fi

cd ~/FBReader-Android-2/
export GIT_BRANCH=$(git branch | grep '*' | cut -d' ' -f2)
cd -

NAME="${APP}_${GIT_BRANCH}_${DATE_START}"
echo "FYI, GIT_BRANCH=$GIT_BRANCH at date: $DATE_START (approx: `date`)" | tee ${NAME}.log

cp ~/777/aplicatii.romanesti-release-key.keystore ~/FBReader-Android-2/

#mkdir -p ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard/Books/
#rm -rf ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard/Books/*
#cd ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard
#rm -rf Books
#unzip '/home/aplicatii-romanesti/ToateCartile_EPUB_latest.zip'
#cd -


### VERIFY BUILD NUMBERS MATCH:
BUILD_FOLDER="~/FBReader-Android-2"
VV=$(cat ${BUILD_FOLDER}/fbreader/app/VERSION | cut -d"." -f3)
VSQL=$(grep 'currentVersion =' ${BUILD_FOLDER}/fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java| cut -d"=" -f2 | cut -d";" -f1 | cut -d" " -f2)

if [[ $VV -ne $VSQL ]]; then
  echo "ERROR !!!!  $VV != $VSQL -> FIX VERSIONS!!!"
  exit 9
fi


cd ~/
docker rm -f fb || true
#docker run --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.1 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ clean assembleRelease' | tee -a $GIT_BRANCH.log
docker run --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.15.0 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ assembleRelease' | tee -a $NAME.log
# --rm

#or only pack:
#docker run --rm --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.0 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ assembleRelease'

ls -la ~/FBReader-Android-2/fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk | tee -a $NAME.log
cp -f ~/FBReader-Android-2/fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk ~/${NAME}.apk
echo "Ended at: `date` (was started at $DATE_START" | tee -a $NAME.log




