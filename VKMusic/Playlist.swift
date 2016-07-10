//
//  Playlist.swift
//  VKMusic
//
//  Created by  Dennya on 09.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import Alamofire

class Playlist: NSObject {
    
    static let sharedInstance = Playlist()
    
    var type = PlaylistType.None
    
    var currentSong: Song?
    
    @objc func playNextSong() {
        playSong(true)
    }
    
    @objc func playPreviousSong(){
        playSong(false)
    }
    
    func restartSong() {
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.RestartSong, object: nil)
    }
    
    private func playSong(next: Bool) {
        switch type {
        case .UserAudio(let count, let offset):
            if offset != count {
                if (next && offset == count) || (!next && count > 0 && offset == 0) {
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.RestartSong, object: nil)
                    return
                }
                let offsetChange = next ? 1 : -1
                if let urlRequest = VKApi.sharedInstance.getRequestWithMethod("audio.get", parameters: ["offset": offset + offsetChange, "count": 1]) {
                    Alamofire.request(.GET, urlRequest).responseJSON {[weak weakSelf = self] response in
                        if response.result.isSuccess {
                            if let result = response.result.value {
                                let result = JSONParser.parseMusicList(result)
                                if result.items.count == 1 {
                                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.SongLoaded, object: nil, userInfo: [Constants.Notifications.UserInfoSongField: Wrapper<Song>(theValue: result.items[0])])
                                    print("Posted Notification")
                                    if let strongSelf = weakSelf {
                                        strongSelf.currentSong = result.items[0]
                                        if case let PlaylistType.UserAudio(count: count, offset: offset) = strongSelf.type {
                                            strongSelf.type = PlaylistType.UserAudio(count: count, offset: offset + offsetChange)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        case .None:
            break
        }
    }
    
}

enum PlaylistType {
    case UserAudio(count: Int, offset: Int)
    case None
}

class Wrapper<T> {
    var wrappedValue: T
    init(theValue: T) {
        wrappedValue = theValue
    }
}