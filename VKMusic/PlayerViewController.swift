//
//  PlayerViewController.swift
//  VKMusic
//
//  Created by  Dennya on 05.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import RxSwift
import MediaPlayer

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!

    @IBOutlet weak var volumeSlider: MPVolumeView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var rewindForward: UIButton!
    @IBOutlet weak var rewindBack: UIButton!
    
    var song: Song? {
        didSet {
            if song != nil {
                updateLabels()
                updateView()
                titleLabel?.text = song?.title
                artistLabel?.text = song?.artist
                durationSet = false
            }
        }
    }
    
    var durationSet = false
    
    @IBOutlet weak var goneTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    let rewindBTimer = NSTimer()
    let rewindFTimer = NSTimer()
    var updateProgressSliderTimer = NSTimer()
    var updateLabelsTimer = NSTimer()
    
    var isCurrentSongPlaying: Bool {
        if let stringUrl = song?.url, songUrl = NSURL(string: stringUrl), audioPlayerUrl = AudioPlayer.sharedInstance.currentUrl where songUrl == audioPlayerUrl {
            return true
        } else {
            return false
        }
    }
    
    var currentTime: Float {
        return Float(AudioPlayer.sharedInstance.player.currentTime().seconds)
    }
    
    var duration: Float? {
        let seconds = AudioPlayer.sharedInstance.avAsset?.duration.seconds
        if let seconds = seconds{
            return Float(seconds)
        } else {
            return nil
        }
    }
    
    var touchingSlider = false
    var touchingVolumeSlider = false
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeSlider.showsRouteButton = true
        volumeSlider.showsVolumeSlider = true
        
        progressSlider.rx_value.subscribeNext {value in
            if self.isCurrentSongPlaying {
                AudioPlayer.sharedInstance.player.seekToTime(CMTime(seconds: Double(value), preferredTimescale: CMTimeScale(1)))
                self.touchingSlider = false
                self.updateLabels()
                self.updateView()
            }
            }.addDisposableTo(disposeBag)
        
        progressSlider.rx_controlEvent(.TouchDown).subscribeNext { self.touchingSlider = true }.addDisposableTo(disposeBag)
        
        progressSlider.value = 0.0
        progressSlider.minimumValue = 0.0
        progressSlider.continuous = false
        
        playPauseButton.rx_tap.subscribeNext { if let song = self.song, url = NSURL(string: song.url) {
            AudioPlayer.sharedInstance.pauseOrPlaySongWithUrl(url)
            }
            }.addDisposableTo(disposeBag)
        
                
        if let song = song {
            titleLabel.text = song.title
            artistLabel.text = song.artist
            if song.url == AudioPlayer.sharedInstance.currentUrl {
                progressSlider.value = currentTime
            }
            goneTimeLabel.text = Utils.stringTimeFromNumberOfSeconds(0)
            leftTimeLabel.text = Utils.stringTimeFromNumberOfSeconds(song.duration)
        }
        
        rewindForward.rx_tap.subscribeNext { Playlist.sharedInstance.playNextSong() }.addDisposableTo(disposeBag)
        
        rewindBack.rx_tap.subscribeNext {
            if self.currentTime > Constants.Configuration.SecondsToPlayPrevious {
                Playlist.sharedInstance.restartSong()
            } else {
                Playlist.sharedInstance.playPreviousSong()
            }
            }.addDisposableTo(disposeBag)
        
        startUpdateLabels()
        startUpdateView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.songLoaded(_:)), name: Constants.Notifications.SongLoaded, object: nil)
        
    }
    
    func startUpdateView() {
        if updateProgressSliderTimer.valid {
            updateProgressSliderTimer.invalidate()
        }
        updateProgressSliderTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(PlayerViewController.updateView), userInfo: nil, repeats: true)
    }
    
    func stopUpdateView() {
        
    }
    
    func updateView() {
        if isCurrentSongPlaying && !touchingSlider{
            if !touchingSlider {
                progressSlider.value = currentTime
            }
            if !touchingVolumeSlider {

            }
        }
        if !durationSet && isCurrentSongPlaying {
            if let duration = duration where duration != Float.NaN {
                if let progressSlider = progressSlider {
                    progressSlider.maximumValue = Float(duration)
                    durationSet = true
                }
                
            }
        }
    }
    
    func startUpdateLabels() {
        if updateLabelsTimer.valid {
            updateLabelsTimer.invalidate()
        }
        updateLabelsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(PlayerViewController.updateLabels), userInfo: nil, repeats: true)
    }
    
    func updateLabels() {
        if isCurrentSongPlaying && !touchingSlider {
            if let duration = duration {
                let goneSeconds = currentTime
                let leftSeconds = duration - currentTime
                leftTimeLabel?.text = Utils.stringTimeFromNumberOfSeconds(leftSeconds)
                goneTimeLabel?.text = Utils.stringTimeFromNumberOfSeconds(goneSeconds)
            }
        }
    }

    
    @objc func songLoaded(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            for (key, value) in userInfo {
                if let key = key as? String where key == Constants.Notifications.UserInfoSongField {
                    if let wrapper = value as? Wrapper<Song>{
                        let song = wrapper.wrappedValue
                        self.song = song
                    }
                }
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
