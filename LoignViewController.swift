//
//  LoignViewController.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit
class LoignViewController: UIViewController {

    

    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title:String,error:String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {  action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            }
            ))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    var signupActive  = true
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpToggleButton: UIButton!
    @IBOutlet var loginContentView: UIView!
    // MARK: Configuration
    
    func moveLoginContentViews() {
        
        
        UIView.animateWithDuration(0.25, animations: {
            let scale = CGAffineTransformMakeScale(0.8,0.8)
            let translate = CGAffineTransformMakeTranslation(0,-105)
            let translate2 = CGAffineTransformMakeTranslation(0,-200)
            self.loginContentView.transform = CGAffineTransformConcat(scale,translate)
            //self.loginContentView.frame = CGRectMake(15, 20, 291, 249)
            self.signUpToggleButton.transform = CGAffineTransformConcat(scale,translate2)
        })
    }
    
    func moveBackLoginContentViews() {
        
        
        UIView.animateWithDuration(0.5, animations: {
            let scale = CGAffineTransformMakeScale(1,1)
            let translate = CGAffineTransformMakeTranslation(0,0)
            let translate2 = CGAffineTransformMakeTranslation(0,0)
            self.loginContentView.transform = CGAffineTransformConcat(scale,translate)
            //self.loginContentView.frame = CGRectMake(15, 20, 291, 249)
            self.signUpToggleButton.transform = CGAffineTransformConcat(scale,translate2)
        })
    }
    
    // MARK: Configuration
    
    
    
    
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        println("Text Field Should Return")
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func onEmail(sender: AnyObject) {
        moveLoginContentViews()
    }
    
    
    @IBAction func onPassword(sender: AnyObject) {
        moveLoginContentViews()
    }
    
    
    
    @IBAction func endEditing(sender: AnyObject) {
        view.endEditing(true)
        moveBackLoginContentViews()
    }
    
    
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        
        if signupActive == true {
            
            signupActive = false
            
            //signUpLabel.text = "Use the form below to log in"
            
            signUpButton.setTitle("登录", forState: UIControlState.Normal)
            
            //alreadyRegistered.text = "Not Registered?"
            
            signUpToggleButton.setTitle("注册Lolita", forState: UIControlState.Normal)
            
        }else {
            
            signupActive = true
            
            //signUpLabel.text = "Use the form below to Sign Up"
            
            signUpButton.setTitle("注册Lolita", forState: UIControlState.Normal)
            
            //alreadyRegistered.text = "Already Registered?"
            
            signUpToggleButton.setTitle("已有账号登录", forState: UIControlState.Normal)
            
            
        }
        
    }
    
    
    
    
    @IBAction func signup(sender: AnyObject) {
        
        
        
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "please enter a name and password"
            
        }
        
        if error != "" {
            
            displayAlert("Error In Form", error: error)
            
        }else{
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()//??
            
            if signupActive == true {
                
                var user = AVUser()
                user.username = username.text
                user.password = password.text
                let avatar = UIImage(named: "me")
                let imageData = UIImagePNGRepresentation(avatar)
                let imageFile = AVFile.fileWithName("avatarImage.png", data: imageData) as! AVFile
                
                user["avatarImage"] = imageFile

                self.activityIndicator.startAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                user.signUpInBackgroundWithBlock({
                    succeeded, error in
                    if (error == nil) {
                        //Open the wall
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.window?.rootViewController = MainViewController()
                    } else {
                        //Something bad has ocurred
                        //                var userInfo:Dictionary! = error.userInfo!
                        //                var errorString:NSString = userInfo["error"] as NSString
                        var errorString:NSString = error.description as NSString
                        var errorAlertView:UIAlertView = UIAlertView(title: "Error", message: errorString as String, delegate: nil, cancelButtonTitle: "OK")
                        errorAlertView.show()
                    }
                })
                
                
            } else {
                
                
                AVUser.logInWithUsernameInBackground(username.text, password: password.text, block: {
                    user, error in
                    if (user != nil) {
                        //Open the wall
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()

                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        
                        appDelegate.window?.rootViewController = MainViewController()
                    } else {
                        //Something bad has ocurred
                        //                var userInfo:Dictionary! = error.userInfo as Dictionary!
                        var errorString:NSString = error.description as NSString
                        var errorAlertView:UIAlertView = UIAlertView(title: "Error", message: errorString as String, delegate: nil, cancelButtonTitle: "OK")
                        errorAlertView.show()
                    }
                })
            }
            
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
    
    override func viewDidAppear(animated: Bool) {
        if AVUser.currentUser() != nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = MainViewController()
        }
    }
    



}
