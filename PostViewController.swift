//
//  PostViewController.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    

    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func displayAlert(title:String,error:String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {  action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            }
            ))
        
        self.presentViewController(alert, animated: true, completion:nil)
        
        
    }
    
    
    var photoSelected:Bool = false
    
    @IBOutlet var imageToPost: UIImageView!
    
    
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    
    
    


    @IBOutlet var shareText: UITextField!
 
    
    @IBAction func postImage(sender: AnyObject) {
        
        var error = ""
        
        if (photoSelected == false){
            
            error = "请选择一张图片"
            
        }else if( shareText.text == "" ){
            
            error = "请对您心爱的Lolita做一下描述"
            
        }
        
        if(error != ""){
            
            displayAlert("无法发布", error: error)
        }else{
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()//??
            
            var post = AVObject(className: "DataForCell")
            post["postInfo"] = shareText.text
            post["userName"] = AVUser.currentUser()!.username
            
            
            
            post.saveInBackgroundWithBlock{(success:Bool ,error:NSError?) -> Void in
                
                if success == false {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.displayAlert("网络错误", error: "请检查网络连接")
                    
                }else {
                    
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    let imageFile = AVFile.fileWithName("postImage.png", data: imageData) as! AVFile
                    
                    post["postImage"] = imageFile
                    
                    post.saveInBackgroundWithBlock{(success:Bool,error:NSError?) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if success == false {
                            
                            self.displayAlert("图片上传失败", error: "请检查网络连接")
                            
                        }else{
                            
                            self.displayAlert("图片上传成功", error: "")
                            self.photoSelected = false
                        
                            self.shareText.text = ""
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            
                            appDelegate.window?.rootViewController = MainViewController()
                        }
                        
                    }
                }
                
                
                
            }
            
        }
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion:nil)
        imageToPost.image = image
        photoSelected = true
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSelected = false
        shareText.text = ""

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

