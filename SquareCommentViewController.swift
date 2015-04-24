//
//  SquareCommentViewController.swift
//  Lolita
//
//  Created by Sam on 4/18/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit


class SquareCommentViewController: UITableViewController {

    var feedData =  FeedData()
    var comments = [CommentData]()
    let currentUserName : String = AVUser.currentUser()!.username!
    var currentUserAvatarImageFile = AVUser.currentUser().objectForKey("avatarImage") as! AVFile
    private weak var commentTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    func reload(){
        var query = AVQuery(className: "Comments")
        query.whereKey("feedID", equalTo: feedData.feedid)
        var objects = query.findObjects()
        for object in objects! {
            let eachComment = CommentData()
            eachComment.commentInfo = object["commentInfo"] as! String
            let commentUserID = object["commentUserID"] as! String
            println(commentUserID)
            var userObject = AVUser.query().getObjectWithId(commentUserID)
            println(userObject)
            eachComment.commentUserName = userObject["username"] as! String
            if let avatarImageFile = userObject!["avatarImage"] as? AVFile {
                let imageData = avatarImageFile.getData()
                eachComment.avatarImage = UIImage(data: imageData!)!
                if let time = object.createdAt{
                    let current = NSDate()
                    let delta = current.timeIntervalSinceDate(time!)
                    if delta <= 60 {
                        eachComment.commentTime =  "刚刚"
                    } else if delta < 3600 {
                        eachComment.commentTime = "\(Int(delta/60.0))分钟前"
                    } else if delta < 86400 {
                        eachComment.commentTime = "\(Int(delta/3600.0))小时前"
                    } else {
                        eachComment.commentTime = "\(Int(delta/86400.0))天前"
                    }
                    
                }
                
            }
            comments.insert(eachComment, atIndex: 0)
        }
    }
    

    
    @IBAction func sendButtonPressed(sender: UIButton) {
        
        let content = commentTextField.text
        if count(content) == 0 {
            alert("不能回复空消息")
        }else{
            var commentObject = AVObject(className: "Comments")
            var addingComment = CommentData()
            commentObject["feedID"] = feedData.feedid
            addingComment.feedid = feedData.feedid
            commentObject["commentInfo"] = content
            addingComment.commentInfo = content
            commentObject["commentUserID"] = AVUser.currentUser()?.objectId
            addingComment.commentUserName = currentUserName
            addingComment.commentTime = "刚刚"
            addingComment.avatarImage = UIImage(data: currentUserAvatarImageFile.getData()!)!
            commentObject.saveInBackground()
            comments.insert(addingComment, atIndex: 0)
            commentTextField.text = ""
            commentTextField.placeholder = "随手写点吧"
            
            tableView.reloadData()
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        case 1:
            return self.comments.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        // Configure the cell...
        println("~~~~~~~~~~~~~~~~~~\(indexPath.section)")
        println("~~~~~~~~~~~~~~\(feedData.postInfo)")
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("SquareCellIdentifier", forIndexPath: indexPath) as! SquareCell
            let cell = cell as! SquareCell
            //let cell = tableView.dequeueReusableCellWithIdentifier("SquareCellIdentifier") as! SquareCell
            cell.indexPath = indexPath
            cell.keeperNameLabel.text = feedData.username
            cell.avaterButtonImage = feedData.avatarImage
            cell.postInfoLabel?.text = feedData.postInfo
            cell.twitterImages = feedData.postImages
            cell.upNumberLabel.text = String(feedData.star)
            cell.commentNumberLabel.text = String(feedData.comment)
            cell.stared = feedData.star != 0
            cell.timeLabel.text = feedData.postTime
            cell.delegate = self

            
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("SquareCommentListCell") as! SquareCommentListCell
            let cell = cell as! SquareCommentListCell
            
            let comment = comments[indexPath.row] as CommentData
            cell.usernameLabel.text = comment.commentUserName
            cell.timeLabel.text = comment.commentTime
            cell.avatar = comment.avatarImage
            //comment.receiverName = comment.commentUserName
            var attributed = NSMutableAttributedString(string: "\(comment.commentUserName)回复\(comment.receiverName):\(comment.commentInfo)")
            let nameRange = NSRange(location: 0, length: count(comment.commentUserName))
            let replyRange = NSRange(location: count(comment.commentUserName), length: 2)
            let recieverRange = NSRange(location: count(comment.commentUserName) + 2, length: count(comment.receiverName))
            let contentRange = NSRange(location: count(comment.commentUserName) + 2 + count(comment.receiverName) + 1, length: count(comment.commentInfo))
            attributed.addAttributes([
                    NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                    NSForegroundColorAttributeName  : UIColor.LolitaThemeDarkText()
                    ], range: nameRange)
            attributed.addAttributes([
                    NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                    NSForegroundColorAttributeName  : UIColor.blackColor()
                    ], range: replyRange)
            attributed.addAttributes([
                    NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                    NSForegroundColorAttributeName  : UIColor.LolitaThemeDarkText()
                    ], range: recieverRange)
            attributed.addAttributes([
                    NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                    NSForegroundColorAttributeName  : UIColor.blackColor()
                    ], range: contentRange)
            cell.commentInfoLabel.attributedText = attributed
            
            
            //            switch indexPath.row % 2 {
            //            case 0:
            //                cell.backgroundColor = UIColor.LCYTableLightBlue()
            //            case 1:
            //                cell.backgroundColor = UIColor.LCYTableLightGray()
            //            default:
            //                break
            //            }
            cell.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("SquareCommentCell") as! SquareCommentCell
            let cell = cell as! SquareCommentCell
            commentTextField = cell.commentTextField
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let celldata = feedData
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
        case 1:
            var height: CGFloat = 0.0
            let comment = comments[indexPath.row] as CommentData
            
            var attributed = NSMutableAttributedString(string: "\(comment.commentUserName)回复\(comment.receiverName):\(comment.commentInfo)")
            let nameRange = NSRange(location: 0, length: count(comment.commentUserName))
            let replyRange = NSRange(location: count(comment.commentUserName), length: 2)
            let recieverRange = NSRange(location: count(comment.commentUserName) + 2, length: count(comment.receiverName))
            let contentRange = NSRange(location: count(comment.commentUserName) + 2 + count(comment.receiverName) + 1, length: count(comment.commentInfo))
            attributed.addAttributes([
                NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                NSForegroundColorAttributeName  : UIColor.LolitaThemeDarkText()
                ], range: nameRange)
            attributed.addAttributes([
                NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                NSForegroundColorAttributeName  : UIColor.blackColor()
                ], range: replyRange)
            attributed.addAttributes([
                NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                NSForegroundColorAttributeName  : UIColor.LolitaThemeDarkText()
                ], range: recieverRange)
            attributed.addAttributes([
                NSFontAttributeName             : UIFont.systemFontOfSize(12.0),
                NSForegroundColorAttributeName  : UIColor.blackColor()
                ], range: contentRange)

            height = attributed.boundingRectWithSize(CGSize(width: UIScreen.mainScreen().bounds.width - 72.0, height: 20000.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).height
            
            return max(height + 42.0 , 66.0)
        case 2:
            return 44.0
        default:
            return 0.0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            //resetInputView()
            tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 2), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue())
                {
                    [weak self] in
                    //self?.replyData = self?.infoData?.comment[indexPath.row] as? TwitterCommentListComment
                    //let replyTo = self?.replyData?.keeperName ?? "神秘人物"
                    let replyTo = self!.comments[indexPath.row].commentUserName
                    self!.comments[indexPath.row].receiverName = self!.currentUserName
                    self?.commentTextField?.placeholder = "回复:\(replyTo)"
                    self?.commentTextField?.becomeFirstResponder()
            }
            
        }
    }
    
    
}

extension SquareCommentViewController: SquareCellDelegate {
    func SquareCellComment(indexPath: NSIndexPath) {
        commentTextField?.becomeFirstResponder()
    }
    func SquareCellStar(indexPath: NSIndexPath){
        
    }
    func SquareCellTitleClicked(indexPath: NSIndexPath){
        
    }
    func SquareCellCare(indexPath: NSIndexPath){
        
    }
    func SquareCellExpand(indexPath: NSIndexPath){
        
    }
    func SquareCellShare(indexPath: NSIndexPath){
        
    }


}
