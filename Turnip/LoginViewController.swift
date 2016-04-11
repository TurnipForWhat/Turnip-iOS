//
//  LoginViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/3/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var registerCancel: UIButton!

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passTextBox: UITextField!
    @IBOutlet weak var confirmPasswordTextBox: UITextField!

    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var loginWithEmailButton: UIButton!
    @IBOutlet weak var registerNewUserButton: UIButton!

    var registerNewUser = false

    var facebookLoginButton : FBSDKLoginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Looks for single or multiple taps outside of the keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Setup facebook login button
        self.view.addSubview(facebookLoginButton)
        facebookLoginButton.center = self.view.center
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self

        // Hide the things we don't need for FB login
        registerCancel.hidden = true
        nameTextBox.hidden = true
        emailTextBox.hidden = true
        passTextBox.hidden = true
        confirmPasswordTextBox.hidden = true
        emailLoginButton.hidden = true

    }

    // Called from the appGestureRecognizer when any tap(s) are registered on the view.
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    // Called when the view is presented to the user
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // If the user is logged in with facebook already then redirect to the main
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            //self.returnUserData()
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
            // TODO: should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                performFromLogin()
            }
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

    @IBAction func registerNewUserPressed(sender: UIButton) {
        if (!registerNewUser) {
            registerCancel.hidden = false
            facebookLoginButton.hidden = true
            nameTextBox.hidden = false
            emailTextBox.hidden = false
            passTextBox.hidden = false
            confirmPasswordTextBox.hidden = false
            emailLoginButton.hidden = true
            loginWithEmailButton.hidden = true
            registerNewUserButton.hidden = false

            registerNewUser = true
        }
        else {
//            Do things to register user with API
//            Run cancle and drop back to login
//            registerNewUser = false
            
            // For now insecure way of testing register
//            POST /signup
//                {
//                    name: String,
//                    email: String,
//                    [optional password: String], *
//                    [optional fbid: Integer],
//                }
//                >> { success: Boolean, login_token: String }
            
            
            // Forces input to parameters passed
            // Assumes it works
            let parameters = [
                "name" : nameTextBox.text!,
                "email" : emailTextBox.text!,
                "password" : passTextBox.text!
            ]
            
            Alamofire.request(.POST, "http://databaseproject.jaxbot.me/signup", parameters: parameters, encoding: .JSON)
        }
    }

    @IBAction func cancelPressed(sender: UIButton) {
        registerCancel.hidden = true
        facebookLoginButton.hidden = true
        nameTextBox.hidden = true
        emailTextBox.hidden = false
        passTextBox.hidden = false
        confirmPasswordTextBox.hidden = true
        emailLoginButton.hidden = false
        loginWithEmailButton.hidden = false
        loginWithEmailButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        registerNewUserButton.hidden = false

        registerNewUser = false
    }

    @IBAction func loginWithEmailAndPassword(sender: AnyObject) {
        // Set standard User Default credentials
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let email:String? = emailTextBox.text
        let password:String? = passTextBox.text
        
        var parameters = [String:String]()
        
        if email != "" && password != "" {
            // Get user token from API
            parameters = [
                "email"     : email!,
                "password"  : password!
            ]
            
            Alamofire.request(.POST, "http://databaseproject.jaxbot.me/login", parameters: parameters, encoding: .JSON)
                .validate()
                .responseJSON { response in
                    print("Success: \(response.result.value!["success"])")
                    print("Login token: \(response.result.value!["login_token"])")
                    
                    if let success = response.result.value!["success"] as? NSInteger{
                        if success == 1 {
                            if let utoken = response.result.value!["login_token"] as? NSString{
                                prefs.setValue("User token string", forKey: utoken as String)
                                self.performFromLogin();
                            }
                        } else {
                            self.Alert("Incorrect User or Password")
                        }
                    }
                    
                    
            }
        } else {

            self.Alert("Please be sure to input both email and password.")
        }
        
        
    }

    @IBAction func Alert(sender: AnyObject)
    {
        var message = sender as! NSString
        print(message)

        if (message == "") {
            message = "Unrecognized message"
        }

        let alertController = UIAlertController(title: title, message: (message as String), preferredStyle:UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Put your code here
            })
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Performs the Segue for transitioning into main screen
    func performFromLogin() {
        self.performSegueWithIdentifier("login", sender: nil)
    }
    
}
