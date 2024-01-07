import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import awesome_notifications
import shared_preferences_foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    //Google Maps Setup
    GMSServices.provideAPIKey("AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4")
    GeneratedPluginRegistrant.register(with: self)
  // if #available(iOS 10.0, *) {
  //       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
  //     }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

