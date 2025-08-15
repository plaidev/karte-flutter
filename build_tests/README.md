# Build Tests

このディレクトリは、各種ビルド環境でFlutter SDKを利用可能であることを検証するためのテスト用アプリを含みます。  
[Old App](./old_app_test/)・Latest App (Latest Appは追加予定) の2種類のテスト用アプリを用いて、ビルド可能性をテストしています。

⚠️ ここでテストされている古いビルド環境は、サポートされている環境とは限りません。また、ビルド環境は最新化することを推奨しています。

### ビルド環境

#### Android

|Build Environment|[Old App](../.github/workflows/test-build-old-app-android.yml)|Latest App (🚧)|
|---|---|---|
|Flutter SDK Version/Dart SDK Version|3.7.0/2.19.0|TBD|
|AGP Version|7.4.1|TBD|
|Gradle Version|7.5|TBD|
|JDK Version for Gradle Tasks|JDK 11|TBD|
|Kotlin Version|1.8.10|TBD|
|jvmTarget/sourceCompatibility/targetCompatibility|Java 8|TBD|

#### iOS

|Build Environment|[Old App](../.github/workflows/test-build-old-app-ios.yml)|Latest App (🚧)|
|---|---|---|
|Flutter SDK Version/Dart SDK Version|3.7.0/2.19.0|TBD|
|Xcode Version|Xcode 16.0|TBD|
|Swift Language Version|Swift 5|TBD|
