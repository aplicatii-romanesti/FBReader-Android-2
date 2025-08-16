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
