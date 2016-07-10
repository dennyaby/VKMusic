//
//  Constants.swift
//  VKMusic
//
//  Created by  Dennya on 06.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation

struct Constants {
    struct SocialNetwork {
        static let AppId = "5537328"
        static let DefaultRedirectUri = "https://oauth.vk.com/blank.html"
    }
    
    struct Storyboard {
        static let SongCell = "SongCell"
        static let MusicAppSegue = "MusicAppSegue"
        static let LogoutSegue = "LogoutSegue"
        static let PlaySongSegue = "PlaySong"
    }
    
    struct Notifications {
        static let SongLoaded = "SongLoadedNotification"
        static let UserInfoSongField = "song"
        static let RestartSong = "RestartSong"
    }
    
    struct Configuration {
        static let SecondsToPlayPrevious: Float = 5.0
    }
}