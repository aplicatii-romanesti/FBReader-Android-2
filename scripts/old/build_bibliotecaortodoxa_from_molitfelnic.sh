#!/bin/bash

echo "migrate to use from molitflecnic branch the app: BibliotecaOrtodoxa_bibliotecaortodoxa "
exit 1
set -eu
cd ../

git mv ./fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic ./fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti
git mv ./fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti_molitfelnic ./fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/romanesti

git mv ./fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderMolitfelnic.java ./fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReader.java
git mv ./fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplicationMolitfelnic.java ./fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBReaderApplication.java

git mv ./fbreader/app/src/main/java/org/nicolae/search_molitfelnic ./fbreader/app/src/main/java/org/nicolae/test

perl -p -i -e 's!search_molitfelnic!test!g' ./fbreader/app/src/main/java/org/nicolae/test/*.java ./fbreader/app/src/main/AndroidManifest.xml

ALL_FILES=$(find . \( -path "*/build" -o -path "./.gradle" -o -path "*/.git" \) -a -prune -o \( -type f \( -iname \*.java -o -iname \*.xml -o -iname \*.gradle -o -iname \*.properties \) -print \) )

perl -p -i -e 's!org.nicolae.search.!org.nicolae.test.!g' $ALL_FILES

perl -p -i -e 's!mfbreadermolitfelnic!fbreader!g' $ALL_FILES

perl -p -i -e 's!_molitfelnic!!g' $ALL_FILES

perl -p -i -e 's!Molitfelnic!!g' $ALL_FILES

TARGET_APP="BibliotecaOrtodoxa_bibliotecaortodoxa"
RESOURCES_DIR="./molitfelnic_to_any_app_res/${TARGET_APP}"
BOOKS_DIR=~/Books
BOOKS_WITH_HOWTO_DIR=~/Books_with_HowTO
#if [[ $TARGET_APP != "BibliotecaOrtodoxa_bibliotecaortodoxa" ]]; then
