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
        cell.duration = Utils.stringTimeFromNumberOfSeconds(song.duration)
        if song.url == AudioPlayer.sharedInstance.currentUrl {
            cell.backgroundColor = UIColor(white: 0.1, alpha: 1)
        }
        if let path = getLowestCellsIndexPath() {
            if let overallSongsCount = overallSongsCount {
                if (songs.count - path.row < UploadNewSongsOffset) && songs.count + 1 <= overallSongsCount {
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
                    playerVC.song = song
                    if let count = overallSongsCount {
                        Playlist.sharedInstance.type = PlaylistType.UserAudio(count: count, offset: indexPath.row)
                    } else {
                        Playlist.sharedInstance.type = .None
                    }
                }
            }
        }
    }
}


// MARK: Utilites
extension MusicListViewController {
    func loadMoreSongs() {
        if let urlRequest = VKApi.sharedInstance.getRequestWithMethod("audio.get", parameters: ["offset": songs.count, "count": 20]) {
            Alamofire.request(.GET, urlRequest).responseJSON {[weak weakSelf = self] response in
                if response.result.isSuccess {
                    if let result = response.result.value {
                        let result = JSONParser.parseMusicList(result)
                        let oldSongsCount = weakSelf?.songs.count
                        weakSelf?.overallSongsCount = result.count
                        weakSelf?.songs.appendContentsOf(result.items)
                        var indexPaths = [NSIndexPath]()
                        for (n, _) in result.items.enumerate() {
                            indexPaths.append(NSIndexPath(forRow: oldSongsCount! + n, inSection: 0))
                        }
                        weakSelf?.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
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
