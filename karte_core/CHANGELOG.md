## 2.1.0

* Updated native SDK versions:
  * iOS: KarteCore 2.32.0 → 2.34.0
    * For details, see [iOS SDK Release Notes](https://developers.karte.io/docs/release-notes-ios-sdk-v2)
  * Android: core 2.31.1 → 2.32.0
    * For details, see [Android SDK Release Notes](https://developers.karte.io/docs/release-notes-android-sdk-v2)

## 2.0.0

* Updated minimum Flutter SDK requirement to 3.7.0.
* Updated minimum Dart SDK requirement to 2.19.0.
* Updated AGP and Gradle versions.
* Updated compileSdk to 34.
* Fixed native SDK versions to specific releases for better stability:
  * iOS: KarteCore 2.32.0
  * Android: core 2.31.1
* Updated minimum iOS platform target from 10.0 to 15.0.

## 1.4.0

* Added Android namespace settings.
* Added buildFeatures.buildConfig settings to Android build.gradle.
* Removed registerWith method from karte_core plugin (ended support for old Flutter projects).
* Updated dependencies in pubspec.lock.

## 1.3.0

* Removed dependency on kotlin.

## 1.2.1

* Fixed an incorrect limitation in Android dependency specification.

## 1.2.0

* Android SDK references changed from JCenter to Maven Central.
* Updated the version of KarteCore on which the karte_core package depends.
* Changed to normalize custom objects for events.

## 1.1.0

* Change Deployment Target: iOS9 → iOS10
* Supported deeplink processing in resuming Activity on Android.
* Add `Tracker.indentifyWithUserId()` and `Tracker.attribute()`.
* Add `UserSync.getUserSyncScript()`.

## 1.0.0

* General availability release.

## 0.2.0

* Support null safety.

## 0.1.1

* [Android] Support AGP 4.1 and over.

## 0.1.0

* Initial Beta release.

## 0.0.1

* Initial development release.
