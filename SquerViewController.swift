//
//  SquerViewController.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit


class SquerViewController: UITableViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate{


    var clickCellStar = false
    var currentindexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    

    private var imagePicker : UIImagePickerController?
    var data = [FeedData]()
    var pfdata = [AVObject]()
    private enum magicNumber: Int {
        case changeCover = 3391
        case addTwitter = 3392
    }
    var refresher:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "二手市场"
        let rightitem = UIBarButtonItem(image: UIImage(named: "twiPlus"), style: UIBarButtonItemStyle.Plain, target: self, action: "rightButtonPressed:")
        self.navigationItem.rightBarButtonItem = rightitem
        refresher.attributedTitle = NSAttributedString(string:"下拉刷新")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        reload()
            


        
    }
    func displayAlert(title:String,error:String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {  action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            }
            ))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

    func refresh(){
        reload()
        println("~~~~~~~~\(data.count)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reload() {
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)){ () -> Void in
            var query = AVQuery(className: "PostFeed")
            query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?,error:NSError?)  in
            if error == nil {
                self.data = []
                self.pfdata = []
                for object in objects!{
                    self.pfdata.insert(object as! (AVObject), atIndex: 0)
                    let feedData = FeedData()
                    feedData.feedid = object.objectId!!
                    feedData.userid = object["userID"] as! String
                    var userObject = AVUser.query()!.getObjectWithId(feedData.userid)
                    feedData.username = userObject!["username"] as! String
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
                    if let avatarImageFile = object["postImage2"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage3"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage4"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage5"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage6"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage7"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage8"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    if let avatarImageFile = object["postImage9"] as? AVFile{
                        
                        let imageData = avatarImageFile.getData()
                        feedData.postImages.insert( UIImage(data: imageData!)!, atIndex: 0 )
                        
                    }
                    
                    
                    println(feedData.avatarImage)
                    println("运行到这里了")
                    self.data.insert(feedData, atIndex: 0)
                    //self.tableView.reloadData()
                }
                
                
            }
        
            else{
                self.displayAlert("网络连接错误", error: "请检查网络连接")
            }
        
        
        }
            self.refresher.endRefreshing()
            
        }
    }
    
    private func loadMore(){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showComment"{
            let destinationVC = segue.destinationViewController as! SquareCommentViewController
            let celldata = sender as! FeedData
            destinationVC.feedData = celldata
        }else if segue.identifier == "showAdd"{
            let destinationVC = segue.destinationViewController as! AddViewController
            let caseNumber = sender as! Int
            destinationVC.delegate = self
            switch caseNumber{
            case 0:
                destinationVC.currentType = .text
            case 1:
                destinationVC.currentType = .image
            default:
                break
            }
        }
    }
    
    func rightButtonPressed(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "新建文字消息", "新建图文消息", "取消")
        
        actionSheet.destructiveButtonIndex = 2
        actionSheet.tag = magicNumber.addTwitter.rawValue
        actionSheet.showInView(self.view)
    }
    
    
    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SquaerCell") as! SquareCell
        cell.indexPath = indexPath
        let celldata =  data[indexPath.row]
        
        cell.keeperNameLabel.text = celldata.username
        cell.avaterButtonImage = celldata.avatarImage
        cell.postInfo = celldata.postInfo
        cell.twitterImages = celldata.postImages
        cell.upNumberLabel.text = String(celldata.star)
        cell.commentNumberLabel.text = String(celldata.comment)
        cell.stared = celldata.star != 0
        cell.timeLabel.text = celldata.postTime
        
        //cell.cared = data.isRel != 0
        
        cell.delegate = self
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //let data = twitters![indexPath.row]
        let celldata = data[indexPath.row]
    
        // 最新公式：
        // 高度 = 11 + 题头高度 + 8 + 图片模块高度 + 8 + (赞列表模块高度(35) + 8) + 点赞按钮模块高度(24) + 底部空间(8)
        // 题头高度 = 图片高度(61) + 4 + 文字高度 + 4
        // 图片模块高度略
        let textHeight = 86.0 + 16.0
        let textBlockHeight = 61.0 + 4.0 + textHeight + 4.0
        
        var imageBlockHeight: CGFloat = 0.0
        switch celldata.postImages.count {
        case 0:
            imageBlockHeight = -8.0
        case 1:
            //            imageBlockHeight = CGFloat((data.images[0].cutHeight as NSString).floatValue) / CGFloat((data.images[0].cutWidth as NSString).floatValue) * CGFloat(UIScreen.mainScreen().bounds.width * 2.0 / 3.0)
            if let imageData = celldata.postImages[0] as UIImage? {
                if imageData.size.width > imageData.size.height {
                    imageBlockHeight = imageData.size.height / imageData.size.width * CGFloat(UIScreen.mainScreen().bounds.width * 2.0 / 3.0)
                } else {
                    imageBlockHeight = UIScreen.mainScreen().bounds.width * 2.0 / 3.0
                }
            }
            
            
            //            }
        case 2, 3:
            imageBlockHeight = UIScreen.mainScreen().bounds.width / 3.0
        case 4, 5, 6:
            imageBlockHeight = UIScreen.mainScreen().bounds.width / 3.0 * 2.0
        case 7, 8, 9:
            imageBlockHeight = UIScreen.mainScreen().bounds.width
        default:
            break
        }
        let cellheight = 171.0 + imageBlockHeight + 59.0
        return cellheight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let celldata = data[indexPath.row]
        if celldata.postImages.count > 0 {
            //            performSegueWithIdentifier("showPageView", sender: data)
            let imageBrowser = DSImageBrowser()
            imageBrowser.imageDataSource = self
            imageBrowser.setSingleTapHandler({ [weak imageBrowser]() -> Void in
                imageBrowser?.hide()
                return
                })
            imageBrowser.show()
        }
        
        //        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FindTwitterListCell {
        //            println("\(cell.icyContentLabel.bounds.height)")
        //        } else {
        //            println("nope!")
        //        }
    }
    
}

extension SquerViewController: DSImageBrowserDataSource {
    func numberOfImagesInDSImageBrowser(dsImageBrowser: DSImageBrowser) -> Int {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            let celldata = data[selectedIndexPath.row]
            return celldata.postImages.count
        } else {
            return 0
        }
    }
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, titleForIndex index: Int) -> String? {
        return nil
    }
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, pathForIndex index: Int) -> UIImage? {
        return nil
    }
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, imageForIndex imageIndex: Int) -> UIImage? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            let celldata = data[selectedIndexPath.row]
            if let imageData = celldata.postImages[imageIndex] as UIImage? {
                return imageData
            } else {
                return nil
            }
        } else {
            return nil
        }

    
    }
}

extension SquerViewController: UIActionSheetDelegate {
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch actionSheet.tag {
        case magicNumber.addTwitter.rawValue:
            // 新建
            switch buttonIndex {
            case 0:
                self.performSegueWithIdentifier("showAdd", sender: buttonIndex)
            case 1:
                self.performSegueWithIdentifier("showAdd", sender: buttonIndex)
            default:
                break
            }
        case magicNumber.changeCover.rawValue:
            //            println("change cover at \(buttonIndex)")
            if buttonIndex == 0 {
                imagePicker = UIImagePickerController()
                imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker?.delegate = self
                presentViewController(imagePicker!, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    func willPresentActionSheet(actionSheet: UIActionSheet) {
        for subView in actionSheet.subviews {
            if subView is UIButton {
                let button = subView as! UIButton
                if button.titleLabel?.text != "取消" {
                    button.setTitleColor(UIColor.LolitaThemeDarkText(), forState: UIControlState.Normal)
                }
            }
        }
    }
}

extension SquerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        //self.showHUDWithTips("处理中")
        
    }
}



extension SquerViewController: SquareCellDelegate{
    
    
    func SquareCellStar(indexPath: NSIndexPath){
        
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
    func SquareCellTitleClicked(indexPath: NSIndexPath){
        
    }
    func SquareCellComment(indexPath: NSIndexPath){
        let celldata = data[indexPath.row]
        println("~~~~~~~~~~~~")
        println(celldata)
        println("~~~~~~~~~~~~")
        performSegueWithIdentifier("showComment", sender: celldata)
    }
    func SquareCellCare(indexPath: NSIndexPath){
        
    }
    func SquareCellExpand(indexPath: NSIndexPath){
        
    }
    func SquareCellShare(indexPath: NSIndexPath){
        
    }
    
    
}


extension SquerViewController: AddCircleDelegate {
        func addCircleDone() {
            reload()
        }
}



