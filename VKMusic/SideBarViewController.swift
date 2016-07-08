//
//  SideBarViewController.swift
//  VKMusic
//
//  Created by  Dennya on 05.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SideBarViewController: UITableViewController {
    
    
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var nameCellLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameCellLabel.text = "Dennya"
        if let urlRequest = VKApi.sharedInstance.getRequestWithMethod("users.get", parameters: [:]) {
            Alamofire.request(.GET, urlRequest).responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let firstName = json["response"][0]["first_name"].string {
                            self.nameCellLabel.text = firstName
                        }
                    }
                } else {
                    print("Error: \(response.result.error)")
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            logout()
        }
    }
    
    func logout() {
        print("logout")
        performSegueWithIdentifier(Constants.Storyboard.LogoutSegue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Storyboard.LogoutSegue {
            if let loginVC = segue.destinationViewController as? LoginViewController {
                loginVC.shouldLogout = true
            }
        }
    }

    

   
}
