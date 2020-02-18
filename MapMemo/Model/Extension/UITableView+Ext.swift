//
//  UITableView+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

extension UITableView {
    /// Removes the extra unused cells in the UITableView
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    /// (Not used atm) This can be used to update erload the data on the main thread directly if there is no other action required
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}
