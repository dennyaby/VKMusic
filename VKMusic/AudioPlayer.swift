//
//  AudioPlayer.swift
//  VKMusic
//
//  Created by  Dennya on 08.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import MediaPlayer

class AudioPlayer: NSObject {
    static let sharedInstance = AudioPlayer()
    let audioSession = AVAudioSession.sharedInstance()
    var player = AVPlayer()
    var avAsset: AVURLAsset?
    var playerItem: AVPlayerItem?
    
    var currentUrl: NSURL?
    
    override init() {
        super.init()
        do {
           try audioSession.setCategory(AVAudioSessionCategoryPlayback)
           try audioSession.setActive(true)
        } catch {
            print("Can't set audio session category, error: \(error)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.serverRestarts(_:)), name: AVAudioSessionMediaServicesWereResetNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.songLoaded(_:)), name: Constants.Notifications.SongLoaded, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.restartSong), name: Constants.Notifications.RestartSong, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.songFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        commandCenter.playCommand.addTarget(self, action: #selector(AudioPlayer.playPauseSong))
        commandCenter.pauseCommand.addTarget(self, action: #selector(AudioPlayer.playPauseSong))
        commandCenter.nextTrackCommand.addTarget(Playlist.sharedInstance, action: #selector(Playlist.playNextSong))
        commandCenter.previousTrackCommand.addTarget(Playlist.sharedInstance, action: #selector(Playlist.playPreviousSong))
    }
    
    @objc func songFinishPlaying() {
        Playlist.sharedInstance.playNextSong()
    }
    
    @objc func songLoaded(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            for (key, value) in userInfo {
                if let key = key as? String where key == Constants.Notifications.UserInfoSongField {
                    if let wrapper = value as? Wrapper<Song>{
                        let song = wrapper.wrappedValue
                        if let url = NSURL(string: song.url) {
                            playSongFromUrl(url)
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func restartSong() {
        if currentUrl != nil {
            self.player.seekToTime(CMTime(seconds: 0, preferredTimescale: CMTimeScale(1)))
        }
    }
    
    func playSongFromUrl(url: NSURL) {
        if url != currentUrl {
            self.currentUrl = url
            self.avAsset = AVURLAsset(URL: url)
            self.playerItem = AVPlayerItem(asset: self.avAsset!)
            self.player = AVPlayer(playerItem: self.playerItem!)
            self.player.play()
            
        }
    }
    
    @objc func playPauseSong() {
        if let currentUrl = currentUrl {
            self.pauseOrPlaySongWithUrl(currentUrl)
        }
    }
    
    func pauseOrPlaySongWithUrl(url: NSURL) {
        if let currentUrl = currentUrl {
            if currentUrl == url {
                if player.rate == 1.0 {
                    player.pause()
                } else {
                    player.play()
                }
            } else {
                playSongFromUrl(url)
            }
        } else {
            playSongFromUrl(url)
        }
    }
    
    @objc func serverRestarts(notification: NSNotification) {
        print("audio session media service were reset")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}