//
//  MMTabBarController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [createMapNavController(), createReminderListNavController()]
        
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor    = .systemBackground
        tabBarAppearance.tintColor       = .systemPink
    }
    
    private func createMapNavController() -> UINavigationController {
        let mapVC = MapVC()
        let mapImage = SFSymbols.map
        mapVC.title = "Navigation"
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: mapImage, tag: 0)
        return   UINavigationController(rootViewController: mapVC)
    }
    
    private func createReminderListNavController() -> UINavigationController {
        let reminderListVC = ReminderListVC()
        let listImage = SFSymbols.list
        reminderListVC.title = "Reminders"
        reminderListVC.tabBarItem = UITabBarItem(title: "Reminders", image: listImage, tag: 1)
        return   UINavigationController(rootViewController: reminderListVC)
    }
}
