//
//  File.swift
//  VKMusic
//
//  Created by  Dennya on 08.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import Alamofire

let VK_API_VERSION = "5.52"

class VKApi {
    static let sharedInstance = VKApi()
    
    var access_token: String?
    var userId: String?
    var online = false
    
    struct Requests {
        static var Authorize: String {
            return "http://oauth.vk.com/authorize?client_id=\(Constants.SocialNetwork.AppId)&scope=audio&redirect_uri=oauth.vk.com/blank.html&display=touch&response_type=token"
        }
        
        static var Logout: String {
            return "http://oauth.vk.com/logout?client_id=\(Constants.SocialNetwork.AppId)&scope=audio&redirect_uri=oauth.vk.com/blank.html&display=touch&response_type=token"
        }
        
        static let VKApi = "https://api.vk.com/method/"
    }
    
    func getRequestWithMethod(methodName: String, parameters: [String: AnyObject]) -> String? {
        if let access_token = access_token {
            var request = "\(Requests.VKApi)\(methodName)?"
            for (name, value) in parameters {
                request += "\(name)=\(value)&"
            }
            request += "access_token=\(access_token)&v=\(VK_API_VERSION)"
            print("Request: \(request)")
            return request
        } else {
            return nil
        }
    }
    
}
