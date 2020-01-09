//
//  GetTestData.swift
//  Listen
//
//  Created by Atul Prakash on 28/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import Foundation

class GetTestData: NSObject {
    static let sharedInstance = GetTestData()
    var preSetupData: NSDictionary!
    
    override init() {
        super.init()
        self.preSetupData = nil
    }
    
    /// Getting the pre setup data from the plist file
    func getPreSetupData() -> NSDictionary {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)!
        } else {
            return [:]
        }
    }
    
    func setTestDataToSharedInstance() {
        if GetTestData.sharedInstance.preSetupData == nil {
            GetTestData.sharedInstance.preSetupData = self.getPreSetupData()
        }
    }
}

