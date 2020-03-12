//
//  AppDelegate.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 25/11/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            let isUserLogin = UserDefaults.standard.bool(forKey: "myKey")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           if isUserLogin {
            let newViewcontroller:AnimateTabbarViewController = mainstoryboard.instantiateViewController(withIdentifier: "AnimateTabbarViewController") as! AnimateTabbarViewController
                window.rootViewController = newViewcontroller
           } else {
            let newViewcontroller:LoginViewController = mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                window.rootViewController = newViewcontroller
        }

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
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

