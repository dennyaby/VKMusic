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
        static let ProgressOfSongDownloading = "ProgressOfSongDownloadingNotification"
        static let SongDownloadCompleted = "SongDownloadCompletedNotification"
        static let UserInfoSongUrl = "song_url"
        static let UserInfoSongDownloadProgress = "song_progress"
        static let SongDownloadSuccessfully = "SongDownloadSuccessfullyNotification"
        static let UserInfoDownloadedSongData = "song_data"
        static let UserInfoDownloadedSongInfo = "song_info"
    }
    
    struct Configuration {
        static let SecondsToPlayPrevious: Float = 5.0
    }
    
    struct FileSystem {
        static let TemporaryFolder: NSURL = {
            let fm = NSFileManager.defaultManager()
            let documentsDir = fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let tmpFolder = documentsDir.URLByAppendingPathComponent("Temp")
            
            return tmpFolder
        }()
        
        static let DownloadsFolder: NSURL = {
            let fm = NSFileManager.defaultManager()
            let documentsDir = fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let storageFolder = documentsDir.URLByAppendingPathComponent("Storage")
            
            return storageFolder
        }()
    }
}