//
//  JSONParser.swift
//  VKMusic
//
//  Created by  Dennya on 08.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser {
    static func parseMusicList(json: AnyObject) -> (items: [Song], count: Int) {
        var result: (items: [Song], count: Int)
        result.count = 0
        result.items = [Song]()
        
        if let count = JSON(json)["response"]["count"].int {
            result.count = count
        }
        
        if let arrayOfSongs = JSON(json)["response"]["items"].array {
            for song in arrayOfSongs {
                print("Song: \(song)")
                if let artist = song["artist"].string, title = song["title"].string, duration = song["duration"].int, url = song["url"].string {
                    result.items.append(Song(artist: artist, title: title, duration: duration, url: url))
                }
            }
        }
        return result
    }
}