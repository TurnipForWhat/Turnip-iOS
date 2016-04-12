//
//  MainViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 2/26/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: customUISWitch!
    @IBOutlet weak var friendTableView: UITableView!
    
    
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var friends = [FriendWrapper]()

    @IBAction func switchPressed(sender: AnyObject) {
        
        if mySwitch.on {
            myLabel.text = String(UnicodeScalar(0x1F525))
        } else {
            myLabel.text = "Off"
        }
        
        toggleStatus(mySwitch.on)
    }

    
    // Handles toggling status
    
    func toggleStatus(status: Bool) {
        
        let headers = [
            "x-Access-Token": "0.lpd18oxvmurw9udi"
        ]
        
        let parameters = [
            "status" : status
        ]
        
        Alamofire.request(.POST, "http://databaseproject.jaxbot.me/toggle", headers: headers, parameters: parameters, encoding: .JSON)
    
    }

    @IBAction func logoutPressed(sender: UIButton) {
        // Logout from FB
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()

        //Clear utoken
        prefs.setValue("", forKey: "utoken" as String)

        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func viewDidLoad() {
        getFriends()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.friendTableViewController  = [[FriendTableViewController alloc] init]
        
        friendTableView.dataSource = self
    }
    
    
    // Logic for gathering friend's list
    
    func getFriends(){
        
        let headers = [
            "x-Access-Token": "0.lpd18oxvmurw9udi"
        ]
        var friendsArray: NSArray = []
        
        Alamofire.request(.GET, "http://databaseproject.jaxbot.me/feed", headers: headers)
            .validate()
            .responseJSON{ response in
                friendsArray = response.result.value!["friends"] as! NSArray
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.populateFriends(friendsArray);
                    self.friendTableView!.reloadData()
                })
        }
    }
    
    func populateFriends(friendsArray: NSArray){
        
        for index in friendsArray {
            let status = index["status"] as! Bool
            let name = index["name"] as! String
            let dict: [String: AnyObject] = [FriendFields.name.rawValue: name, FriendFields.status.rawValue: status]
            let json = JSON(dict)
            let friend = FriendWrapper(json: json)
            
            self.friends += [friend]
        }
    }
    
    
    // Logic for handling Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Reusable Cell Identifier
        let cellIdentifier = "FriendTableViewCell1"
        
        // Get a reference to current cell
        let cell:FriendTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FriendTableViewCell
        

        cell.FriendNameLabel?.text = friends[indexPath.row].name
        
        // Properly handle statLabel and coloring
        if(friends[indexPath.row].status!){
            cell.FriendStatusLabel.textColor = UIColor.greenColor()
            cell.FriendStatusLabel?.text = "Ready to Hang"
        } else {
            cell.FriendStatusLabel.textColor = UIColor.redColor()
            cell.FriendStatusLabel?.text = "Busy"
        }
        
        // Configure imageviews
        // cell.imageView?.image = friendTableViewCell
        
        // Configure the cell...
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class customUISWitch: UISwitch {
    override func awakeFromNib() {
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }
}

