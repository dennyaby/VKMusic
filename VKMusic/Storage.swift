//
//  Storage.swift
//  VKMusic
//
//  Created by  Dennya on 10.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation

class Storage {
    static let sharedInstance = Storage()
    
    func clearTemporaryDirectory() {
        let fm = NSFileManager.defaultManager()
        do {
            let folderUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let paths = try fm.contentsOfDirectoryAtURL(folderUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            for path in paths
            {
                try fm.removeItemAtPath("\(folderUrl)/\(path)")
                print("delete item at path \(path)")
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveSongToStorage(song: SongEntity) {
        
    }
    
    
}