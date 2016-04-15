//
//  SettingsViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/11/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
   
    let prefs = NSUserDefaults.standardUserDefaults()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headers = [
            "x-Access-Token": prefs.stringForKey("utoken")!
        ]
        
        var userId: NSNumber = 0
        var myPic: NSString = ""
        var userName: String = ""
        
        Alamofire.request(.GET, "http://databaseproject.jaxbot.me/feed", headers: headers)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .Success:
                    userId = response.result.value!["myid"] as! NSNumber
                    myPic = response.result.value!["profile_picture_id"] as! NSString
                    let userString:String = String(format:"%d", userId.intValue)
                    print(userString)
                    dispatch_async(dispatch_get_main_queue (), {
                        
                        if( myPic == ""){
                            myPic = "none"
                        }
                        Alamofire.request(.GET, "http://databaseproject.jaxbot.me/" + (myPic as String) + ".jpg")
                            .responseImage { response in
                                
                                print("here!")
                                dispatch_async(dispatch_get_main_queue (), {
                                    if let image = response.result.value {
                                        self.profilePicture.image = image
                                        print("Image: \(image)")
                                    }
                                })
                        }
                        Alamofire.request(.GET, "http://databaseproject.jaxbot.me/user/" + userString)
                            .responseJSON{ response in
                                switch response.result {
                                case .Success:
                                    userName = response.result.value![0]["name"] as! NSString as String
                                    dispatch_async(dispatch_get_main_queue (), {
                                        self.profileName.text = userName
                                        print(userName)
                                        
                                    })
                                case .Failure:
                                    print("boo!")
                                }
                
                                
                        }
                    })
                case .Failure:
                    print("boo")
                }
        }
        
        
    }
    
    
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
        
        self.profileName.text = name
        
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
    
    @IBOutlet weak var changePhoto: UIButton!
    
    @IBAction func changePhotoPressed(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        

    }
    
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profilePicture.image = resizeImage(image!, newWidth: 200)
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var changePassword: UIButton!
    
    
    @IBAction func changePasswordPressed(sender: AnyObject) {
        let passAlertController = UIAlertController(title: "Change Pass", message: "Update your password below", preferredStyle:UIAlertControllerStyle.Alert)
        
        passAlertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Enter Password"
        })
        
        passAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Closes alert
            })
        
        passAlertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default)
        { action -> Void in
            // Closes alert
            })
        self.presentViewController(passAlertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("fromSettings", sender: self)
    }
    
}
