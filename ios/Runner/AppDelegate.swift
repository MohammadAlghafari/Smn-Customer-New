import UIKit
import Flutter
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
      }
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyD_lRvTskGkN80rrp59iaaMPyG8SmzZRQE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
