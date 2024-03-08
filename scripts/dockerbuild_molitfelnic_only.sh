#!/bin/bash
set -Eexo pipefail
DATE_START=`date +'%Y%m%d_%H%M%S'`

APP=Molitfelnic

cd ~/
if [[ ! -d FBReader-Android-2 ]]; then
  #git clone -b ${1:-molitfelnic} --single-branch git@github.com:aplicatii-romanesti/FBReader-Android-2.git
  git clone -b molitfelnic --single-branch git@github.com:aplicatii-romanesti/FBReader-Android-2.git
fi

BUILD_FOLDER=~/FBReader-Android-2
cd $BUILD_FOLDER
export GIT_BRANCH=$(git branch | grep '*' | cut -d' ' -f2)
cd -

NAME="${APP}_${GIT_BRANCH}_${DATE_START}"
echo "FYI, GIT_BRANCH=$GIT_BRANCH at date: $DATE_START (approx: `date`)" | tee ${NAME}.log

#############
cp -rp ~/Books_with_HowTO/* ~/Books/
BOOKS_DIR=~/Books

BUILD_FOLDER=~/FBReader-Android-2
cd $BUILD_FOLDER

# STEP 0.6: Make sure we have the Books directory
echo "STEP 0.6: Make sure we have the Books diretory"

if [[ ! -d ${BOOKS_DIR}/ ]]; then
        echo "Could not find the Books in: ${BOOKS_DIR}/" && exit 1
fi

# STEP 0.7:  "Clean old books in the app (if any)"
echo "Clean old books in the app (if any)"
mkdir -p ./fbreader/app/src/main/assets/data/SDCard/Books/
rm -rf ./fbreader/app/src/main/assets/data/SDCard/Books/*
cp -f ./fbreader/app/src/main/assets/data/intro/* ./fbreader/app/src/main/assets/data/SDCard/

# STEP 0.8: determine&copy required Books"
echo "STEP 0.8: determine&copy required Books:"
	cp -rfp ${BOOKS_DIR}/Slujbe/Molitfelnicul* ./fbreader/app/src/main/assets/data/SDCard/Books/

##################

cp ~/777/aplicatii.romanesti-release-key.keystore ~/FBReader-Android-2/

#mkdir -p ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard/Books/
#rm -rf ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard/Books/*
#cd ~/FBReader-Android-2/fbreader/app/src/main/assets/data/SDCard
#rm -rf Books
#unzip '/home/aplicatii-romanesti/ToateCartile_EPUB_latest.zip'
#cd -


### VERIFY BUILD NUMBERS MATCH:
#VV=$(cat ${BUILD_FOLDER}/fbreader/app/VERSION | cut -d"." -f3)
#VSQL=$(grep 'currentVersion =' ${BUILD_FOLDER}/fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java| cut -d"=" -f2 | cut -d";" -f1 | cut -d" " -f2)

#if [[ $VV -ne $VSQL ]]; then
#  echo "ERROR !!!!  $VV != $VSQL -> FIX VERSIONS!!!"
#  exit 9
#fi

cd ~/
docker rm -f fb || true
if [[ -f ~/local.properties.docker ]]; then
  cp local.properties.docker ${BUILD_FOLDER}/local.properties
elif [[ -f ~/local.properties.docker ]]; then
  cp local.properties.docker ${BUILD_FOLDER}/local.properties
else
  echo "ERROR, could not find local.properties.docker"
  exit 3
fi
#docker run --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.1 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ clean assembleRelease' | tee -a $GIT_BRANCH.log
docker run --rm --name fb -ti -v ${BUILD_FOLDER}:/p $(cat $BUILD_FOLDER/scripts/dockerBuilderImage.txt) bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ assembleRelease' | tee -a $NAME.log

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

ls -la ~/FBReader-Android-2/fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk | tee -a $NAME.log
cp -f ~/FBReader-Android-2/fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk ~/${NAME}.apk
echo "Ended at: `date` (was started at $DATE_START" | tee -a $NAME.log

