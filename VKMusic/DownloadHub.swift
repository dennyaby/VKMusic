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
    
    func startDownloadSong(song: Song) {
        if let url = NSURL(string: song.url) where !downloadItems.keys.contains(song) {
            var destination: NSURL?
            
            let request = Alamofire.download(.GET, url) { (temporaryURL: NSURL, response: NSHTTPURLResponse) -> NSURL in
                let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                let pathComponent = response.suggestedFilename
                destination = directoryURL.URLByAppendingPathComponent(pathComponent!)
                return destination!
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
                    if let destination = destination {
                        let songData = NSData(contentsOfURL: destination)
                        guard songData != nil else { return }
                        print("Song downloaded Successfully")
                        let userInfo: [String: AnyObject] = [
                            Constants.Notifications.UserInfoDownloadedSongInfo: Wrapper(theValue: song),
                            Constants.Notifications.UserInfoDownloadedSongData: songData!
                        ]
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.SongDownloadSuccessfully, object: nil, userInfo: userInfo)
                        do {
                           try  NSFileManager.defaultManager().removeItemAtURL(destination)
                        } catch let error as NSError {
                            print("Error while deleting: \(error.localizedDescription)")
                        }
                        weakSelf?.downloadItems.removeValueForKey(song)
                    }
            }
            
            downloadItems[song] = request
        }
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