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
VSQL=$(grep 'currentVersion =' ${BUILD_FOLDER}/fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java| cut -d"=" -f2 | cut -d";" -f1 | cut -d" " -f2)

sleep 3

if [[ $VV -ne $VSQL ]]; then
  echo "ERROR !!!!  $VV != $VSQL -> FIX VERSIONS!!!"
  exit 9
fi

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
#rm -rf fbreader/app/src/main/assets/data/SDCard/Books
#cp /home/aplicatii-romanesti/Books/Biblia/* fbreader/app/src/main/assets/data/SDCard/Books/
#cp /home/aplicatii-romanesti/Books/Scrieri/Vietile* fbreader/app/src/main/assets/data/SDCard/Books/
#cp -r /home/aplicatii-romanesti/Books/* fbreader/app/src/main/assets/data/SDCard/Books/
unzip -q '/home/aplicatii-romanesti/ToateCartile_EPUB_latest.zip' -d fbreader/app/src/main/assets/data/SDCard/
cp -r /home/aplicatii-romanesti/Books_with_HowTO/* fbreader/app/src/main/assets/data/SDCard/Books/
#cd -

### ACTUAL BUILD
CLEAN=1
docker rm -f fb 2>/dev/null || true
cp local.properties.docker local.properties
if [[ $CLEAN -gt 0 ]]; then
echo "do optional cleanup"
sleep 2
sudo rm -rf ./.gradle/ 2>/dev/null || true
#docker run --name fb -ti -v `pwd`:/p mingc/android-build-box:1.25.0 bash -c 'cd /p/ && ./gradlew  --gradle-user-home=/p/.gradle/ clean' || true | tee -a $GIT_BRANCH.log
docker rm -f fb 2>/dev/null || true
sudo find . -type d -name ".cxx" -exec rm -r {} \; || true
sudo find . -type d -name ".externalNativeBuild" -exec rm -r {} \; || true
sudo rm -rf ./.gradle/ 2>/dev/null || true
sudo rm -rf ./fbreader/app/build/generated/not_namespaced_r_class_sources/* 2>/dev/null || true #so we will be able to use Android Studio as well afterwards...
sudo chown -R aplicatii-romanesti:aplicatii-romanesti `pwd`
else
  echo "no clean"
fi
docker rm -f fb 2>/dev/null || true
#exit 0
NDK_VER=$(grep globalNdkVersion build.gradle | cut -d"=" -f2 | cut -d'"' -f2)
ANDROID_NDK=/opt/android-sdk/ndk/$NDK_VER
echo "actual build starts now"
sleep 1
#docker run --name fb -ti -e JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/ -e ANDROID_NDK=$ANDROID_NDK -e ANDROID_NDK_HOME=$ANDROID_NDK -e ANDROID_NDK_ROOT=$ANDROID_NDK -v `pwd`:/p mingc/android-build-box:1.25.0 bash -c 'cd /p/ && ./gradlew --warning-mode all --gradle-user-home=/p/.gradle/ assembleRelease' | tee -a $NAME.log
docker run --name fb -ti -v `pwd`:/p mingc/android-build-box:1.25.0 bash -c 'cd /p/ && ./gradlew --warning-mode all --gradle-user-home=/p/.gradle/ clean assembleRelease' | tee -a $NAME.log
#sudo rm -rf FBReader-Android-2-dev/fbreader/app/build/generated/not_namespaced_r_class_sources/* || true #so we will be able to use Android Studio as well afterwards...
sudo rm -rf ./fbreader/app/build/generated/not_namespaced_r_class_sources/* 2>/dev/null || true #so we will be able to use Android Studio as well afterwards...
sudo chown -R aplicatii-romanesti:aplicatii-romanesti `pwd`
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
