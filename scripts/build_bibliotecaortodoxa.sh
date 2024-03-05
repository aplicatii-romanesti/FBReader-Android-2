#!/bin/bash
set -eu -o pipefail
DATE_START_EPOCH=`date +%s`
DATE_START=`date +'%Y%m%d_%H%M%S'` # EPOCH Does not have timezone, so not using
echo "starting at ~$DATE_START"

### VERIFY WE ARE IN THE RIGHT FOLDER:
cd ../
BUILD_FOLDER="./" # MIGHT NOT WORK IF YOU CHANGE IT
[[ ! -s ${BUILD_FOLDER}/fbreader/app/VERSION ]] && echo "we are not in the scripts folder; make sure you run this script from scripts folder, like this: ./$(basename ${0}) ; Now exiting" && exit 2

### VERIFY WE ARE IN THE RIGHT BRANCH:
export GIT_BRANCH=$(git branch | grep '*' | cut -d' ' -f2)
[[ $GIT_BRANCH != "bibliotecaortodoxa" ]] && echo "We are not in the bibliotecaortodoxa branch. For other branches use build_all_molitfelnic_based.sh which calls dockerbuild.sh" && exit 3

### VERIFY BUILD NUMBERS MATCH:
echo "verifying versions in these 2 files"
echo "vi ../${BUILD_FOLDER}/fbreader/app/VERSION ../${BUILD_FOLDER}/fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java"
VV=$(cat ${BUILD_FOLDER}/fbreader/app/VERSION | cut -d"." -f3)
#from .65, this is dynamic, so below test no longer needed
#VSQL=$(grep 'currentVersion =' ${BUILD_FOLDER}/fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java| cut -d"=" -f2 | cut -d";" -f1 | cut -d" " -f2)
sleep 3
#if [[ $VV -ne $VSQL ]]; then
#  echo "ERROR !!!!  $VV != $VSQL -> FIX VERSIONS!!!"
#  exit 9
#fi

echo "Version: ${VV}"
NAME=branch_bibliotecaortodoxa_version_${VV}_at_${DATE_START}
echo "Name: $NAME"

### FETCH SIGNING KEY
cp ~/777/aplicatii.romanesti-release-key.keystore .
[[ ! -s aplicatii.romanesti-release-key.keystore ]] && echo "SIGNING KEY MISSING" && exit 10

### COPY BOOKS
mkdir -p fbreader/app/src/main/assets/data/SDCard/Books/
rm -rf fbreader/app/src/main/assets/data/SDCard/Books/*
#cd fbreader/app/src/main/assets/data/SDCard
rm -rf fbreader/app/src/main/assets/data/SDCard/Books
unzip -q '/home/aplicatii-romanesti/ToateCartile_EPUB_latest.zip' -d fbreader/app/src/main/assets/data/SDCard/
cp -r /home/aplicatii-romanesti/Books_with_HowTO/* fbreader/app/src/main/assets/data/SDCard/Books/
#cd -

### ACTUAL BUILD
docker rm -f fb || true
cp local.properties.docker local.properties
###docker run --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.1 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ clean assembleRelease' | tee -a $GIT_BRANCH.log
set -x
docker run --name fb -ti -v `pwd`:/p mingc/android-build-box:1.26.0 bash -c 'cd /p/ && ./gradlew --gradle-user-home=/p/.gradle/ assembleRelease' | tee -a $NAME.log
sudo rm -rf FBReader-Android-2-dev/fbreader/app/build/generated/not_namespaced_r_class_sources/* || true #so we will be able to use Android Studio as well afterwards...
set +x
# --rm

#or only pack:
#docker run --rm --name fb -ti -v `pwd`/FBReader-Android-2:/p mingc/android-build-box:1.11.0 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ assembleRelease'

### ECHO BUILDED PATHS
ls -la fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk | tee -a $NAME.log
cp -f fbreader/app/build/outputs/apk/fat/release/app-fat-release.apk ~/${NAME}.apk
ln -sf ~/${NAME}.apk ~/branch_x_latest.apk

echo "Version: ${VV}"
echo "Name: $NAME"
echo "Path: ~/${NAME}.apk"

### CHOWN/CLEANUP ALL build directories (so we can build from IDE also)
find . -name build -type d | sudo chown -R $(id -u):$(id -g)
#find . -name build -type d | sudo xargs rm -rf

### PERFORMANCE CALCS
DATE_END_EPOCH=`date +%s`
DATE_DIFF=`expr $DATE_END_EPOCH - $DATE_START_EPOCH`
DATE_HUMAN_DIFF=`date +%H:%M:%S -ud "@${DATE_DIFF}"`
DATE_END=`date +'%Y%m%d_%H%M%S'` # EPOCH Does not have timezone, so not using
echo "Build took $DATE_HUMAN_DIFF , ended at: ~$DATE_END (was started at ~$DATE_START)" | tee -a $NAME.log

echo "Trying also ftp upload using ./ftp_upload_apk_to_phone.sh ${NAME}.apk"
./scripts/ftp_upload_apk_to_phone.sh ${NAME}.apk

echo "Books loaded: du -sk fbreader/app/src/main/assets/data/SDCard/Books/"
du -sk fbreader/app/src/main/assets/data/SDCard/Books/
echo "TO retry ftp upload, do:  ./ftp_upload_apk_to_phone.sh ${NAME}.apk"
