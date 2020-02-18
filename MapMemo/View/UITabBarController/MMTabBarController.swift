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
        
        viewControllers = [createMapNavController(), createReminderListNavController()]//, createReminderNavController()]

        configureTabBarAppearance()
//        configureShadow()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = .systemBackground
        tabBarAppearance.tintColor = .systemPink
//        tabBarAppearance.layer.shadowColor = UIColor.systemPink.cgColor
//        tabBarAppearance.layer.shadowRadius = 20
//        tabBarAppearance.layer.shadowOpacity = 0.5
//        tabBarAppearance.layer.shadowOffset = .zero
//        tabBarAppearance.layer.masksToBounds = true
    }
    
//    private func configureShadow() {
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowRadius = 20
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowOffset = .zero
//        view.layer.masksToBounds = false
//    }
    
    /// Creates the UINavigationController
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

//    private func createReminderNavController() -> UINavigationController {
//        let reminderVC = ReminderVC()
//        let addImage = SFSymbols.add
//        reminderVC.title = "Reminder"
//        reminderVC.tabBarItem = UITabBarItem(title: "Add", image: addImage, tag: 2)
//        return   UINavigationController(rootViewController: reminderVC)
//    }
}
