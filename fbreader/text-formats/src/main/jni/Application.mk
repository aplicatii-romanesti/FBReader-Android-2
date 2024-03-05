APP_ABI :=  arm64-v8a armeabi-v7a x86 x86_64
#APP_STL := stlport_static # deprecated, use either c++_static or c++_shared. See https://developer.android.com/ndk/guides/cpp-support.html
APP_STL := c++_static
 # newer