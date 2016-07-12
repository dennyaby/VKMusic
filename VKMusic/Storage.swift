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
    
    var tmpSongsData = [Song]()
    var storageSongsData = [Song]()
    
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
    
    func songContaing(song: Song) -> Bool {
        return containsInTmp(song) || containsInStorage(song)
    }
    
    func containsInTmp(song: Song) -> Bool {
        for tmpSong in tmpSongsData {
            if song.url == tmpSong.url {
                return true
            }
        }
        return false
    }
    
    func containsInStorage(song: Song) -> Bool {
        for storageSong in storageSongsData {
            if storageSong.url == song.url {
                return true
            }
        }
        return false
    }
    
    private func getFileNames() -> [String] {
        var fileNames = [String]()
        do {
            var files = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(Constants.FileSystem.DownloadsFolder, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants)
            for file in files {
                if let lastPathComponent = file.lastPathComponent {
                    fileNames.append(lastPathComponent)
                }
            }
            files = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(Constants.FileSystem.TemporaryFolder, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants)
            for file in files {
                if let lastPathComponent = file.lastPathComponent {
                    fileNames.append(lastPathComponent)
                }
            }
        } catch {
            print("getFileNames() Error")
        }
        return fileNames
    }
    
    private func generateUniqueFileNameFromResponse(response: NSHTTPURLResponse) -> String {
        if let suggestedName = response.suggestedFilename {
            if getFileNames().contains(suggestedName) {
                var name = suggestedName
                while getFileNames().contains(name) {
                    if let randomNumber = String(name.hashValue).characters.last {
                        name.append(randomNumber)
                    } else {
                        name.appendContentsOf("1")
                    }
                }
                return name
            } else {
                return suggestedName
            }
        } else {
            var name = "song"
            while getFileNames().contains(name) {
                if let randomNumber = String(name.hashValue).characters.last {
                    name.append(randomNumber)
                } else {
                    name.appendContentsOf("1")
                }
            }
            return name
        }
    }
    
    func getDestinationToTempFolderFromResponse(response: NSHTTPURLResponse) -> NSURL {
        let uniqueName = generateUniqueFileNameFromResponse(response)
        return Constants.FileSystem.TemporaryFolder.URLByAppendingPathComponent(uniqueName)
    }
    
    func createSongWithSongInfo(info: Song, downloaded: Bool, filePath: NSURL) {
        
    }
    
    func getSongEntityWithUrl(url: String) -> SongEntity? {
        return nil
    }

    
    func moveSongEntity(songEntity: SongEntity, fromUrl: NSURL, toUrl: NSURL) {
        if let fileName = fromUrl.lastPathComponent {
            let destinationUrl = toUrl.URLByAppendingPathComponent(fileName)
            do {
                try NSFileManager.defaultManager().moveItemAtURL(fromUrl, toURL: destinationUrl)
                songEntity.filePath = destinationUrl
                print("File moved")
            } catch {
                print("Storage.moveFileFromUrl")
            }
        }
    
    }
    
    func commitChangeForSongEntity(song: SongEntity) {
        
    }
    
    
}