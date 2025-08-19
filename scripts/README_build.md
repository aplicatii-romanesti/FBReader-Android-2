## HOWTO Build aplicatia normala

## HOWTO Build anything:
0. Make sure all desired changes are commited to the molitfelnic branch
   a. code is shared with Molitfelnic
   b. resources are in: ~/FBReader-Android-2/molitfelnic_to_any_app_res
   c. books in Books (you need to copy eventually from ~/Books_with_HowTO/) ... 
1. `git checkout molitfelnic` (optional, already in script)
2. `git reset --hard HEAD` (optional, already in script)
3. `git pull; git merge origin/bibliotecaortodoxa`
(which merges latest changes from bibliotecaortodoxa, which is the dev branch)
4. `./build_all_molitfelnic_based.sh Liturghier`
    which mainly does: ./molitfelnic_to_any_app.sh $app && ./dockerbuild.sh $app
(dockerbuild.sh which uses docker image: mingc/android-build-box)
OR all of them, without any param. It will build both apk and aab unless specified in the inner dockerbuild.sh (currently BUILD_TYPE is not exposed beyond that)
   `build_all_molitfelnic_based.sh`

(no need for dockerbuild_molitfelnic_only.sh any longer, the generic ./molitfelnic_to_any_app.sh does also Molitfelnic)
(no need for build_bibliotecaortodoxa_from_molitfelnic.sh any longer, the generic ./molitfelnic_to_any_app.sh does also BibliotecaOrtodoxa_bibliotecaortodoxa )



--------------
it was determined on 19 Aug 2025, then on bibliotecaortodoxa, I did git pull and, it was identified that it was changed to become like molitfelnic :(...
Probably some reverse merge at some point: Commit cc59d36 "Merge branch 'molitfelnic' into bibliotecaortodoxa"
https://github.com/aplicatii-romanesti/FBReader-Android-2/commit/cc59d367b5742aacf01351a6189240575325c796
last known good commit before it, was: 32e79eb+63bb761:
 32e79eb => "mingc1.29" = https://github.com/aplicatii-romanesti/FBReader-Android-2/commit/32e79eb6ff6dac8e69e7dcab154edf8496ddb2f3
 63bb761 => https://github.com/aplicatii-romanesti/FBReader-Android-2/commit/63bb7619dc42703f39cb0fde5d08b0eac7b892a2
see:

aplicatii-romanesti@pn50 FBReader-Android-2/scripts on  bibliotecaortodoxa [⇣] via 🐪 v5.38.2 on ☁️   
✦ ❯ git pull
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Updating 0d9aadb77..64afdb624
Fast-forward
 PrivacyPolicy.md                                                                                                        |  14 ++++
 build.gradle                                                                                                            |  16 +++--
 fbreader/api/src/main/java/org/geometerplus/android/fbreader/api/FBReaderIntents.java                                   |  64 ++++++++---------
 fbreader/app/VERSION                                                                                                    |   2 +-
 fbreader/app/build.gradle                                                                                               |  19 ++++-
 fbreader/app/src/main/AndroidManifest.xml                                                                               | 100 +++++++++++++-------------
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/AppNotifier.java                                           |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/CancelActivity.java                                        |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/DisplayBookPopupAction.java                                |   6 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ExternalFileOpener.java                                    |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/FBAndroidAction.java                                       |   4 +-
 .../src/main/java/org/geometerplus/android/fbreader/{FBReaderApplication.java => FBReaderApplicationMolitfelnic.java}   |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/{FBReader.java => FBReaderMolitfelnic.java}                |  49 +++++++------
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/HideToastAction.java                                       |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/InstallPluginsAction.java                                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/NavigationPopup.java                                       |   8 +--
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/OpenVideoAction.java                                       |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/OpenWebHelpAction.java                                     |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/PluginListActivity.java                                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/PopupPanel.java                                            |   6 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ProcessHyperlinkAction.java                                |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/RunPluginAction.java                                       |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SearchAction.java                                          |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionBookmarkAction.java                               |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionCopyAction.java                                   |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionHidePanelAction.java                              |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionPopup.java                                        |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionShareAction.java                                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionShowPanelAction.java                              |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SelectionTranslateAction.java                              |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SetOrientationAction.java                                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShareBookAction.java                                       |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowBookInfoAction.java                                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowBookmarksAction.java                                   |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowCancelMenuAction.java                                  |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowLibraryAction.java                                     |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowMenuAction.java                                        |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowNavigationAction.java                                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowNetworkLibraryAction.java                              |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowPreferencesAction.java                                 |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowSearchLibraryAction.java                               |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/ShowTOCAction.java                                         |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/StartScreenAction.java                                     |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/SwitchProfileAction.java                                   |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/TOCActivity.java                                           |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/TextSearchPopup.java                                       |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/api/PluginApi.java                                         |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/bookmark/BookmarksActivity.java                            |   8 +--
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/bookmark/BookmarksUtil.java                                |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/bookmark/EditBookmarkActivity.java                         |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/bookmark/EditStyleActivity.java                            |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/covers/CoverManager.java                                   |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/crash/FixBooksDirectoryActivity.java                       |   6 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/error/BookReadingErrorActivity.java                        |   6 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/httpd/DataInterface.aidl                                   |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/httpd/DataServer.java                                      |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/image/ImageViewActivity.java                               |   8 +--
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/library/BookInfoActivity.java                              |  16 ++---
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/library/LibraryActivity.java                               |   5 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/library/LibrarySearchActivity.java                         |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/library/LibraryTreeAdapter.java                            |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/libraryService/SQLiteBooksDatabase.java                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/AddCustomCatalogActivity.java                      |   6 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/AuthenticationActivity.java                        |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/BookDownloader.java                                |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/BookDownloaderInterface.aidl                       |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/BookDownloaderService.java                         |   8 +--
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/BuyBooksActivity.java                              |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/CatalogManagerActivity.java                        |   3 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/MenuActivity.java                                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/NetworkBookInfoActivity.java                       |  10 +--
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/NetworkLibraryActivity.java                        |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/NetworkLibraryAdapter.java                         |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/NetworkSearchActivity.java                         |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/Util.java                                          |  16 ++---
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/action/AddCustomCatalogAction.java                 |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/action/ManageCatalogsAction.java                   |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/action/NetworkBookActions.java                     |   7 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/action/RefreshRootCatalogAction.java               |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/action/ReloadCatalogAction.java                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/action/RunSearchAction.java                        |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/auth/AndroidNetworkContext.java                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/auth/ServiceNetworkContext.java                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/auth/TokenAuthActivity.java                        |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/litres/AutoRegistrationActivity.java               |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/litres/RegistrationActivity.java                   |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/network/litres/UserRegistrationActivity.java               |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/AnimationSpeedPreference.java                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/ColorPreference.java                           |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/FontPreference.java                            |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/PreferenceActivity.java                        |  14 ++--
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/StringPreference.java                          |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/ZLColorPreference.java                         |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/ZLPreferenceActivity.java                      |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/background/BackgroundPreference.java           |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/background/Chooser.java                        |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/preferences/background/PredefinedImages.java               |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/sync/SyncService.java                                      |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/tips/TipsActivity.java                                     |   6 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/tree/TreeActivity.java                                     |   4 +-
 fbreader/app/src/main/java/org/geometerplus/android/fbreader/util/SimpleDialogActivity.java                             |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/util/EditAuthorsDialogActivity.java                                 |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/util/EditListDialogActivity.java                                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/util/EditTagsDialogActivity.java                                    |   2 +-
 fbreader/app/src/main/java/org/geometerplus/android/util/FolderListDialogActivity.java                                  |   2 +-
 fbreader/app/src/main/java/org/geometerplus/fbreader/book/BookUtil.java                                                 |  13 ++++
 fbreader/app/src/main/java/org/geometerplus/fbreader/fbreader/FBReaderApp.java                                          |   7 +-
 fbreader/app/src/main/java/org/geometerplus/zlibrary/core/util/ZLNetworkUtil.java                                       |   2 +-
 .../geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/network/SQLiteCookieDatabase.java   |   2 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/BitmapManagerImpl.java     |   4 +-
 .../java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/ZLAndroidWidget.java  |  12 ++--
 fbreader/app/src/main/java/org/nicolae/{test => search_molitfelnic}/BookSearchHintProvider.java                         |   4 +-
 fbreader/app/src/main/java/org/nicolae/{test => search_molitfelnic}/LocalLibrarySearchActivity.java                     |   6 +-
 fbreader/app/src/main/res/drawable-hdpi/fbreader.png                                                                    | Bin 2473 -> 780 bytes
 fbreader/app/src/main/res/drawable-ldpi/fbreader.png                                                                    | Bin 1200 -> 318 bytes
 fbreader/app/src/main/res/drawable-mdpi/fbreader.png                                                                    | Bin 1567 -> 1760 bytes
 fbreader/app/src/main/res/drawable-xhdpi/fbreader.png                                                                   | Bin 3171 -> 1276 bytes
 fbreader/app/src/main/res/drawable-xxhdpi/fbreader.png                                                                  | Bin 4725 -> 1901 bytes
 fbreader/app/src/main/res/layout/main.xml                                                                               |   2 +-
 fbreader/app/src/main/res/values/strings.xml                                                                            |   4 +-
 fbreader/app/src/main/res/xml/searchable_for_local_library_activity.xml                                                 |   6 +-
 fbreader/common/src/main/AndroidManifest.xml                                                                            |   2 +-
 fbreader/common/src/main/java/org/geometerplus/android/fbreader/FBReaderMainActivity.java                               |   4 +-
 fbreader/common/src/main/java/org/geometerplus/android/fbreader/util/AndroidImageSynchronizer.java                      |   4 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/error/BugReportActivity.java    |   2 +-
 .../main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/error/ErrorKeys.java  |   2 +-
 .../main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/error/ErrorUtil.java  |   2 +-
 .../java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/BitmapImageData.java |   2 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/InputStreamImageData.java |   2 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLAndroidImageData.java   |   2 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLAndroidImageLoader.java |   2 +-
 .../geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLAndroidImageManager.java    |   2 +-
 .../java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLBitmapImage.java   |   2 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/library/UncaughtExceptionHandler.java            |   4 +-
 .../geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/library/ZLAndroidApplication.java   |   4 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/library/ZLAndroidLibrary.java   |   2 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/util/ZLAndroidColorUtil.java    |   2 +-
 .../java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/AndroidFontUtil.java  |   4 +-
 .../main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/MainView.java    |   2 +-
 .../main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/ViewUtil.java    |   2 +-
 .../org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/ZLAndroidPaintContext.java |   6 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/AnimationProvider.java            |   2 +-
 .../geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/BitmapManager.java   |   2 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/CurlAnimationProvider.java        |   6 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/NoneAnimationProvider.java        |   4 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/ShiftAnimationProvider.java       |   4 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/SimpleAnimationProvider.java      |   2 +-
 .../zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/SlideAnimationProvider.java       |   4 +-
 .../ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/SlideOldStyleAnimationProvider.java        |   4 +-
 gradle/wrapper/gradle-wrapper.properties                                                                                |   2 +-
 molitfelnic_to_any_app_res/Apostolul/drawable-hdpi/fbreader.png                                                         | Bin 0 -> 1763 bytes
 molitfelnic_to_any_app_res/Apostolul/drawable-ldpi/fbreader.png                                                         | Bin 0 -> 867 bytes
 molitfelnic_to_any_app_res/Apostolul/drawable-mdpi/fbreader.png                                                         | Bin 0 -> 835 bytes
 molitfelnic_to_any_app_res/Apostolul/drawable-xhdpi/fbreader.png                                                        | Bin 0 -> 2692 bytes
 molitfelnic_to_any_app_res/Apostolul/drawable-xxhdpi/fbreader.png                                                       | Bin 0 -> 2692 bytes
 molitfelnic_to_any_app_res/Apostolul/epub_first_internal_path.list                                                      |   1 +
 molitfelnic_to_any_app_res/Apostolul/epubs.list                                                                         |   1 +
 molitfelnic_to_any_app_res/Apostolul/name.metadata                                                                      |   3 +
 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-hdpi/fbreader.png                                                    | Bin 0 -> 1824 bytes
 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-ldpi/fbreader.png                                                    | Bin 0 -> 1000 bytes
 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-mdpi/fbreader.png                                                    | Bin 0 -> 1384 bytes
 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-xhdpi/fbreader.png                                                   | Bin 0 -> 3538 bytes
 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-xxhdpi/fbreader.png                                                  | Bin 0 -> 2317 bytes
 molitfelnic_to_any_app_res/BibliaOrtodoxa/epub_first_internal_path.list                                                 |   1 +
 molitfelnic_to_any_app_res/BibliaOrtodoxa/epubs.list                                                                    |   1 +
 molitfelnic_to_any_app_res/BibliaOrtodoxa/name.metadata                                                                 |   3 +
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-hdpi/fbreader.png                                                | Bin 0 -> 1273 bytes
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-ldpi/fbreader.png                                                | Bin 0 -> 466 bytes
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-mdpi/fbreader.png                                                | Bin 0 -> 582 bytes
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-xhdpi/fbreader.png                                               | Bin 0 -> 1764 bytes
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-xxhdpi/fbreader.png                                              | Bin 0 -> 2814 bytes
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/epub_first_internal_path.list                                             |   1 +
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/epubs.list                                                                |   1 +
 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/name.metadata                                                             |   3 +
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-hdpi/fbreader.png                                            | Bin 0 -> 12496 bytes
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-ldpi/fbreader.png                                            | Bin 0 -> 3459 bytes
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-mdpi/fbreader.png                                            | Bin 0 -> 5834 bytes
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-xhdpi/fbreader.png                                           | Bin 0 -> 21818 bytes
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-xxhdpi/fbreader.png                                          | Bin 0 -> 48308 bytes
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/epub_first_internal_path.list                                         |   1 +
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/epubs.list                                                            |   1 +
 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/name.metadata                                                         |   3 +
 molitfelnic_to_any_app_res/Evanghelia/drawable-hdpi/fbreader.png                                                        | Bin 0 -> 2172 bytes
 molitfelnic_to_any_app_res/Evanghelia/drawable-ldpi/fbreader.png                                                        | Bin 0 -> 763 bytes
 molitfelnic_to_any_app_res/Evanghelia/drawable-mdpi/fbreader.png                                                        | Bin 0 -> 684 bytes
 molitfelnic_to_any_app_res/Evanghelia/drawable-xhdpi/fbreader.png                                                       | Bin 0 -> 2172 bytes
 molitfelnic_to_any_app_res/Evanghelia/drawable-xxhdpi/fbreader.png                                                      | Bin 0 -> 2894 bytes
 molitfelnic_to_any_app_res/Evanghelia/epub_first_internal_path.list                                                     |   1 +
 molitfelnic_to_any_app_res/Evanghelia/epubs.list                                                                        |   1 +
 molitfelnic_to_any_app_res/Evanghelia/name.metadata                                                                     |   3 +
 molitfelnic_to_any_app_res/Liturghier/drawable-hdpi/fbreader.png                                                        | Bin 0 -> 607 bytes
 molitfelnic_to_any_app_res/Liturghier/drawable-ldpi/fbreader.png                                                        | Bin 0 -> 852 bytes
 molitfelnic_to_any_app_res/Liturghier/drawable-mdpi/fbreader.png                                                        | Bin 0 -> 848 bytes
 molitfelnic_to_any_app_res/Liturghier/drawable-xhdpi/fbreader.png                                                       | Bin 0 -> 1647 bytes
 molitfelnic_to_any_app_res/Liturghier/drawable-xxhdpi/fbreader.png                                                      | Bin 0 -> 1376 bytes
 molitfelnic_to_any_app_res/Liturghier/epub_first_internal_path.list                                                     |   1 +
 molitfelnic_to_any_app_res/Liturghier/epubs.list                                                                        |   1 +
 molitfelnic_to_any_app_res/Liturghier/name.metadata                                                                     |   3 +
 molitfelnic_to_any_app_res/Mineiele/drawable-hdpi/fbreader.png                                                          | Bin 0 -> 1051 bytes
 molitfelnic_to_any_app_res/Mineiele/drawable-ldpi/fbreader.png                                                          | Bin 0 -> 409 bytes
 molitfelnic_to_any_app_res/Mineiele/drawable-mdpi/fbreader.png                                                          | Bin 0 -> 554 bytes
 molitfelnic_to_any_app_res/Mineiele/drawable-xhdpi/fbreader.png                                                         | Bin 0 -> 1299 bytes
 molitfelnic_to_any_app_res/Mineiele/drawable-xxhdpi/fbreader.png                                                        | Bin 0 -> 1743 bytes
 molitfelnic_to_any_app_res/Mineiele/epub_first_internal_path.list                                                       |   1 +
 molitfelnic_to_any_app_res/Mineiele/epubs.list                                                                          |   1 +
 molitfelnic_to_any_app_res/Mineiele/name.metadata                                                                       |   3 +
 molitfelnic_to_any_app_res/Molitfelnic/drawable-hdpi/fbreader.png                                                       | Bin 0 -> 780 bytes
 molitfelnic_to_any_app_res/Molitfelnic/drawable-ldpi/fbreader.png                                                       | Bin 0 -> 318 bytes
 molitfelnic_to_any_app_res/Molitfelnic/drawable-mdpi/fbreader.png                                                       | Bin 0 -> 1760 bytes
 molitfelnic_to_any_app_res/Molitfelnic/drawable-xhdpi/fbreader.png                                                      | Bin 0 -> 1276 bytes
 molitfelnic_to_any_app_res/Molitfelnic/drawable-xxhdpi/fbreader.png                                                     | Bin 0 -> 1901 bytes
 molitfelnic_to_any_app_res/Molitfelnic/epub_first_internal_path.list                                                    |   1 +
 molitfelnic_to_any_app_res/Molitfelnic/epubs.list                                                                       |   1 +
 molitfelnic_to_any_app_res/Molitfelnic/name.metadata                                                                    |   3 +
 molitfelnic_to_any_app_res/Pidalion/drawable-hdpi/fbreader.png                                                          | Bin 0 -> 905 bytes
 molitfelnic_to_any_app_res/Pidalion/drawable-ldpi/fbreader.png                                                          | Bin 0 -> 303 bytes
 molitfelnic_to_any_app_res/Pidalion/drawable-mdpi/fbreader.png                                                          | Bin 0 -> 375 bytes
 molitfelnic_to_any_app_res/Pidalion/drawable-xhdpi/fbreader.png                                                         | Bin 0 -> 1122 bytes
 molitfelnic_to_any_app_res/Pidalion/drawable-xxhdpi/fbreader.png                                                        | Bin 0 -> 1690 bytes
 molitfelnic_to_any_app_res/Pidalion/epub_first_internal_path.list                                                       |   1 +
 molitfelnic_to_any_app_res/Pidalion/epubs.list                                                                          |   1 +
 molitfelnic_to_any_app_res/Pidalion/name.metadata                                                                       |   3 +
 molitfelnic_to_any_app_res/Sinaxar/drawable-hdpi/fbreader.png                                                           | Bin 0 -> 1758 bytes
 molitfelnic_to_any_app_res/Sinaxar/drawable-ldpi/fbreader.png                                                           | Bin 0 -> 821 bytes
 molitfelnic_to_any_app_res/Sinaxar/drawable-mdpi/fbreader.png                                                           | Bin 0 -> 869 bytes
 molitfelnic_to_any_app_res/Sinaxar/drawable-xhdpi/fbreader.png                                                          | Bin 0 -> 2439 bytes
 molitfelnic_to_any_app_res/Sinaxar/drawable-xxhdpi/fbreader.png                                                         | Bin 0 -> 3291 bytes
 molitfelnic_to_any_app_res/Sinaxar/epub_first_internal_path.list                                                        |   1 +
 molitfelnic_to_any_app_res/Sinaxar/epubs.list                                                                           |   1 +
 molitfelnic_to_any_app_res/Sinaxar/name.metadata                                                                        |   3 +
 molitfelnic_to_any_app_res/Triodul/AppIcons/Apostolul_AppIcon.png.png                                                   | Bin 0 -> 9328 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Ceaslovul_AppIcon.png.png                                                   | Bin 0 -> 9620 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Evanghelia_AppIcon.png                                                      | Bin 0 -> 25584 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Evanghelia_AppIcon.png.kra                                                  | Bin 0 -> 81161 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Paterice_AppIcon.png.png                                                    | Bin 0 -> 7369 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Psaltirea_AppIcon.png.png                                                   | Bin 0 -> 8671 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Sbornicul_AppIcon.png.png                                                   | Bin 0 -> 9564 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Sinaxar_AppIcon.png.png                                                     | Bin 0 -> 9938 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Tipicul_AppIcon.png.png                                                     | Bin 0 -> 6296 bytes
 molitfelnic_to_any_app_res/Triodul/AppIcons/Triodul_AppIcon.png.png                                                     | Bin 0 -> 8827 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-hdpi/fbreader.png                                                           | Bin 0 -> 1424 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-hdpi/fbreader.png.kra                                                       | Bin 0 -> 52698 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-ldpi/fbreader.png                                                           | Bin 0 -> 463 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-ldpi/fbreader.png.kra                                                       | Bin 0 -> 34796 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-mdpi/fbreader.png                                                           | Bin 0 -> 458 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-mdpi/fbreader.png.kra                                                       | Bin 0 -> 31722 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-xhdpi/fbreader.png                                                          | Bin 0 -> 1708 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-xhdpi/fbreader.png.kra                                                      | Bin 0 -> 37636 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-xxhdpi/fbreader.png                                                         | Bin 0 -> 2346 bytes
 molitfelnic_to_any_app_res/Triodul/drawable-xxhdpi/fbreader.png.kra                                                     | Bin 0 -> 38465 bytes
 molitfelnic_to_any_app_res/Triodul/epub_first_internal_path.list                                                        |   1 +
 molitfelnic_to_any_app_res/Triodul/epubs.list                                                                           |   1 +
 molitfelnic_to_any_app_res/Triodul/name.metadata                                                                        |   3 +
 molitfelnic_to_any_app_res/VietileSfintilor/drawable-hdpi/fbreader.png                                                  | Bin 0 -> 1152 bytes
 molitfelnic_to_any_app_res/VietileSfintilor/drawable-ldpi/fbreader.png                                                  | Bin 0 -> 524 bytes
 molitfelnic_to_any_app_res/VietileSfintilor/drawable-mdpi/fbreader.png                                                  | Bin 0 -> 672 bytes
 molitfelnic_to_any_app_res/VietileSfintilor/drawable-xhdpi/fbreader.png                                                 | Bin 0 -> 1559 bytes
 molitfelnic_to_any_app_res/VietileSfintilor/drawable-xxhdpi/fbreader.png                                                | Bin 0 -> 2190 bytes
 molitfelnic_to_any_app_res/VietileSfintilor/epub_first_internal_path.list                                               |   1 +
 molitfelnic_to_any_app_res/VietileSfintilor/epubs.list                                                                  |   1 +
 molitfelnic_to_any_app_res/VietileSfintilor/name.metadata                                                               |   3 +
 molitfelnic_to_any_app_res/_Template/AppIcons/Apostolul_AppIcon.png.png                                                 | Bin 0 -> 9328 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Ceaslovul_AppIcon.png.png                                                 | Bin 0 -> 9620 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Evanghelia_AppIcon.png                                                    | Bin 0 -> 25584 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Evanghelia_AppIcon.png.kra                                                | Bin 0 -> 81161 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Paterice_AppIcon.png.png                                                  | Bin 0 -> 7369 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Psaltirea_AppIcon.png.png                                                 | Bin 0 -> 8671 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Sbornicul_AppIcon.png.png                                                 | Bin 0 -> 9564 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Sinaxar_AppIcon.png.png                                                   | Bin 0 -> 9938 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Tipicul_AppIcon.png.png                                                   | Bin 0 -> 6296 bytes
 molitfelnic_to_any_app_res/_Template/AppIcons/Triodul_AppIcon.png.png                                                   | Bin 0 -> 8449 bytes
 molitfelnic_to_any_app_res/_Template/drawable-hdpi/fbreader.png                                                         | Bin 0 -> 2172 bytes
 molitfelnic_to_any_app_res/_Template/drawable-hdpi/fbreader.png.kra                                                     | Bin 0 -> 51557 bytes
 molitfelnic_to_any_app_res/_Template/drawable-ldpi/fbreader.png                                                         | Bin 0 -> 763 bytes
 molitfelnic_to_any_app_res/_Template/drawable-ldpi/fbreader.png.kra                                                     | Bin 0 -> 34481 bytes
 molitfelnic_to_any_app_res/_Template/drawable-mdpi/fbreader.png                                                         | Bin 0 -> 684 bytes
 molitfelnic_to_any_app_res/_Template/drawable-mdpi/fbreader.png.kra                                                     | Bin 0 -> 31428 bytes
 molitfelnic_to_any_app_res/_Template/drawable-xhdpi/fbreader.png                                                        | Bin 0 -> 2172 bytes
 molitfelnic_to_any_app_res/_Template/drawable-xhdpi/fbreader.png.kra                                                    | Bin 0 -> 36872 bytes
 molitfelnic_to_any_app_res/_Template/drawable-xxhdpi/fbreader.png                                                       | Bin 0 -> 2894 bytes
 molitfelnic_to_any_app_res/_Template/drawable-xxhdpi/fbreader.png.kra                                                   | Bin 0 -> 37978 bytes
 molitfelnic_to_any_app_res/_Template/epub_first_internal_path.list                                                      |   1 +
 molitfelnic_to_any_app_res/_Template/epubs.list                                                                         |   1 +
 molitfelnic_to_any_app_res/_Template/name.metadata                                                                      |   3 +
 proguard.cfg                                                                                                            |   2 +
 scripts/README_build.md                                                                                                 |  18 +++++
 scripts/build_all_molitfelnic_based.sh                                                                                  |  59 ++++++++++++++++
 scripts/build_bibliotecaortodoxa.sh                                                                                     |   7 ++
 scripts/build_bibliotecaortodoxa_biblia_only.sh                                                                         |   2 +-
 scripts/dockerBuilderImage.txt                                                                                          |   2 +-
 scripts/dockerbuild.sh                                                                                                  | 147 ++++++++++++++++++++++++++++++++++++++
 scripts/dockerbuild_molitfelnic_only.sh                                                                                 | 105 ++++++++++++++++++++++++++++
 scripts/ftp_upload_apk_to_phone.sh                                                                                      |  18 +++--
 scripts/molitfelnic_to_any_app.sh                                                                                       | 237 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 third-party/AmbilWarna/.project                                                                                         |  23 +++++-
 295 files changed, 1039 insertions(+), 397 deletions(-)
 create mode 100644 PrivacyPolicy.md
 rename fbreader/app/src/main/java/org/geometerplus/android/fbreader/{FBReaderApplication.java => FBReaderApplicationMolitfelnic.java} (82%)
 rename fbreader/app/src/main/java/org/geometerplus/android/fbreader/{FBReader.java => FBReaderMolitfelnic.java} (94%)
 rename fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/network/SQLiteCookieDatabase.java (99%)
 rename fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/BitmapManagerImpl.java (95%)
 rename fbreader/app/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/ZLAndroidWidget.java (98%)
 rename fbreader/app/src/main/java/org/nicolae/{test => search_molitfelnic}/BookSearchHintProvider.java (97%)
 rename fbreader/app/src/main/java/org/nicolae/{test => search_molitfelnic}/LocalLibrarySearchActivity.java (94%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/error/BugReportActivity.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/error/ErrorKeys.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/error/ErrorUtil.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/BitmapImageData.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/InputStreamImageData.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLAndroidImageData.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLAndroidImageLoader.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLAndroidImageManager.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/image/ZLBitmapImage.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/library/UncaughtExceptionHandler.java (94%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/library/ZLAndroidApplication.java (93%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/library/ZLAndroidLibrary.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/util/ZLAndroidColorUtil.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/AndroidFontUtil.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/MainView.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/ViewUtil.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/ZLAndroidPaintContext.java (98%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/AnimationProvider.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/BitmapManager.java (97%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/CurlAnimationProvider.java (97%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/NoneAnimationProvider.java (95%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/ShiftAnimationProvider.java (95%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/SimpleAnimationProvider.java (99%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/SlideAnimationProvider.java (96%)
 rename fbreader/common/src/main/java/org/geometerplus/zlibrary/ui/android/aplicatii/{romanesti => romanesti_molitfelnic}/view/animation/SlideOldStyleAnimationProvider.java (95%)
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Apostolul/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/BibliaOrtodoxa/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/BibliotecaOrtodoxa/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/ColindeUraturiPlugusor/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Evanghelia/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Liturghier/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Mineiele/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Molitfelnic/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Pidalion/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Sinaxar/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Apostolul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Ceaslovul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Evanghelia_AppIcon.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Evanghelia_AppIcon.png.kra
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Paterice_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Psaltirea_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Sbornicul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Sinaxar_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Tipicul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/AppIcons/Triodul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-hdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-ldpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-mdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-xhdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/Triodul/drawable-xxhdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/Triodul/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/Triodul/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/Triodul/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/VietileSfintilor/name.metadata
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Apostolul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Ceaslovul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Evanghelia_AppIcon.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Evanghelia_AppIcon.png.kra
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Paterice_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Psaltirea_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Sbornicul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Sinaxar_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Tipicul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/AppIcons/Triodul_AppIcon.png.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-hdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-hdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-ldpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-ldpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-mdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-mdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-xhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-xhdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-xxhdpi/fbreader.png
 create mode 100644 molitfelnic_to_any_app_res/_Template/drawable-xxhdpi/fbreader.png.kra
 create mode 100644 molitfelnic_to_any_app_res/_Template/epub_first_internal_path.list
 create mode 100644 molitfelnic_to_any_app_res/_Template/epubs.list
 create mode 100644 molitfelnic_to_any_app_res/_Template/name.metadata
 create mode 100644 scripts/README_build.md
 create mode 100755 scripts/build_all_molitfelnic_based.sh
 create mode 100755 scripts/dockerbuild.sh
 create mode 100755 scripts/dockerbuild_molitfelnic_only.sh
 mode change 100644 => 100755 scripts/molitfelnic_to_any_app.sh

