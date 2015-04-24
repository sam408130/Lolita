//
//  DSMultiImageCollectionCell.swift
//  Lolita
//
//  Created by Sam on 4/20/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class DSMultiImageCollectionCell: UICollectionViewCell {
    var indexPath = NSIndexPath(forItem: 0, inSection: 0)
    weak var delegate: DSMultiImageCellDelegate?
    
    weak var mainImageView: UIImageView?
    
    private weak var checkMark: UIButton?
    
    var cySelected: Bool = false {
        didSet {
            if cySelected {
                //                checkMark?.image = UIImage(named: DSMultiImagePickerCheckMarkSelected)
                checkMark?.setImage(UIImage(named: DSMultiImagePickerCheckMarkSelected), forState: UIControlState.Normal)
            } else {
                //                checkMark?.image = UIImage(named: DSMultiImagePickerCheckMarkUnSelected)
                checkMark?.setImage(UIImage(named: DSMultiImagePickerCheckMarkUnSelected), forState: UIControlState.Normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let mainImageView = UIImageView(frame: CGRectZero)
        contentView.addSubview(mainImageView)
        mainImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let mainImageTop = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let mainImageBottom = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        let mainImageLeading = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let mainImageTrailing = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        
        contentView.addConstraints([mainImageTop, mainImageBottom, mainImageLeading, mainImageTrailing])
        self.mainImageView = mainImageView
        
        
        // 配置对勾
        let mark = UIButton()
        mark.addTarget(self, action: "markButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        mark.setImage(UIImage(named: DSMultiImagePickerCheckMarkUnSelected), forState: UIControlState.Normal)
        //        let mark = UIImageView(image: UIImage(named: DSMultiImagePickerCheckMarkUnSelected))
        mark.setTranslatesAutoresizingMaskIntoConstraints(false)
        let markRight = NSLayoutConstraint(item: mark, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -8.0)
        let markBottom = NSLayoutConstraint(item: mark, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -8.0)
        contentView.addSubview(mark)
        contentView.addConstraints([markRight, markBottom])
        checkMark = mark
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class var identifier: String {
        return "DSMultiImageCollectionCellIdentifier"
    }
    
    deinit {
        //        println("cell deinit")
    }
    
    func markButtonPressed(sender: AnyObject) {
        delegate?.cellCheckMarkButtonPressed(indexPath)
    }
}

protocol DSMultiImageCellDelegate: class {
    func cellCheckMarkButtonPressed(index: NSIndexPath)
}
