//
//  SettingsViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/11/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("fromSettings", sender: self)
    }
    
}
