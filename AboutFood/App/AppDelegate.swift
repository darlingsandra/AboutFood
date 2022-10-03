//
//  AppDelegate.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewController = ArticlesViewController(collectionViewLayout: UICollectionViewLayout())
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
}

