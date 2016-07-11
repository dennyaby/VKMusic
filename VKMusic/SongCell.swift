//
//  SongCell.swift
//  VKMusic
//
//  Created by  Dennya on 06.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songDuration: UILabel!
    @IBOutlet weak var downloadView: DownloadView!
    
    var song: Song? {
        didSet {
            if let song = song {
                songTitle.text = song.title
                songArtist.text = song.artist
                songDuration.text = Utils.stringTimeFromNumberOfSeconds(song.duration)
            }
        }
    }

}
