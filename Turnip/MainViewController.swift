//
//  MainViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 2/26/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    

    @IBAction func switchPressed(sender: AnyObject) {
        
        if mySwitch.on {
            myLabel.text = "On"
        } else {
            myLabel.text = "Off"
        }
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

