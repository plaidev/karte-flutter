# Release - 2025.12.17

### karte_core 2.1.0

**🔨CHANGED**

* ネイティブSDKのバージョンを更新しました:
  * iOS: KarteCore 2.32.0 → 2.34.0
    * 詳細は [iOS SDK Release Notes](https://app.developers.karte.io/ios-sdk/release-notes-ios-sdk) を参照してください
  * Android: core 2.31.1 → 2.32.0
    * 詳細は [Android SDK Release Notes](https://app.developers.karte.io/android-sdk/release-notes-android-sdk) を参照してください

### karte_in_app_messaging 2.1.0

**🔨CHANGED**

* ネイティブSDKのバージョンを更新しました:
  * iOS: KarteInAppMessaging 2.22.0 → 2.25.0
    * 詳細は [iOS SDK Release Notes](https://app.developers.karte.io/ios-sdk/release-notes-ios-sdk) を参照してください
  * Android: inappmessaging 2.24.0 → 2.25.0
    * 詳細は [Android SDK Release Notes](https://app.developers.karte.io/android-sdk/release-notes-android-sdk) を参照してください

### karte_notification 2.1.0

**🔨CHANGED**

* Androidにて、非推奨となったAsyncTaskをExecutorServiceとHandlerに置き換えました。
* ネイティブSDKのバージョンを更新しました:
  * Android: notifications 2.15.0 → 2.16.0
    * 詳細は [Android SDK Release Notes](https://app.developers.karte.io/android-sdk/release-notes-android-sdk) を参照してください

### karte_variables 2.1.0

**🔨CHANGED**

* ネイティブSDKのバージョンを更新しました:
  * Android: variables 2.10.0 → 2.11.0
    * 詳細は [Android SDK Release Notes](https://app.developers.karte.io/android-sdk/release-notes-android-sdk) を参照してください

### karte_visual_tracking 0.9.0

**🔨CHANGED**

* ネイティブSDKのバージョンを更新しました:
  * Android: visualtracking 2.12.0 → 2.13.0
    * 詳細は [Android SDK Release Notes](https://app.developers.karte.io/android-sdk/release-notes-android-sdk) を参照してください



# Release - 2025.10.06

### karte_core 2.0.0

**🔨CHANGED**

* Flutter SDKの最小要件を3.7.0に更新しました。
* Dart SDKの最小要件を2.19.0に更新しました。
* AGPとGradleのバージョンを更新しました。
* `compileSdk` を34に更新しました。
* 安定性向上のため、ネイティブSDKのバージョンを特定のリリースに固定しました:
  * iOS: KarteCore 2.32.0
  * Android: core 2.31.1
* iOSのDeployment Targetを10.0から15.0に変更しました。

### karte_in_app_messaging 2.0.0

**🔨CHANGED**

* Flutter SDKの最小要件を3.7.0に更新しました。
* Dart SDKの最小要件を2.19.0に更新しました。
* AGPとGradleのバージョンを更新しました。
* `compileSdk` を34に更新しました。
* 安定性向上のため、ネイティブSDKのバージョンを特定のリリースに固定しました:
  * iOS: KarteInAppMessaging 2.22.0
  * Android: inappmessaging 2.24.0
* iOSのDeployment Targetを10.0から15.0に変更しました。

### karte_notification 2.0.0

**🔨CHANGED**

* Flutter SDKの最小要件を3.7.0に更新しました。
* Dart SDKの最小要件を2.19.0に更新しました。
* AGPとGradleのバージョンを更新しました。
* `compileSdk` を34に更新しました。
* 安定性向上のため、ネイティブSDKのバージョンを特定のリリースに固定しました:
  * iOS: KarteRemoteNotification 2.13.0
  * Android: notifications 2.15.0
* iOSのDeployment Targetを10.0から15.0に変更しました。

### karte_variables 2.0.0

**🔨CHANGED**

* Flutter SDKの最小要件を3.7.0に更新しました。
* Dart SDKの最小要件を2.19.0に更新しました。
* AGPとGradleのバージョンを更新しました。
* `compileSdk` を34に更新しました。
* 安定性向上のため、ネイティブSDKのバージョンを特定のリリースに固定しました:
  * iOS: KarteVariables 2.13.0
  * Android: variables 2.10.0
* iOSのDeployment Targetを10.0から15.0に変更しました。

### karte_visual_tracking 0.8.0

**🔨CHANGED**

* Flutter SDKの最小要件を3.7.0に更新しました。
* Dart SDKの最小要件を2.19.0に更新しました。
* AGPとGradleのバージョンを更新しました。
* `compileSdk` を34に更新しました。
* 安定性向上のため、ネイティブSDKのバージョンを特定のリリースに固定しました:
  * iOS: KarteVisualTracking 2.14.0
  * Android: visualtracking 2.12.0
* iOSのDeployment Targetを10.0から15.0に変更しました。



# Release - 2025.03.03

### karte_core 1.4.0

**🔨CHANGED**

* Android の namespace 設定を追加しました。
* Android の build.gradle に buildFeatures.buildConfig 設定を追加しました。
* karte_core プラグインから registerWith メソッドを削除しました（古い Flutter プロジェクトのサポートを終了しました）。
* pubspec.lock 内の依存関係を更新しました。

### karte_in_app_messaging 1.4.0

**🔨CHANGED**

* Android の namespace 設定を追加しました。
* Android の build.gradle に buildFeatures.buildConfig 設定を追加しました。
* karte_core プラグインから registerWith メソッドを削除しました（古い Flutter プロジェクトのサポートを終了しました）。
* pubspec.lock 内の依存関係を更新しました。

### karte_notification 1.5.0

**🔨CHANGED**

* Android の namespace 設定を追加しました。
* Android の build.gradle に buildFeatures.buildConfig 設定を追加しました。
* karte_core プラグインから registerWith メソッドを削除しました（古い Flutter プロジェクトのサポートを終了しました）。
* pubspec.lock 内の依存関係を更新しました。

### karte_variables 1.5.0

**🔨CHANGED**

* Android の namespace 設定を追加しました。
* Android の build.gradle に buildFeatures.buildConfig 設定を追加しました。
* karte_core プラグインから registerWith メソッドを削除しました（古い Flutter プロジェクトのサポートを終了しました）。
* pubspec.lock 内の依存関係を更新しました。

### karte_visual_tracking 0.7.0

**🔨CHANGED**

* Android の namespace 設定を追加しました。
* Android の build.gradle に buildFeatures.buildConfig 設定を追加しました。
* karte_core プラグインから registerWith メソッドを削除しました（古い Flutter プロジェクトのサポートを終了しました）。
* pubspec.lock 内の依存関係を更新しました。



# Release - 2023.12.06

### karte_core 1.3.0

**🔨CHANGED**

* Android において、kotlinへの依存を削除しました。

### karte_in_app_messaging 1.3.0

**🔨CHANGED**

* Android において、kotlinへの依存を削除しました。

### karte_notification 1.4.0

**🔨CHANGED**

* Android において、kotlinへの依存を削除しました。

### karte_variables 1.4.0

**🔨CHANGED**

* Android において、kotlinへの依存を削除しました。

### karte_visual_tracking 0.6.0

**🔨CHANGED**

* Android において、kotlinへの依存を削除しました。

# Release - 2023.04.13

### karte_core 1.2.1

**💊FIXED**

* Androidの依存関係指定に誤った制限があったので修正しました。

# Release - 2023.03.14

### karte_core 1.2.0

**🔨CHANGED**

* Android SDK の参照する際に利用するリポジトリを JCenter から Meven Central に変更しました。
* 依存する KarteCore SDK のバージョンを更新しました。
* イベントに紐付けるカスタムオブジェクトに日付型（Date）オブジェクトを含めることが可能になりました。

### karte_in_app_messaging 1.2.0

**🔨CHANGED**

* Android SDK の参照する際に利用するリポジトリを JCenter から Meven Central に変更しました。

### karte_notification 1.3.0

**🔨CHANGED**

* Android SDK の参照する際に利用するリポジトリを JCenter から Meven Central に変更しました。
* 依存する firebase_messaging のバージョンを更新しました。

### karte_variables 1.3.0

**🔨CHANGED**

* イベントに紐付けるカスタムオブジェクトに日付型（Date）オブジェクトを含めることが可能になりました。

### karte_variables 1.2.0

**🔨CHANGED**

* Android SDK の参照する際に利用するリポジトリを JCenter から Meven Central に変更しました。

### karte_visual_tracking 0.5.0

**🔨CHANGED**

* Android SDK の参照する際に利用するリポジトリを JCenter から Meven Central に変更しました。

# Release - 2022.09.30

### karte_core 1.1.0

**🎉FEATURE**

* ビジュアルトラッキングの操作ログを自動で収集するためのwidgetのラッパーを追加しました。
* 再開時のDeepLink処理等に対応しました。
  * これにより[再開されるActivityに対応する](https://app.developers.karte.io/android-sdk-appendix/appendix-relaunch-activity-android-sdk)の対応が不要になります。
* attributeイベントを送信するためのAPIを追加しました。
* `identifyWithUserId` APIを追加しました。
* WebView連携のための補助APIとして `UserSync.getUserSyncScript` を追加しました。
  * 返されるスクリプトをWebViewで実行することで、`android.webkit.WebView以外のWebView`に対してもユーザー連携が可能になります。
  * これに伴い、クエリパラメータ連携API `UserSync.appendUserSyncQueryParameter` は非推奨になります。

**🔨CHANGED**

* Deployment Targetの変更 iOS9 → iOS10

### karte_in_app_messaging 1.1.0

**🔨CHANGED**

* Deployment Targetの変更 iOS9 → iOS10

### karte_notification 1.2.0

**🔨CHANGED**

* Deployment Targetの変更 iOS9 → iOS10

### karte_variables 1.1.0

**🔨CHANGED**

* Deployment Targetの変更 iOS9 → iOS10

### karte_visual_tracking 0.4.0

**🔨CHANGED**

* Deployment Targetの変更 iOS9 → iOS10

**💊FIXED**

* ページ遷移の際のイベント自動送信でクラッシュする可能性がある不具合を修正しました。

# Release - 2022.04.15

### karte_visual_tracking 0.3.0

**🎉FEATURE**

* ビジュアルトラッキングの操作ログを自動で収集するためのwidgetのラッパーを追加しました。

**💊FIXED**

* Flutter 2.5.0以降で廃止されていたAPIを使用していた部分を修正しました。

# Release - 2022.03.30

### karte_notification 1.1.0

**🔨CHANGED**

* firebase_messagingのバージョン11と組み合わせてビルドできるようにしました。

# Release - 2022.01.18

### karte_core 1.0.0

* GA版としてリリースしました。

### karte_in_app_messaging 1.0.0

* GA版としてリリースしました。

### karte_notification 1.0.0

* GA版としてリリースしました。

### karte_variables 1.0.0

* GA版としてリリースしました。

# Release - 2021.08.30

### karte_core 0.2.0

**🎉FEATURE**

* Null-Safetyに対応しました。

### karte_in_app_messaging 0.2.0

**🎉FEATURE**

* Null-Safetyに対応しました。

### karte_notification 0.2.0

**🎉FEATURE**

* Null-Safetyに対応しました。
* 依存するfirebase_messagingのバージョンを10.0.1以降に変更しました。
  これに伴い破壊的な変更が含まれています。詳しくは[アップグレードガイド](https://app.developers.karte.io/flutter-sdk/upgrade-guide-flutter-sdk)を参照してください。

### karte_variables 0.2.0

**🎉FEATURE**

* Null-Safetyに対応しました。

### karte_visual_tracking 0.2.0

**🎉FEATURE**

* Null-Safetyに対応しました。

# Release - 2021.03.26

### karte_visual_tracking 0.1.0

* 初回リリース

# Release - 2020.10.08

### karte_core 0.1.0

* 初回リリース

### karte_in_app_messaging 0.1.0

* 初回リリース

### karte_notification 0.1.0

* 初回リリース

### karte_variables 0.1.0

* 初回リリース
