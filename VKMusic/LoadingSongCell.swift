//
//  LoadingSongCell.swift
//  VKMusic
//
//  Created by  Dennya on 10.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import UIKit
import RxSwift

class LoadingSongCell: UITableViewCell {
    var progress: Double? {
        didSet {
            
        }
    }
    
    var title: String? { didSet { }}
    var artist: String? { didSet { }}
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downloadProgress: UIProgressView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playPauseButton.rx_tap.subscribeNext { }.addDisposableTo(disposeBag)
    }
    
    
    
}
