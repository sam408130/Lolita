//
//  FindViewController.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class FindViewController: UITableViewController {

    var data = [FeedData]()
    var pfdata = [AVObject]()
    
    var clickCellStar = false
    var currentindexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    func displayAlert(title:String,error:String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {  action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            }
            ))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    var refresher:UIRefreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatePostData()
        println(data)
        refresher.attributedTitle = NSAttributedString(string:"下拉刷新")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func updatePostData(){
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)){ () -> Void in
        var query = AVQuery(className: "PostFeed")
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?,error:NSError?) -> Void in
            if error == nil {
                for object in objects!{
                    self.pfdata.insert(object as! (AVObject), atIndex: 0)
                    let feedData = FeedData()
                    feedData.userid = object.objectForKey("userID") as! String
                    var userObject = AVUser.query()!.getObjectWithId(feedData.userid)
                    if let avatarImageFile = userObject!["avatarImage"] as? AVFile {
                        let imageData = avatarImageFile.getData()
                        feedData.avatarImage = UIImage(data: imageData!)!
                        
                        
                    }
                    feedData.feedid = object.objectId!! as String
                    feedData.comment = object["comment"] as! Int
                    feedData.star = object["star"] as! Int
                    if let time = object.createdAt{
                        let current = NSDate()
                        let delta = current.timeIntervalSinceDate(time!)
                        if delta <= 60 {
                            feedData.postTime =  "刚刚"
                        } else if delta < 3600 {
                            feedData.postTime = "\(Int(delta/60.0))分钟前"
                        } else if delta < 86400 {
                            feedData.postTime = "\(Int(delta/3600.0))小时前"
                        } else {
                            feedData.postTime = "\(Int(delta/86400.0))天前"
                        }
                        
                    }
                    
                    feedData.postInfo = object["postInfo"] as! String
                    
                    if let avatarImageFile = object["postImage1"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )

                    }

                    println(feedData.avatarImage)
                    self.data.insert(feedData, atIndex: 0)
                    self.tableView.reloadData()
                }
                
                
            }
            else{
                
                self.displayAlert("网络连接错误", error: "请检查网络连接")
            }
            
            self.refresher.endRefreshing()
            
            
            
        }
        }
        
        
    }
    func refresh(){
        updatePostData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.count
    }
    

     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("findcell", forIndexPath: indexPath) as! FindCell
        cell.userDescription = data[indexPath.row].postInfo
        cell.postImage = data[indexPath.row].postImages[0]
        cell.avaterButtonImage = data[indexPath.row].avatarImage
        cell.postTime = data[indexPath.row].postTime
        cell.starcountLabel.text = String(data[indexPath.row].star)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
  
    
}




extension FindViewController: FindCellDelegate{

    
    func findCellStar(indexPath: NSIndexPath){
        println(indexPath)
        if currentindexPath != indexPath {
            clickCellStar = false
            currentindexPath = indexPath
        }
        let cellpfdata = pfdata[indexPath.row] as AVObject
        if clickCellStar{
            data[indexPath.row].star += -1
            clickCellStar = false
        }else {
           data[indexPath.row].star += 1
            clickCellStar = true
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        if clickCellStar {
            cellpfdata.incrementKey("star")
            cellpfdata.saveInBackground()
        }
        
        
        
    }
    
    
    func findCellShare(indexPath: NSIndexPath){
        
    }
    
    func findCellTitleClicked(indexPath: NSIndexPath){
        
    }
    func findCellComment(indexPath: NSIndexPath){
        
    }
    func findCellCare(indexPath: NSIndexPath){
        
    }
    func findCellExpand(indexPath: NSIndexPath){
        
    }


}

