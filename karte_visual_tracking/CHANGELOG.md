## x.x.x

* Updated minimum Flutter SDK requirement to 3.7.0.
* Updated minimum Dart SDK requirement to 2.19.0.
* Updated AGP and Gradle versions.
* Updated compileSdk to 34.
* Fixed native SDK versions to specific releases for better stability:
  * iOS: KarteVisualTracking 2.14.0
  * Android: visualtracking 2.12.0
* Updated minimum iOS platform target from 10.0 to 15.0.

## 0.7.0

* Added Android namespace settings.
* Added buildFeatures.buildConfig settings to Android build.gradle.
* Removed registerWith method from karte_core plugin (ended support for old Flutter projects).
* Updated dependencies in pubspec.lock.

## 0.6.0

* Removed dependency on kotlin.

## 0.5.0

* Android SDK references changed from JCenter to Maven Central.

## 0.4.0

* Change Deployment Target: iOS9 → iOS10
* Fix action id calculation logic (#16).

## 0.3.0

* Replace obsolete api.
* Added a widget wrapper to automatically collect visual tracking operation logs.

## 0.2.0

* Support null safety.

## 0.1.0

Initial Beta release.

## 0.0.1

* Initial development release.
