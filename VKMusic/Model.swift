//
//  Model.swift
//  VKMusic
//
//  Created by  Dennya on 10.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation

struct Song: Hashable, Equatable {
    let artist: String
    let title: String
    let duration: Int
    let url: String
    
    var hashValue: Int {
        return url.hashValue
    }
}

class SongEntity {
    var songInfo: Song?
    var songData: NSData?
    
    init(songInfo: Song, songData: NSData) {
        self.songInfo = songInfo
        self.songData = songData
    }
}


func ==(lhs: Song, rhs: Song) -> Bool {
    return lhs.url == rhs.url
}

