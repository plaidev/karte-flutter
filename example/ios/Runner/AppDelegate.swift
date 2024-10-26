import UIKit
import Flutter
import KarteCore

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let appKey = "YOUR_APP_KEY"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    KarteApp.setLogLevel(.debug)
    KarteApp.setup(appKey: appKey)

    if #available(iOS 10.0, *) {
      print("Use UserNotification.framework")
      UNUserNotificationCenter.current().delegate = self
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  @available(iOS 10.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // display notification even app is foreground.
    completionHandler([.alert])
    // call firebase_messaging swizzled method.
    super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: (completionHandler))
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return KarteApp.application(app, open: url)
  }
}
