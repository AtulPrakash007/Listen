//
//  RoundImageView.swift
//  Listen
//
//  Created by Atul Prakash on 31/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        layer.masksToBounds = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
