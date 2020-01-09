//
//  ToastMessageView.swift
//  Listen
//
//  Created by Atul Prakash on 09/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import UIKit

class ToastMessageView: UIView {

    @IBOutlet weak var toastMessageLabel: UILabel!
    
    static func loadNib() -> Any {
        let nib = Bundle.main.loadNibNamed("ToastMessageView", owner: self, options: nil)
        return nib![0]
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
