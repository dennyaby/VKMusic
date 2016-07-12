//
//  DownloadHub.swift
//  VKMusic
//
//  Created by  Dennya on 10.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import Alamofire

class DownloadHub {
    static let sharedInstance = DownloadHub()
    
    var downloadItems = [Song: Request]()
    
    init() {
        
    }
    
    func startDownloadSong(song: Song) {
        if let url = NSURL(string: song.url) where !Storage.sharedInstance.songContaing(song) {
            let request = Alamofire.download(.GET, url) { (temporaryURL: NSURL, response: NSHTTPURLResponse) -> NSURL in
                let destination = Storage.sharedInstance.getDestinationToTempFolderFromResponse(response)
                Storage.sharedInstance.createSongWithSongInfo(song, downloaded: false, filePath: destination)
                return destination
                }
                .progress { _, read, all in
                    let userInfo: [String: AnyObject] = [
                        Constants.Notifications.UserInfoDownloadedSongInfo: Wrapper(theValue: song),
                        Constants.Notifications.UserInfoSongDownloadProgress: Double(read) / Double(all)
                    ]
                    print("Progress \(Double(read) / Double(all))")
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.ProgressOfSongDownloading, object: nil, userInfo: userInfo as [NSObject : AnyObject])
                }.response {[weak weakSelf = self] request, response, data, error in
                    print("Downloaded")
                    
                    if let requestUrl = request?.URL?.absoluteString, songEntity = Storage.sharedInstance.getSongEntityWithUrl(requestUrl) {
                        print("Request valid, we get songEntity")
                        Storage.sharedInstance.moveSongEntity(songEntity, fromUrl: songEntity.filePath!, toUrl: Constants.FileSystem.DownloadsFolder)
                        songEntity.downloaded = true
                        Storage.sharedInstance.commitChangeForSongEntity(songEntity)
                        
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.SongDownloadSuccessfully, object: nil)
                    weakSelf?.downloadItems.removeValueForKey(song)
                    weakSelf?.syncWithStorage()
                    
            }
            
            downloadItems[song] = request
        }
    }
    
    func syncWithStorage() {
        
    }
    
    func pauseLoadingSong(song: Song) {
        if let request = downloadItems[song] {
            request.progress.pause()
        }
    }
    
    func resumeLoadingSong(song: Song) {
        if let request = downloadItems[song] {
            request.progress.resume()
        }
    }
}