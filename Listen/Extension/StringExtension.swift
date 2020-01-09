//
//  StringExtension.swift
//  Listen
//
//  Created by Atul Prakash on 28/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import Foundation
import CryptoKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String{
    var MD5:String {
        get{
            let messageData = self.data(using:.utf8)!
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

            _ = digestData.withUnsafeMutableBytes { (digestBytes) -> Bool in
                messageData.withUnsafeBytes({ (messageBytes) -> Bool in
                    _ = CC_MD5(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
                    return true
                })
            }
            
            return digestData.map { String(format: "%02hhx", $0) }.joined()
        }
    }
    
    func paramEncode() -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();@&=+$,?%#[] ").inverted)
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
    
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
