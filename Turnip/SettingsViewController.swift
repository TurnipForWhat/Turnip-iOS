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
        
        let nameAlertController = UIAlertController(title: "Change Name", message: "Update your name below", preferredStyle:UIAlertControllerStyle.Alert)
        
        nameAlertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
            textField.placeholder = "Enter Name"
        })
        
        nameAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Closes alert
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
    
    @IBOutlet weak var changeEmail: UIButton!
    
    @IBAction func changeEmailPressed(sender: AnyObject) {
        let emailAlertController = UIAlertController(title: "Change Email", message: "Update your email below", preferredStyle:UIAlertControllerStyle.Alert)
        
        emailAlertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Enter Email"
        })
        
        emailAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Closes alert
            })
        
        emailAlertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default)
        { action -> Void in
            let textField = emailAlertController.textFields![0] as UITextField
            let nameEmail = textField.text
            self.updateEmail(nameEmail!)
            })
        self.presentViewController(emailAlertController, animated: true, completion: nil)
    }
    
    func updateEmail(email: String) {
        
        let headers = [
            "x-Access-Token": prefs.stringForKey("utoken")!
        ]
        
        let parameters = [
            "email" : email
        ]
        
        Alamofire.request(.PUT, "http://databaseproject.jaxbot.me/profile", headers: headers, parameters: parameters, encoding: .JSON)
        
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("fromSettings", sender: self)
    }
    
}
