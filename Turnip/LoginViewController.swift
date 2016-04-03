//
//  LoginViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/3/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        let loginButton : FBSDKLoginButton = FBSDKLoginButton()
        loginButton.frame=CGRectMake(0,0,250,60);
        self.view.addSubview(loginButton)
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            self.returnUserData()
        }

    }

    // Facebook Delegate Methods

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")

        if ((error) != nil)
        {
            // Process error
            print("There was an error:", error.code, error.debugDescription)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("User cancelled login!")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }

            self.returnUserData()
        }

    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
