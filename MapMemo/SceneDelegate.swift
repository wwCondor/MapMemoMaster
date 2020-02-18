//
//  SceneDelegate.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MMTabBarController()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
        
    }
    
    private func configureNavigationBar() {
        //        let navigationBarAppearance = UINavigationBar.appearance()
        //        navigationBarAppearance.barTintColor = UIColor(named: .objectColor) // Bar background color
        //        navigationBarAppearance.tintColor = UIColor(named: .tintColor) // Tintcolor text and icons
        //        navigationBarAppearance.isTranslucent = false
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = .systemYellow
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .systemPink
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

