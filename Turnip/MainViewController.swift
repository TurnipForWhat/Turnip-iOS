//
//  MainViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 2/26/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: customUISWitch!
    

    @IBAction func switchPressed(sender: AnyObject) {
        
        if mySwitch.on {
            myLabel.text = "On"
        } else {
            myLabel.text = "Off"
        }
        
        retrieveStatus(mySwitch.on)
    }

    
    func retrieveStatus(status: Bool) {
        
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

        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

