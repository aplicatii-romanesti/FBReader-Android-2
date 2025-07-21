## HOWTO Build aplicatia normala

## HOWTO Build Molitfelnic
1. `git checkout molitfelnic`
2. `git reset --hard HEAD`
3. `dockerbuild_molitfelnic_only.sh`
(which uses dockerbuild.sh which uses docker image: mingc/android-build-box:1.11.1)

## HOWTO Build restul de aplicatii
0. Make sure all desired changes are commited to the molitfelnic branch
   a. code is shared with Molitfelnic
   b. resources are in: ~/FBReader-Android-2/molitfelnic_to_any_app_res
   c. books in ~/Books_with_HowTO/
1. `git checkout molitfelnic` (optional, already in script)
2. `git reset --hard HEAD`  (optional, already in script)
3. `./build_all_molitfelnic_based.sh Liturghier`
    which mainly does: ./molitfelnic_to_any_app.sh $app && ./dockerbuild.sh $app
OR all of them:
   `build_all_molitfelnic_based.sh`

