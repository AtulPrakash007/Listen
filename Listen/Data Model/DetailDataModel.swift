//
//  DetailDataModel.swift
//  Listen
//
//  Created by Atul Prakash on 08/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import Foundation

struct DetailDataModel {
    var image = [String]()
    var artist = ""
    var listeners = ""
    var name = ""
    var playcount = ""
    var url = ""
    var summary = ""
    var tags = [String]()
    var tracksName = [String]()
    var tracksDuration = [String]()
    var smilarArtistImage = [[String]]()
    var similarArtistName = [String]()
}

struct Section {
    let sectionHeader: String
    let rowCount: Int
}
