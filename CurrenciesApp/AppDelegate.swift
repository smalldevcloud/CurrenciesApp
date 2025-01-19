//
//  AppDelegate.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let vc = MainView()
        let navController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navController
//        let vc = MainView()
//        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    
        return true
    }
}
