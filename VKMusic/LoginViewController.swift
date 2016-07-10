//
//  LoginViewController.swift
//  VKMusic
//
//  Created by  Dennya on 06.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSocialConnect
import Alamofire

class LoginViewController: UIViewController{
    
    var shouldLogout = false
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var offlineButton: UIButton!

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.delegate = self
        
        doneButton.rx_tap.subscribeNext {
            self.closeWebView()
        }.addDisposableTo(disposeBag)
        
        if shouldLogout {
            for cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }

        }
        
        let request = VKApi.Requests.Authorize
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: request)!))
        
        loginButton.rx_tap.subscribeNext {
            let request = VKApi.Requests.Authorize

            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: request)!))
            self.webView.hidden = false
            self.navBar.hidden = false
        }.addDisposableTo(disposeBag)
    }
    
    func closeWebView() {
        webView.hidden = true
        navBar.hidden = true
    }
}


extension LoginViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        if let currentUrl = webView.request?.URL?.absoluteString {
            if currentUrl.lowercaseString.rangeOfString("access_token") != nil {
                var data = currentUrl.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "=&"))
                VKApi.sharedInstance.access_token = data[1]
                VKApi.sharedInstance.userId = data[5]
                self.closeWebView()
                performSegueWithIdentifier(Constants.Storyboard.MusicAppSegue, sender: nil)
            } else {
                print("Can't get access_token")
            }
        }
    }
    
//    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
//        print("Error occured")
//    }
}

