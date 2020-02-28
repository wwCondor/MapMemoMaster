//
//  UIViewController+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 28/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentMMAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertViewController = MMAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
//            navigationController?.pushViewController(alertViewController, animated: true)
            self.present(alertViewController, animated: true)
        }
    }
    
    func presentFailedPermissionActionSheet(description: String, viewController: UIViewController) {
        let actionSheet = UIAlertController(title: nil, message: description, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Ok, take me to Settings", style: .default, handler: { (action) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Thanks, but I'll go to settings later", style: .cancel, handler: { (action) in
            
        }))
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}
