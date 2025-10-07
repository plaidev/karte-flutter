# Build Tests

このディレクトリは、各種ビルド環境でFlutter SDKを利用可能であることを検証するためのテスト用アプリを含みます。  
[Old App](./old_app_test/)・[Latest App](./latest_app_test/) の2種類のテスト用アプリを用いて、ビルド可能性をテストしています。

⚠️ ここでテストされている古いビルド環境は、サポートされている環境とは限りません。また、ビルド環境は最新化することを推奨しています。

### ビルド環境

#### Android

|Build Environment|[Old App](../.github/workflows/test-build-old-app-android.yml)|Latest App|
|---|---|---|
|Flutter SDK Version/Dart SDK Version|3.7.0/2.19.0|3.35.1/3.9.0|
|AGP Version|7.4.1|8.12.0|
|Gradle Version|7.5|9.0.0|
|JDK Version for Gradle Tasks|JDK 11|JDK 21|
|Kotlin Version|1.8.10|2.2.10|
|jvmTarget/sourceCompatibility/targetCompatibility|Java 8|Java 21|

#### iOS

|Build Environment|[Old App](../.github/workflows/test-build-old-app-ios.yml)|Latest App|
|---|---|---|
|Flutter SDK Version/Dart SDK Version|3.7.0/2.19.0|3.35.1/3.9.0|
|Xcode Version|Xcode 16.0|Xcode 26.0|
|Swift Language Version|Swift 5|Swift 6|
