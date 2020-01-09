//
//  UITableViewCellExtension.swift
//  Listen
//
//  Created by Atul Prakash on 09/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}
