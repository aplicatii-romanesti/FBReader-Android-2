#!/bin/bash
set -xe -o pipefail
#find ./ -type f "*.java" -exec perl -p -i -e 's!FBReaderMolitfelnic.ORG!FBReader.ORG!g' {} +
#git clone -b bibliotecaortodoxa --single-branch https://github.com/aplicatii-romanesti/FBReader-Android-2.git
#git checkout -b molitfelnic bibliotecaortodoxa

# INPUT

if [[ -n $1 ]]; then
  echo "Name of the app being build provided as input is: $1"
  TARGET_APP="$1"
  echo "${TARGET_APP}" >../current_app.txt~
elif [[ -r ../current_app.txt~ ]]; then
  TARGET_APP=$(cat ../current_app.txt~)
else
  echo "Please provide input, e.g. BibliotecaOrtodoxa sau Pidalion sau VietileSfintilor sau BibliaOrtodoxa"
  #TARGET_APP=${1:-BibliotecaOrtodoxa}
  exit 1
fi

set -u

echo "TARGET_APP=$TARGET_APP"

# BASE SETUP:
RESOURCES_DIR="./molitfelnic_to_any_app_res/${TARGET_APP}"
BOOKS_DIR=~/Books

# Make sure we are in the right directory:
echo "STEP 0.2: Pre-Sanity: Make sure we are in the right directory:"
cd ..
pwd
if [[ ! -r .gitignore ]]; then
        echo "Not in the right directory... ; Call me from scripts directory of the molitfelnic branch "
        exit
fi

# STEP 0.3 Pre-Sanity: Make sure we are on molitfelnic branch!:
echo "STEP 0.3 Pre-Sanity: Make sure we are on molitfelnic branch!:"
export GIT_BRANCH=$(git branch | grep '*' | cut -d' ' -f2)
if [[ ${GIT_BRANCH} != "molitfelnic" ]]; then
	echo "we are not on molitfelnic branch... we are on: ${GIT_BRANCH} ..."
	echo "you may want to do: git checkout molitfelnic"
	exit
fi

# STEP 0.4 Pre-Sanity: Make sure there was a git reset HEAD:
echo "STEP 0.4 Pre-Sanity: Make sure there was a git reset --hard HEAD (or similar):"
if [[ 0 -eq $(grep -c molitfelnic fbreader/app/build.gradle || true) ]]; then
	echo "the grep applicationId fbreader/app/build.gradle does not find molitfelnic; you may want to do git reset --hard HEAD "
	grep applicationId fbreader/app/build.gradle | head -1
	exit
fi

# ## even if it's Molitfelnic, we simulate the same steps, so no need to exit here any longer, commetning out:
# # STEP 0.45
# echo "STEP 0.45 - check if we have to build Molitfelnic"

# if [[ "${TARGET_APP}" == "Molitfelnic" ]]; then
#   echo "We have to build Molitfelnic"
#   exit 0
# fi

# STEP 0.5: Make sure we have the png icons avaialble && get app names
echo "STEP 0.5: Make sure we have the png icons avaialble"
if [[ ! -r ${RESOURCES_DIR}/drawable-hdpi/fbreader.png ]]; then
        echo "Could not find the icons in: ${RESOURCES_DIR}/drawable-hdpi/fbreader.png " && exit 1
else
        cp -rpf ${RESOURCES_DIR}/drawable-*dpi ./fbreader/app/src/main/res/
#        cp -rpf ${RESOURCES_DIR}/drawable-*dpi ./fbreader/app/src/main/res/
        #remove Krita projects
        find ./fbreader/app/src/main/res/ -type f -name '*.png.kra' | xargs rm -f
fi

# STEP 0.55: Make sure we have the required resources
echo " STEP 0.55: Make sure we have the required resources"
if [[ ( ! -r ${RESOURCES_DIR}/epub_first_internal_path.list ) || ( ! -r ${RESOURCES_DIR}/epubs.list ) || ( ! -r ${RESOURCES_DIR}/name.metadata ) ]]; then
	echo "Make sure you have all these files: ${RESOURCES_DIR}/epub_first_internal_path.list ${RESOURCES_DIR}/epubs.list ${RESOURCES_DIR}/name.metadata"
	exit 4
fi

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
while IFS= read B ; do
	echo B=$B
	ls -la "${BOOKS_DIR}/${B}"
	cp -rfp "${BOOKS_DIR}/${B}" ./fbreader/app/src/main/assets/data/SDCard/Books/
	ls -la ./fbreader/app/src/main/assets/data/SDCard/Books/
done < ${RESOURCES_DIR}/epubs.list

# STEP 0.9: determine name of the new app and other metadata details
echo "STEP 0.9: determine name of the new app and other metadata details:"
NEWAPP_CAMEL=$(grep NEWAPP_CAMEL ${RESOURCES_DIR}/name.metadata | cut -d"=" -f2)
NEWAPP_SMALL=$(echo $NEWAPP_CAMEL | tr '[:upper:]' '[:lower:]' )
NEWAPP_NAME=$NEWAPP_CAMEL
NEWAPP_NAME=$(grep NEWAPP_NAME ${RESOURCES_DIR}/name.metadata | cut -d"=" -f2)
NEWAPP_SEARCH_HINT=$NEWAPP_CAMEL
NEWAPP_SEARCH_HINT=$(grep NEWAPP_SEARCH_HINT ${RESOURCES_DIR}/name.metadata | cut -d"=" -f2)

if [[ -z "$NEWAPP_CAMEL" || -z "$NEWAPP_NAME" || -z "${NEWAPP_SEARCH_HINT}" ]]; then
	echo "Error: some params could not be found in ${RESOURCES_DIR}/name.metadata"
	exit
fi

# STEP 1: Replace inside files:
echo "STEP 1: Replace inside files:"
#ALL_FILES=$(find ./ -type f \( -iname \*.java -o -iname \*.xml -o -iname \*.gradle -o -iname \*.properties \) )
#ALL_FILES=$(find ./ -type f ! \( -path '*/.gradle/*' -o -path '*/generated/*' -o -path '/*intermediates/*' \)  \( -iname \*.java -o -iname \*.xml -o -iname \*.gradle -o -iname \*.properties \)  )
ALL_FILES=$(find . \( -path "*/build" -o -path "./.gradle" -o -path "*/.git" \) -a -prune -o \( -type f \( -iname \*.java -o -iname \*.xml -o -iname \*.gradle -o -iname \*.properties \) -print \) )

perl -p -i -e "s^molitfelnic^${NEWAPP_SMALL}^g" $ALL_FILES
perl -p -i -e "s^Molitfelnic^${NEWAPP_CAMEL}^g" $ALL_FILES

echo "STEP 1.1 - getFirstFileBookReplaceTOKEN"
EPUB_FIRST="\"$(cat ${RESOURCES_DIR}/epub_first_internal_path.list | tail -1)\""
sed -i "s%.*getFirstFileBookReplaceTOKEN.*%${EPUB_FIRST}%" fbreader/app/src/main/java/org/geometerplus/fbreader/book/BookUtil.java


echo "STEP 2: Replace application name and its search hint"
# STEP 2: Replace application name and its search hint

cat <<EOF >fbreader/app/src/main/res/values/strings.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
       <string name="app_name">${NEWAPP_NAME}</string>
    <string name="search_hint">${NEWAPP_SEARCH_HINT}</string>
</resources>

EOF

echo "STEP 3: Replace names of files and folders:"
# STEP 3: Replace names of files and folders:
if [[ "${TARGET_APP}" != "Molitfelnic" ]]; then
  git mv fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic/ fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_${NEWAPP_SMALL}/

  git mv fbreader/app/src/main/java/org/nicolae/search_molitfelnic/ fbreader/app/src/main/java/org/nicolae/search_${NEWAPP_SMALL}/

  git mv fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic/ fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_${NEWAPP_SMALL}/

  git mv fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplicationMolitfelnic.java fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplication${NEWAPP_CAMEL}.java

  git mv fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderMolitfelnic.java fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReader${NEWAPP_CAMEL}.java
else
  echo "We have to build Molitfelnic, skipped git mv"
fi
echo "Sanity 1"
grep Application fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplication${NEWAPP_CAMEL}.java

echo "Sanity 2"
grep Application fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReader${NEWAPP_CAMEL}.java

echo "Sanity 3: expect to have changes in 186 files. Your git status | wc is:"
git status | wc -l

echo "${0} finished at `date`"
echo "git branch $NEWAPP_SMALL"
############# aplicatii.romanesti to molitfelnic:
# mv fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplicationMolitfelnic.java fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplication.java
# git mv fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplication.java fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplicationMolitfelnic.java

# mv fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderMolitfelnic.java fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReader.java
# git mv fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReader.java fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderMolitfelnic.java

# rm -rf fbreader/app/src/main/java/org/nicolae/test/
# mv fbreader/app/src/main/java/org/nicolae/search_molitfelnic/ fbreader/app/src/main/java/org/nicolae/test/
# git mv fbreader/app/src/main/java/org/nicolae/test/ fbreader/app/src/main/java/org/nicolae/search_molitfelnic/

# rm -rf fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti/
# mv fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic/ fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti/
# git mv fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti/ fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic/

# rm -rf fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti/
# mv fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic/ fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti/
# git mv fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti/ fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic/


# ###
# git checkout fbreader/common/src/main/java/org/geometerplus/fbreader/Paths.java
# git checkout fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/BookDownloader.java

