import UIKit
import Flutter
import GoogleMaps
import FirebaseCore

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
  if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
   // Awesome Notification Setup
      // SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in       
      //     SwiftAwesomeNotificationsPlugin.register(
      //       with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)          
      //     SharedPreferencesPlugin.register(
      //       with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin")!)
      // }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

