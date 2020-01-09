//
//  Request.swift
//  Listen
//
//  Created by Atul Prakash on 28/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import UIKit

class Request: NSObject {
    static let sharedInstance = Request()
    let session = URLSession(configuration: .default)
        
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    completion(nil, error)
                    return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    func request(url:String, method: String, params: [String: String], completion: @escaping (NSDictionary, Error?)->() ){
        if let nsURL = URL(string:url) {
            let request = NSMutableURLRequest(url: nsURL as URL)
            var postString:String = ""
            if method == "POST" {
                // convert key, value pairs into param string
                postString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
                let postData = postString.data(using: .ascii, allowLossyConversion: true)
                let postLength = String(postData!.count)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                request.httpBody = postData
//                request.setValue("text/json; oe=utf-8", forHTTPHeaderField: "Accept")
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            print("Url: \(nsURL) & param: \(postString)")

            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do {
                    
                    // what happens if error is not nil?
                    // That means something went wrong.
                    // Make sure there really is some data
                    if let data = data {
                        let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print(datastring ?? "default value")
    //                        var jsonResultDic:NSDictionary  = [String:AnyObject]() as NSDictionary
                        let jsonResultDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        completion(jsonResultDic, nil)
                    }
                    else {
                        print("Data is nil") //pass data as nil or notification of failure
                        completion([:], error)
                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                    completion([:], error)
                }
            }
            task.resume()
        }
        else{
            // Could not make url. Is the url bad?
            // You could call the completion handler (callback) here with some value indicating an error
        }
    }
    
    func postRequest(url:String, method: String, params: String, completion: @escaping (NSDictionary, Error?)->() ){
        if let nsURL = URL(string:url) {
            let request = NSMutableURLRequest(url: nsURL as URL)
            if method == "POST" {
                let postData = params.data(using: .ascii, allowLossyConversion: true)
                let postLength = String(postData!.count)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                request.httpBody = postData
                //                request.setValue("text/json; oe=utf-8", forHTTPHeaderField: "Accept")
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            print("Url: \(nsURL) & param: \(params)")
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do {
                    
                    // what happens if error is not nil?
                    // That means something went wrong.
                    // Make sure there really is some data
                    if let data = data {
                        let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print(datastring ?? "default value")
                        //                        var jsonResultDic:NSDictionary  = [String:AnyObject]() as NSDictionary
                        let jsonResultDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        completion(jsonResultDic, nil)
                    }
                    else {
                        print("Data is nil") //pass data as nil or notification of failure
                        completion([:], error)
                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                    completion([:], error)
                }
            }
            task.resume()
        }
        else{
            // Could not make url. Is the url bad?
            // You could call the completion handler (callback) here with some value indicating an error
        }
    }
}
