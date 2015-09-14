rm android-release-signed.apk
cordova build android --release
jarsigner -storepass pepsi22 -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore platforms/android/build/outputs/apk/android-release-unsigned.apk alias_name
/Users/ben/Downloads/zipalign -v 4 platforms/android/build/outputs/apk/android-release-unsigned.apk android-release-signed.apk
