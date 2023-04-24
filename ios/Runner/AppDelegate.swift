import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import awesome_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4")
        // This is required to make any communication available in the action isolate.
   GeneratedPluginRegistrant.register(with: self)

   // This function registers the desired plugins to be used within a notification background action
      SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in          
          SwiftAwesomeNotificationsPlugin.register(
<<<<<<< Updated upstream
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
=======
<<<<<<< HEAD
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)          
    
=======
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
>>>>>>> c8f933f1b6bbde55b60cbe62eae1fb11eaa804ea
>>>>>>> Stashed changes
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}



