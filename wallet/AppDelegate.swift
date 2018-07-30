//
//  AppDelegate.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var mainScreenFlow: ScreenFlow?

    @objc
    private func initialNavigationControllerBackButton(_ sender: Any) {

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent

        let phone = "+79136653903"
        let code = "195227"
        let password = "a12345678b"

        print("start")

        let navigationController = WalletNavigationController()
        self.mainScreenFlow = OnboardingFlow(navigationController: navigationController)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        self.mainScreenFlow?.begin()
//        api?.sendVerificationCode(to: phone).done {
//            print("success")
//        }
//        .catch { error in
//            print(error)
//        }


//        api?.verifyUserAccount(passing: code, hasBeenSentTo: phone).done {
//            [weak self]
//            token in
//
//            guard let strongSelf = self else {
//                return
//            }
//
//            print("Signup token: \(token)")
//
//            strongSelf.api?.providePassword(password, confirmation: password, for: phone, signUpToken: token).done { authToken in
//
//                print("Auth token: \(authToken)")
//            }.catch { error in
//                print(error)
//            }
//        }.catch { error in
//            print(error)
//        }

//        authApi?.signIn(phone: phone, password: password).done {
//            [weak self]
//            token in
//
//            guard let strongSelf = self else {
//                return
//            }
//
//            print("Auth token: \(token)")
//
//            strongSelf.authApi?.checkIfUserAuthorized(token: token).done { phone in
//                print("User authorized with phone: \(phone)")
//            }.catch { error in
//                print(error)
//            }
//        }.catch { error in
//            print(error)
//        }

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

