//
//  LoginViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/3/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passTextBox: UITextField!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var loginWithEmailButton: UIButton!
    var facebookLoginButton : FBSDKLoginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        // Setup facebook login button
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.center = self.view.center
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self

        // Hide the things we don't need for FB login
        emailTextBox.hidden = true
        passTextBox.hidden = true
        emailLoginButton.hidden = true

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            self.returnUserData()
            performFromLogin()
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
                performFromLogin()
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

    @IBAction func loginWithEmailPressed(sender: UIButton) {
        facebookLoginButton.hidden = !(facebookLoginButton.hidden)
        emailTextBox.hidden = !(emailTextBox.hidden)
        passTextBox.hidden = !(passTextBox.hidden)
        emailLoginButton.hidden = !(emailLoginButton.hidden)

        if (emailTextBox.hidden) {
            loginWithEmailButton.setTitle("Login with email", forState: UIControlState.Normal)
        }
        else {
            loginWithEmailButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performFromLogin() {
        //self.performSegueWithIdentifier("fromLogin", sender: nil)
    }
    
}
