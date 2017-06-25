//
//  AppDelegate.swift
//  iList Ambassador
//
//  Created by Pontus Andersson on 06/03/16.
//  Copyright © 2016 iList AB. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Flurry_iOS_SDK
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate let kFlurryKey = "B53YVH8X7K994Y2GFK79"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        let sessionBuilder = FlurrySessionBuilder()
            .withLogLevel(FlurryLogLevelCriticalOnly)
            .withCrashReporting(true)
        Flurry.startSession(kFlurryKey, with: sessionBuilder)
        
        Fabric.with([Crashlytics.self, Answers.self])
        
        // Update number of sessions
        AppManager.incrementNumberOfSessions()
        debugPrint("Session number: \( AppManager.numberOfSessions() )")
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath:"iListDish")
        URLCache.shared = urlCache
        
        // TODO: Want to remove old stuff in user defaults + core data. Maybe remove all and set boolean "migrated_to_version_3" in user defaults. If boolean exists, dont clean again..

        // Checking user authentication
        UserManager.sharedInstance.currentAuthorizedUser { (user) in
            if let _ = user {
                self.navigateToApplication()
            } else {
                self.navigateToLogin()
            }
        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                     open: url,
                                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url,
                                                                     sourceApplication: sourceApplication!,
                                                                     annotation: annotation)
    }
    
    // MARK: - Push notifications 
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        debugPrint("received push notification: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("failed to register for push notification: \( error.localizedDescription )")
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        registerPushToken(deviceTokenString)
    }
    
    func registerPushToken(_ token: String) {
        UserManager.sharedInstance.registerPushToken(token, completion: { success, error in
            guard success && error == nil else {
                debugPrint("Error: \(error)")
                return
            }
        })
    }

    // MARK: - Navigation
    
    func navigateToApplication() {
        debugPrint("Navigating to application")
        DispatchQueue.main.async(execute: {
            let application = UIApplication.shared
            self.registerForPushNotifications(application)
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        })
    }
    
    func navigateToLogin() {
        debugPrint("Navigating to login")
        DispatchQueue.main.async(execute: {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginAndRegisterViewController")
        })
    }
    
}
