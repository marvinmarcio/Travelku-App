//
//  AppDelegate.swift
//  Travel
//
//  Created by Marvin Marcio on 02/04/21.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import MapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyBTOS8QRYL9vMDfS-XkBIcawfUKnqkdFeA")
        GMSServices.provideAPIKey("AIzaSyBTOS8QRYL9vMDfS-XkBIcawfUKnqkdFeA")
        
     
        // Override point for customization after application launch.
        return true
    }
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.mainBundle())
//        let logined = ?
//        var vc: UIViewController?
//        if !logined {
//            vc = storyboard.instantiateViewControllerWithIdentifier("homeScreen")
//        } else {
//            vc = storyboard.instantiateInitialViewController()
//        }
//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        window?.rootViewController = vc
//        window?.makeKeyAndVisible()
//        return true
//    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

