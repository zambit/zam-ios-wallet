//
//  AppDelegate.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Firebase
import Hero

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var mainScreenFlow: ScreenFlow!
    var userDefaultsManager: UserDefaultsManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //HeroDebugPlugin.isEnabled = true

        // configure firebase analytics
        FirebaseApp.configure()

        // enable debug mode for crashlytics
        Crashlytics.sharedInstance().debugMode = true

        userDefaultsManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())

        let navigationController = WalletNavigationController()
        switch (userDefaultsManager.isPhoneVerified, userDefaultsManager.isPinCreated) {
        case (true, true):
            guard let phone = userDefaultsManager.getPhoneNumber() else {
                fatalError("isPhoneVerified property lies")
            }

            // set crashlytics user id as his phone number
            Crashlytics.sharedInstance().setUserIdentifier(phone)

            let screenFlow = EnterPinFlow(migratingNavigationController: navigationController)
            screenFlow.prepare(phone: phone)

            self.mainScreenFlow = screenFlow
            self.mainScreenFlow.begin(animated: false)
            break
        case (true, false):
            guard let phone = userDefaultsManager.getPhoneNumber() else {
                fatalError("isPhoneVerified property lies")
            }

            // set crashlytics user id as his phone number
            Crashlytics.sharedInstance().setUserIdentifier(phone)

            let screenFlow = SecondEnterLoginFlow(migratingNavigationController: navigationController)
            screenFlow.prepare(phone: phone)

            self.mainScreenFlow = screenFlow
            self.mainScreenFlow.begin(animated: false)
            break
        case (false, true):
            fatalError("Unexpected initial state")
        case (false, false):
            let screenFlow = OnboardingFlow(migratingNavigationController: navigationController)

            self.mainScreenFlow = screenFlow
            self.mainScreenFlow.begin(animated: false)
            break
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

