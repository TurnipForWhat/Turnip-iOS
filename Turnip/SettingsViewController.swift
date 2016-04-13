//
//  SettingsViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/11/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var changeName: UIButton!
    
    @IBAction func changeNamePressed(sender: AnyObject) {
        
        let nameAlertController = UIAlertController(title: "Change Name", message: "Update you name below", preferredStyle:UIAlertControllerStyle.Alert)
        
        nameAlertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
            textField.placeholder = "Enter Name"
        })
        
        nameAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Put your code here
            })
        
        nameAlertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default)
        { action -> Void in
            let textField = nameAlertController.textFields![0] as UITextField
            let nameString = textField.text
            self.updateName(nameString!)
            })
        self.presentViewController(nameAlertController, animated: true, completion: nil)
    }
    
    func updateName(name: String) {
        
        let headers = [
            "x-Access-Token": prefs.stringForKey("utoken")!
        ]
        
        let parameters = [
            "name" : name
        ]
        
        Alamofire.request(.PUT, "http://databaseproject.jaxbot.me/profile", headers: headers, parameters: parameters, encoding: .JSON)
        
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("fromSettings", sender: self)
    }
    
}
