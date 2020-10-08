import UIKit
import Flutter
import KarteCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  private let appKey = "YOUR_APP_KEY"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    KarteApp.setLogLevel(.debug)
    KarteApp.setup(appKey: appKey)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
