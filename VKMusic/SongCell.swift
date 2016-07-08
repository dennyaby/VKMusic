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
    
    var title: String? { didSet { songTitle.text = title }}
    var artist: String? { didSet { songArtist.text = artist }}
    var duration: String? { didSet { songDuration.text = duration }}
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
