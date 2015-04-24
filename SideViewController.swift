//
//  SideViewController.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//
import UIKit

class SideViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    let titlesArray = ["收藏","已订购","好友","待定..."]
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    var imagePicker:UIImagePickerController?

    
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBAction func changeBackgroundImage(sender: UIButton) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "更换相册封面", "取消")
        actionSheet.destructiveButtonIndex = 1
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
        actionSheet.showInView(self.view)
    }
    
    
    
    @IBOutlet weak var heightLayoutContraintOfcategoryTableView: NSLayoutConstraint!
    
    let screenHeight = UIScreen.mainScreen().applicationFrame.maxY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.tableFooterView = UIView()
        
        heightLayoutContraintOfcategoryTableView.constant = screenHeight < 500 ? screenHeight * (568 - 221)/568 : 300
        println(heightLayoutContraintOfcategoryTableView.constant)
        self.view.frame = CGRectMake(0, 0, 320*0.78 ,screenHeight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainViewController
        
        //viewController.homeViewController.titleOfOtherViewController = titlesArray[indexPath.row]
        //viewController.homeViewController.performSegueWithIdentifier("showOtherPages", sender: self)
        
        //viewController.showHome()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leftViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        //cell.textLabel?.textColor = UIColor.yellowColor()
        cell.textLabel!.text = titlesArray[indexPath.row]
        return cell
    }
}

extension SideViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            imagePicker = UIImagePickerController()
            imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker?.delegate = self
            presentViewController(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        bgImage.image = image
    }
}
