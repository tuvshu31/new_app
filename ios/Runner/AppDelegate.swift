import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4")
    application.registerForRemoteNotifications()
    // This is required to make any communication available in the action isolate.

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
   GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}



