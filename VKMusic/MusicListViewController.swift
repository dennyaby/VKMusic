//
//  MusicListViewController.swift
//  VKMusic
//
//  Created by  Dennya on 05.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON

let UploadNewSongsOffset = 7

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMusicView: UIView!
    
    var overallSongsCount: Int?
    
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Music"
        
        if self.revealViewController() != nil {
            self.navigationItem.leftBarButtonItem?.target = self.revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadMoreSongs()
    }
    
}

// MARK: UITableViewDataSource
extension MusicListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songs.count == 0 {
            noMusicView.hidden = false
        } else {
            noMusicView.hidden = true
        }
        return songs.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Storyboard.SongCell, forIndexPath: indexPath) as! SongCell
        let song = songs[indexPath.row]
        cell.artist = song.artist
        cell.title = song.title
        cell.duration = stringTimeFromNumberOfSeconds(song.duration)
        if let path = getLowestCellsIndexPath() {
            if let overallSongsCount = overallSongsCount {
                if (songs.count - path.row < UploadNewSongsOffset) && songs.count + 20 <= overallSongsCount {
                    print("Downloaded")
                    loadMoreSongs()
                }
            }
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension MusicListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}

// MARK: Navigation
extension MusicListViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Storyboard.PlaySongSegue {
            if let playerVC = segue.destinationViewController as? PlayerViewController {
                if let cell = sender as? UITableViewCell, indexPath = self.tableView.indexPathForCell(cell) {
                    let song = songs[indexPath.row]
                    playerVC.url = song.url
                }
            }
        }
    }
}


// MARK: Utilites
extension MusicListViewController {
    func stringTimeFromNumberOfSeconds(allSeconds: Int) -> String {
        let seconds = allSeconds % 60
        let minutes = allSeconds / 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
        
    }
    
    func loadMoreSongs() {
        if let urlRequest = VKApi.sharedInstance.getRequestWithMethod("audio.get", parameters: ["offset": songs.count, "count": 20]) {
            Alamofire.request(.GET, urlRequest).responseJSON {[weak weakSelf = self] response in
                if response.result.isSuccess {
                    if let result = response.result.value {
                        let result = JSONParser.parseMusicList(result)
                        weakSelf?.overallSongsCount = result.count
                        weakSelf?.songs.appendContentsOf(result.items)
                        weakSelf?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getLowestCellsIndexPath() -> NSIndexPath? {
        let maxSection = tableView.indexPathsForVisibleRows?.reduce(0) { max($0, $1.section) }
        let maxRow = tableView.indexPathsForVisibleRows?.filter { $0.section == maxSection }
            .reduce(0) { max($0, $1.row) }
        if let maxRow = maxRow, maxSection = maxSection {
            return NSIndexPath(forRow: maxRow, inSection: maxSection)
        } else {
            return nil
        }
        
    }
}

struct Song {
    let artist: String
    let title: String
    let duration: Int
    let url: String
}
