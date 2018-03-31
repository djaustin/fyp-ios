//
//  AppDelegate.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit
import p2_OAuth2
import UserNotifications


/// Global utility function that runs the provided code block on the UI thread
///
/// - Parameter block: Code block to run on the UI thread
func UI(_ block: @escaping ()->Void) {
    DispatchQueue.main.async(execute: block)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    /// Runs when the application is finished launching. This attempts to generate a client access token using the 'Client Credentials' OAuth 2 flow
    /// It also requests notification permission from the user to allow usage goal notifications to be received
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials.authorize { (json, error) in
            if let error = error {
                print(error)
            }
        }
        
        // Request permission from the user to send them notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                UI {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }

    // Run when the user authorises notifications on the app. Saves the APNs device token so that it can be sent to the API on user login
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        // Save the token in the user defaults for later use
        UserDefaults.standard.setValue(token, forKey: "deviceToken")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // Remove existing tokens and attempt to retrieve new tokens
        DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials.forgetTokens();
        DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials.authorize { (json, error) in
            if let error = error {
                print(error)
            }
        }

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

