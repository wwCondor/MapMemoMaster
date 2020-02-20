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
//        configureKeyboard()
    }
    
    private func configureNavigationBar() {
//        navigationController?.navigationBar.barTintColor = .systemBackground

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = .systemBackground
//        navigationBarAppearance.shadowImage = UIImage()
//        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
//        navigationBarAppearance.barTintColor = .systemYellow
//        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = .systemPink
//        navigationBarAppearance.addBorders(edges: [.bottom])
    }
    
//    private func configureTapBarAppearance() {
//        let tapBarAppearance = UITabBar.appearance()
//        tapBarAppearance.
//    }

//    private func configureKeyboard() {
//
//        keyboardAppearance      = .dark
//        spellCheckingType       = .no
//        autocapitalizationType  = .none
//        autocorrectionType      = .no
//        keyboardAppearance      = .dark
//        returnKeyType           = .done
//    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

