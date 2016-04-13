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
            print(textField.text)
            })
        self.presentViewController(nameAlertController, animated: true, completion: nil)
    }
    
    func updateName(status: Bool) {
        
        let headers = [
            "x-Access-Token": "0.lpd18oxvmurw9udi"
        ]
        
        let parameters = [
            "name" : "hi"
        ]
        
        Alamofire.request(.POST, "http://databaseproject.jaxbot.me/toggle", headers: headers, parameters: parameters, encoding: .JSON)
        
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("fromSettings", sender: self)
    }
    
}
