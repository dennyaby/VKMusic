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

class PlayerViewController: UIViewController {
    
    var url: String?
    var avAsset: AVURLAsset?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            if let urlAdress = NSURL(string: url) {
                self.avAsset = AVURLAsset(URL: urlAdress)
                self.playerItem = AVPlayerItem(asset: self.avAsset!)
                self.player = AVPlayer(playerItem: self.playerItem!)
                self.player?.play()
            }
        }

        
    }



}
