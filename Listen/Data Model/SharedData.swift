//
//  SharedData.swift
//  Listen
//
//  Created by Atul Prakash on 08/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import UIKit

open class SharedData: NSObject {
    
    open class var sharedInstance: SharedData {
        struct Static {
            static let instance = SharedData()
        }
        return Static.instance
    }
    
    var artist: String = ""
    var searchCriteria: String = AppLocators.track
    var name: String = ""
}
