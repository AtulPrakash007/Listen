//
//  ViewControllerExtension.swift
//  Listen
//
//  Created by Atul Prakash on 09/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK:- Json Data Validation
    func validateJsonDataForString(in dict:NSDictionary, for keyPath:String) -> String {
      if (dict.value(forKeyPath: keyPath) == nil) || (dict.value(forKeyPath: keyPath) is NSNull) || (dict.value(forKeyPath: keyPath) as? String == "") || dict.value(forKeyPath: keyPath) as? String == "null" || dict.value(forKeyPath: keyPath) as? String == "NULL"{
          return "NA"
      }else{
        return dict.value(forKeyPath: keyPath) as! String
      }
    }
    
    func validateJsonDataForStringArray(in dict:NSDictionary, for keyPath:String) -> [String] {
        if (dict.value(forKeyPath: keyPath) == nil) {
          return []
      }else if (dict.value(forKeyPath: keyPath) is NSNull) {
            return []
        } else if (dict.value(forKeyPath: keyPath) as? [String])?.count == 0 {
            return []
        } else {
            return dict.value(forKeyPath: keyPath) as! [String]
        }
    }
    
    func validateJsonDataForStringInsideArray(in dict:NSDictionary, for keyPath:String) -> [[String]] {
        if (dict.value(forKeyPath: keyPath) == nil) {
          return []
      }else if (dict.value(forKeyPath: keyPath) is NSNull) {
            return []
        } else if (dict.value(forKeyPath: keyPath) as? [[String]])?.count == 0 {
            return []
        } else {
            return dict.value(forKeyPath: keyPath) as! [[String]]
        }
    }
    
    //MARK:- Store JSON Data
    func parseAlbumData(from json: NSDictionary) -> DetailDataModel {
        let images = self.validateJsonDataForStringArray(in: json, for: AppLocators.AlbumKey.image)
        let tags = self.validateJsonDataForStringArray(in: json, for: AppLocators.AlbumKey.tags)
        let tracksName = self.validateJsonDataForStringArray(in: json, for: AppLocators.AlbumKey.tracksName)
        let tracksDuration = self.validateJsonDataForStringArray(in: json, for: AppLocators.AlbumKey.tracksDuration)
        let artist = self.validateJsonDataForString(in: json, for: AppLocators.AlbumKey.artist)
        let listeners = self.validateJsonDataForString(in: json, for: AppLocators.AlbumKey.listeners)
        let name = self.validateJsonDataForString(in: json, for: AppLocators.AlbumKey.name)
        let playcount = self.validateJsonDataForString(in: json, for: AppLocators.AlbumKey.playcount)
        let url = self.validateJsonDataForString(in: json, for: AppLocators.AlbumKey.url)
        let summary = self.validateJsonDataForString(in: json, for: AppLocators.AlbumKey.summary)
        
        return DetailDataModel(image: images, artist: artist, listeners: listeners, name: name, playcount: playcount, url: url, summary: summary, tags: tags, tracksName: tracksName, tracksDuration: tracksDuration, smilarArtistImage: [], similarArtistName: [])
    }
    
    func parseArtistData(from json: NSDictionary) -> DetailDataModel {
        let images = self.validateJsonDataForStringArray(in: json, for: AppLocators.ArtistKey.image)
        let tags = self.validateJsonDataForStringArray(in: json, for: AppLocators.ArtistKey.tags)
        let similarArtistImage = self.validateJsonDataForStringInsideArray(in: json, for: AppLocators.ArtistKey.smilarArtistImage)
        let smilarArtistName = self.validateJsonDataForStringArray(in: json, for: AppLocators.ArtistKey.similarArtistName)
        let artist = self.validateJsonDataForString(in: json, for: AppLocators.ArtistKey.artist)
        let listeners = self.validateJsonDataForString(in: json, for: AppLocators.ArtistKey.listeners)
        let name = self.validateJsonDataForString(in: json, for: AppLocators.ArtistKey.name)
        let playcount = self.validateJsonDataForString(in: json, for: AppLocators.ArtistKey.playcount)
        let url = self.validateJsonDataForString(in: json, for: AppLocators.ArtistKey.url)
        let summary = self.validateJsonDataForString(in: json, for: AppLocators.ArtistKey.summary)
        
        return DetailDataModel(image: images, artist: artist, listeners: listeners, name: name, playcount: playcount, url: url, summary: summary, tags: tags, tracksName: [], tracksDuration: [], smilarArtistImage: similarArtistImage, similarArtistName: smilarArtistName)
    }
    
    func parseTrackData(from json: NSDictionary) -> DetailDataModel {
        let images = self.validateJsonDataForStringArray(in: json, for: AppLocators.TrackKey.image)
        let tags = self.validateJsonDataForStringArray(in: json, for: AppLocators.TrackKey.tags)
        let artist = self.validateJsonDataForString(in: json, for: AppLocators.TrackKey.artist)
        let listeners = self.validateJsonDataForString(in: json, for: AppLocators.TrackKey.listeners)
        let name = self.validateJsonDataForString(in: json, for: AppLocators.TrackKey.name)
        let playcount = self.validateJsonDataForString(in: json, for: AppLocators.TrackKey.playcount)
        let url = self.validateJsonDataForString(in: json, for: AppLocators.TrackKey.url)
        let summary = self.validateJsonDataForString(in: json, for: AppLocators.TrackKey.summary)
        
        return DetailDataModel(image: images, artist: artist, listeners: listeners, name: name, playcount: playcount, url: url, summary: summary, tags: tags, tracksName: [], tracksDuration: [], smilarArtistImage: [], similarArtistName: [])
    }
    
    //MARK:- Show toast message
    func showToast(message : String) {
        let toastView = ToastMessageView.loadNib() as! ToastMessageView
        toastView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
        toastView.toastMessageLabel.clipsToBounds = true
        toastView.toastMessageLabel.text = message
        self.view.addSubview(toastView)
        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastView.alpha = 0.0
            toastView.transform = CGAffineTransform(translationX: 0, y: -50)
        }, completion: {(finished) in
            
            UIView.animate(withDuration: 4.0, delay: 0.5, options: .curveEaseInOut, animations: {
                toastView.transform = CGAffineTransform(translationX: 0, y: 50)
            }, completion: {(finished) in
                toastView.removeFromSuperview()
            })
        })
    }
}
