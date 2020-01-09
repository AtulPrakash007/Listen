//
//  AppLocators.swift
//  Listen
//
//  Created by Atul Prakash on 28/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import Foundation

struct AppLocators {
    static let baseUrl = "http://ws.audioscrobbler.com/2.0/"
    static let post = "POST"
    
    static let track = "track"
    static let artists = "artist"
    static let album = "album"
    static let info = "info"
    static let search = "search"
    
    static let detailSegue = "detailSegue"
    
    struct APIParam {
        static let method = "method"
        static let apiKey = "api_key"
        static let format = "format"
        static let json = "json"
        static let getInfo = "getInfo"
    }
    
    struct APIResponse {
        static let results = "results"
        static let matches = "matches"
        static let name = "name"
        static let url = "url"
        static let image = "image"
        static let imageUrl = "#text"
        static let listeners = "listeners"
        static let playcount = "playcount"
        static let tags = "tags"
        static let summary = "summary"
        //    "opensearch:itemsPerPage" = 50;
        //    "opensearch:startIndex" = 0;
        //    "opensearch:totalResults" = 38487854;
        static let itemsPerPage = "opensearch:itemsPerPage"
        static let totalResults = "opensearch:totalResults"
    }
    
    struct TrackKey {
        static let name = "track.name"
        static let artist = "track.album.artist"
        static let listeners = "track.listeners"
        static let playcount = "track.playcount"
        static let summary = "track.wiki.summary"
        static let image = "track.album.image.#text"
        static let tags = "track.toptags.tag.name"
        static let duration = "track.duration"
        static let url = "track.url"
    }
    
    struct AlbumKey {
        static let name = "album.name"
        static let artist = "album.artist"
        static let listeners = "album.listeners"
        static let playcount = "album.playcount"
        static let summary = "album.wiki.summary"
        static let image = "album.image.#text"
        static let tags = "album.tags.tag.name"
        static let url = "album.url"
        //album tracks
        static let tracksName = "album.tracks.track.name"
        static let tracksUrl = "album.tracks.track.url"
        static let tracksDuration = "album.tracks.track.duration"
    }
    
    struct ArtistKey {
        static let name = "artist.name"
        static let artist = "artist.name"
        static let listeners = "artist.stats.listeners"
        static let playcount = "artist.stats.playcount"
        static let summary = "artist.bio.summary"
        static let image = "artist.image.#text"
        static let tags = "artist.tags.tag.name"
        static let url = "artist.url"
        //similar artists
        static let smilarArtistImage = "artist.similar.artist.image.#text"
        static let similarArtistName = "artist.similar.artist.name"
    }
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    //operators
    static let colon = ":"
    static let comma = ","
}
