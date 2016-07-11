//
//  UtilityFunctions.swift
//  VKMusic
//
//  Created by  Dennya on 08.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class Utils {
    static func stringTimeFromNumberOfSeconds(allSeconds: Int) -> String {
        let seconds = allSeconds % 60
        let minutes = allSeconds / 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    static func stringTimeFromNumberOfSeconds(seconds: Float) -> String {
        if seconds != Float.NaN {
            return Utils.stringTimeFromNumberOfSeconds(Int(round(seconds)))
        } else {
            return ""
        }
    }
}
