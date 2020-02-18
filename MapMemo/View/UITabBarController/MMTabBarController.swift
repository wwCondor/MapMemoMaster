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
        
        viewControllers = [createMapNavController(), createReminderListNavController(), createReminderNavController()]

        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = .systemYellow
        tabBarAppearance.tintColor = .systemPink
    }
    
    /// Creates the UINavigationController
    private func createMapNavController() -> UINavigationController {
        let searchViewController = MapVC()
        let mapImage = SFSymbols.map
        searchViewController.title = "Navigation"
        searchViewController.tabBarItem = UITabBarItem(title: "Map", image: mapImage, tag: 0)
        return   UINavigationController(rootViewController: searchViewController)
    }
    
    private func createReminderListNavController() -> UINavigationController {
        let favouritesListViewController = ReminderListVC()
        let listImage = SFSymbols.list
        favouritesListViewController.title = "Active Reminders"
        favouritesListViewController.tabBarItem = UITabBarItem(title: "Reminders", image: listImage, tag: 1)
        
        return   UINavigationController(rootViewController: favouritesListViewController)
    }

    private func createReminderNavController() -> UINavigationController {
        let favouritesListViewController = ReminderVC()
        let addImage = SFSymbols.add
        favouritesListViewController.title = "Reminder"
        favouritesListViewController.tabBarItem = UITabBarItem(title: "Add", image: addImage, tag: 2)
        
        return   UINavigationController(rootViewController: favouritesListViewController)
    }
}
