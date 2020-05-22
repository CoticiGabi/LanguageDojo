//
//  AppDelegate.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 4/29/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        FirebaseApp.configure()
        let user = Auth.auth().currentUser
        print(user?.uid)
        if user != nil {
            UserService.observeUserProfile(user!.uid) { user in
                UserService.currentUser = user
            }
        }else {
                UserService.currentUser = nil
            }
        return true
    }

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

