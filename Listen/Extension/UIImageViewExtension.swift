//
//  UIImageViewExtension.swift
//  Listen
//
//  Created by Atul Prakash on 31/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIImageView {

    public func imageFromServerURL(urlString: String, PlaceHolderImage: UIImage) {
        
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        let allowedURL = urlString.paramEncode()

        URLSession.shared.dataTask(with: NSURL(string: allowedURL)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
