//
//  AddImageCell.swift
//  Lolita
//
//  Created by Sam on 4/20/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class AddImageCell: UITableViewCell {

    weak var collectionDataSource : AddImageSource?
    
    @IBOutlet weak var AddImageCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.LolitaThemeColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



extension AddImageCell : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = collectionDataSource{
            return 1 + dataSource.addImageCount()
        }else{
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddImageCollection", forIndexPath: indexPath) as! AddImageCollectionCell
        if let dataSource = collectionDataSource {
            if indexPath.row < dataSource.addImageCount(){
                cell.imageView.contentMode = UIViewContentMode.ScaleAspectFill
                cell.imageView.image = dataSource.addImageAt(indexPath.row)
            }else{
               cell.imageView.contentMode = UIViewContentMode.Center
               cell.imageView.image = UIImage(named: "bigCamera")
            }
        }
     return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let unwrapped = self.collectionDataSource{
            if indexPath.row == unwrapped.addImageCount(){
                unwrapped.addImageWillTakePicture()
            }else{
                unwrapped.addImageDidSelect(indexPath.row)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = UIScreen.mainScreen().bounds.width / 4  - 11.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    }
}

protocol AddImageSource: class {
    func addImageCount() -> Int
    func addImageAt(index: Int) -> UIImage?
    func addImageWillTakePicture()
    func addImageDidSelect(index: Int)
}