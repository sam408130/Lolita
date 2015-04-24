//
//  AddViewController.swift
//  Lolita
//
//  Created by Sam on 4/20/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class AddViewController: UITableViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
   
    private weak var textView: UITextView?
    
    weak var delegate : AddCircleDelegate?
    
    private weak var imageCollectionView : UICollectionView?
    
    private var postImages = [UIImage]()
    
    enum addInfoType : Int{
        case text = 0
        case image = 1
    }
    var currentType : addInfoType = .text
    
    
    
    func displayAlert(title:String,error:String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {  action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            }
            ))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        switch currentType{
        case .text:
            self.title = "文字消息"
        case .image:
            self.title = "图文消息"
        }
        
        self.tableView.backgroundColor = UIColor.LolitaThemeColor()
        
        self.addRightButton("发送", action: "rightButtonPressed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func rightButtonPressed(){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var postFeed = AVObject(className: "PostFeed")
        postFeed["postInfo"] = textView!.text
        postFeed["userID"] = AVUser.currentUser().objectId
        var count = 0
        if postImages.count == 0 {
            displayAlert("照片为空", error: "请选择照片")
        }else{
            for postImage in postImages{
                count += 1
                let fileData:NSData = UIImagePNGRepresentation(postImage)
                let file = AVFile.fileWithName("postImage\(count)", data: fileData) as! AVFile
                postFeed["postImage\(count)"] = file
                
            }
            
            postFeed.saveInBackgroundWithBlock{
                
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    //self.displayAlert("添加成功", error: "")
                    self.delegate?.addCircleDone()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.displayAlert("网络连接错误", error: "请检查网络连接")
                }
                
            }

        }
        
        
    }
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as! AddTextCell
            let cell = cell as! AddTextCell
            textView = cell.textView
        
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! AddImageCell
            let cell = cell as! AddImageCell
            cell.collectionDataSource = self
            imageCollectionView = cell.AddImageCollectionView
            
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 150.0
        case 1:
            return UIScreen.mainScreen().bounds.width / 4.0 * 3.0 + 20
        default:
            return 44.0
        }
    }

}


extension AddViewController : UIActionSheetDelegate{
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if postImages.count >= 9{
            alert("您最多可以上传9张照片")
            return
        }
        switch buttonIndex{
        case 0:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
            break
        case 1:
            let multiPicker = DSMultiImagePicker()
            multiPicker.maxSelectNumber = 9 - postImages.count
            multiPicker.delegate = self
            multiPicker.show()
            break
        default:
            break
        }
    }
}


extension AddViewController : AddImageSource{
    func addImageCount() -> Int{
        return postImages.count
    }
    func addImageAt(index: Int) -> UIImage?{
        return postImages[index]
    }
    func addImageWillTakePicture(){
        if postImages.count < 9 {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "我要拍照", "从照片库选取","取消")
            actionSheet.destructiveButtonIndex = 2
            actionSheet.showInView(self.view)
        }else{
            alert("您一次最多可以上传9张图片")
        }
    }
    func addImageDidSelect(index: Int){
        println("index is \(index)")
        let imageBrowser = DSImageBrowser()
        imageBrowser.imageDataSource = self
        imageBrowser.startIndex = index
        imageBrowser.setRightButton(image: nil, title: "移除"){ [weak self](index) -> Void in
            self?.postImages.removeAtIndex(index)
            self?.imageCollectionView?.reloadData()
            imageBrowser.reloadData()
            
        }
        imageBrowser.show()
    }
}


extension AddViewController : DSImageBrowserDataSource{
    func numberOfImagesInDSImageBrowser(dsImageBrowser: DSImageBrowser) -> Int {
        return postImages.count
    }
    
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, pathForIndex pathIndex: Int) -> UIImage?{
        return nil
    }
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, imageForIndex imageIndex: Int) -> UIImage?{
        return postImages[imageIndex]
    }
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, titleForIndex titleIndex: Int) -> String?{
        return nil
    }
}


extension AddViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let smallImage = UIImage(image:info[UIImagePickerControllerOriginalImage] as! UIImage , scaledToFitToSize:CGSize(width: 600, height: 600))
        if picker.sourceType == .Camera{
            UIImageWriteToSavedPhotosAlbum(smallImage, nil, nil, nil)
        }
        postImages.append(smallImage)
        imageCollectionView?.reloadData()
    }
}

extension AddViewController : DSMultiImagePickerDelegate{
    func DSMultiImagePickerDidSelectImages(images: [UIImage]) {
        let smallImages = images.map({
            UIImage(image: $0 , scaledToFitToSize:CGSize(width: 600, height: 600)).imageOrientationUp()
        })
        postImages.extend(smallImages)
        imageCollectionView?.reloadData()
    }
}




protocol AddCircleDelegate: class {
    func addCircleDone()
}
