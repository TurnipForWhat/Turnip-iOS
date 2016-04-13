//
//  MainViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 2/26/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: customUISWitch!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var refreshControl: UIRefreshControl!
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
            "x-Access-Token": prefs.stringForKey("utoken")!
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

        // Set Status to False
        toggleStatus(false)
        
        //Clear utoken
        prefs.setValue("", forKey: "utoken" as String)

        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    @IBAction func settingsPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toSettings", sender: self)
    }
    
    
    override func viewDidLoad() {
        getFriends()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        friendTableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.friendTableView.addSubview(self.refreshControl) // not required when using UITableViewController
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Update status
        toggleStatus(mySwitch.on)
    }
    
    func refresh(sender:AnyObject){
        getFriends()
        friendTableView.dataSource = self
        
        self.refreshControl.endRefreshing()
    }
    
    // Logic for gathering friend's list
    
    func getFriends(){
        
        friends = []
        
        let headers = [
            "x-Access-Token": prefs.stringForKey("utoken")!
        ]
        var friendsArray: NSArray = []
        
        Alamofire.request(.GET, "http://databaseproject.jaxbot.me/feed", headers: headers)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .Success:
                    friendsArray = response.result.value!["friends"] as! NSArray
                    dispatch_async(dispatch_get_main_queue (), {
                        self.populateFriends(friendsArray);
                        self.friendTableView!.reloadData()
                    })
                case .Failure:
                    self.performSegueWithIdentifier("logout", sender: self)
                }
        }
    }
    
    func populateFriends(friendsArray: NSArray){
        
        
        for index in friendsArray {
            let status = index["status"] as! Bool
            let name = index["name"] as! String
            var image_id = index["profile_picture_id"] as! String
            
            
            
            let dict: [String: AnyObject] = [FriendFields.name.rawValue: name, FriendFields.status.rawValue: status]
            let json = JSON(dict)
            
            let friend = FriendWrapper(json: json)
            
            
            if( image_id == ""){
                image_id = "none"
            }
                Alamofire.request(.GET, "http://databaseproject.jaxbot.me/" + image_id + ".jpg")
                .responseImage { response in
      
                    
                    dispatch_async(dispatch_get_main_queue (), {
                        if let image = response.result.value {
                            friend.image = image
                            print("Image: \(image)")
                            self.friendTableView!.reloadData()
                        }
                    })
                }
            
            
            
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
        cell.FriendIcon.image = (friends[indexPath.row].image != nil) ? friends[indexPath.row].image! as UIImage : nil
        
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell number: \(indexPath.row)!")
//        self.performSegueWithIdentifier("yourIdentifier", sender: self)
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

