#!/bin/bash
set -Eeo pipefail
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
else
  cd FBReader-Android-2
  git pull
  git checkout molitfelnic
  git pull
  sleep 3
fi

BUILD_FOLDER=~/FBReader-Android-2

cd $BUILD_FOLDER
export GIT_BRANCH=$(git branch | grep '*' | cut -d' ' -f2)
cd -

NAME="${APP}_${GIT_BRANCH}_${DATE_START}"
echo "FYI, GIT_BRANCH=$GIT_BRANCH at date: $DATE_START (approx: `date`)" | tee ${NAME}.log

cp ~/777/aplicatii.romanesti-release-key.keystore $BUILD_FOLDER/

#mkdir -p ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard/Books/
#rm -rf ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard/Books/*
#cd ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard
#rm -rf Books
#unzip '/home/aplicatii-romanesti/ToateCartile_EPUB_latest.zip'
#cd -


### VERIFY BUILD NUMBERS MATCH:
# NO LONGER NEEDED, it's automated ->> final int currentVersion = BuildConfig.VERSION_CODE;
# VV=$(cat ${BUILD_FOLDER}/fbreader/app/VERSION | cut -d"." -f3)
# VSQL=$(grep 'currentVersion =' ${BUILD_FOLDER}/fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java| cut -d"=" -f2 | cut -d";" -f1 | cut -d" " -f2)

# if [[ $VV -ne $VSQL ]]; then
#   echo "ERROR !!!!  $VV != $VSQL -> FIX VERSIONS!!!"
#   exit 9
# fi

cd ~/
docker rm -f fb 2>&- || true
if [[ -f ~/local.properties.docker ]]; then
  cp local.properties.docker ${BUILD_FOLDER}/local.properties
elif [[ -f ~/local.properties.docker ]]; then
  cp local.properties.docker ${BUILD_FOLDER}/local.properties
else
  echo "ERROR, could not find local.properties.docker"
  exit 3
fi

#docker run --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.1 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ clean assembleRelease' | tee -a $GIT_BRANCH.log
# export BUILD_FOLDER=${BUILD_FOLDBUILD_FOLDER:-/home/aplicatii-romanesti/FBReader-Android-2}
docker run --rm --name fb -ti -v ${BUILD_FOLDER}:/p -v ${BUILD_FOLDER}/../Android/Sdk:"/opt/android-sdk/" $(cat $BUILD_FOLDER/scripts/dockerBuilderImage.txt) bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ bundleRelease assembleRelease' | tee -a $NAME.log

if [[ -f ~/local.properties.outsidedocker ]]; then
  cp local.properties.outsidedocker ${BUILD_FOLDER}/local.properties
elif [[ -f ~/local.properties.docker ]]; then
  cp local.properties.outsidedocker ${BUILD_FOLDER}/local.properties
else
  echo "WARNING, could not find local.properties.outsidedocker, Android studio builds might fail"
fi
# --rm

#or only pack:
#docker run --rm --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.0 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ assembleRelease'

ls -la ${BUILD_FOLDER}/fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk | tee -a $NAME.log
ls -la ${BUILD_FOLDER}/fbreader/app/build/outputs/bundle/fatRelease/app-fat-release.aab | tee -a $NAME.log
ls -la ${BUILD_FOLDER}/fbreader/app/build/outputs/native-debug-symbols/fatRelease/native-debug-symbols.zip | tee -a $NAME.log
cp -pf ${BUILD_FOLDER}/fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk ~/${NAME}.apk
cp -pf ${BUILD_FOLDER}/fbreader/app/build/outputs/bundle/fatRelease/app-fat-release.aab ~/${NAME}.aab
cp -pf ${BUILD_FOLDER}/fbreader/app/build/outputs/native-debug-symbols/fatRelease/native-debug-symbols.zip ~/${NAME}-native-debug-symbols.zip || true
rm -f ~/${APP}.apk 2>/dev/null || true
rm -f ~/${APP}.aab 2>/dev/null || true
rm -f ~/${APP}-native-debug-symbols.zip 2>/dev/null || true
ln -sf ~/${NAME}.apk ~/${APP}.apk
ln -sf ~/${NAME}.aab ~/${APP}.aab
ln -sf ~/${NAME}-native-debug-symbols.zip ~/${APP}-native-debug-symbols.zip || true

echo "Ended at: `date` (was started at $DATE_START" | tee -a $NAME.log

