//
//  TableViewExtension.swift
//  Listen
//
//  Created by Atul Prakash on 10/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import Foundation
import UIKit

// MARK: Loading Footer

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loadingFooter.frame.size.height = 50
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
}
