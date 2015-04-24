//
//  SquareCell.swift
//  Lolita
//
//  Created by Sam on 4/18/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

import UIKit

let twitterFontSize = CGFloat(12.0)



protocol SquareCellDelegate: class {
    func SquareCellStar(indexPath: NSIndexPath)
    func SquareCellTitleClicked(indexPath: NSIndexPath)
    func SquareCellComment(indexPath: NSIndexPath)
    func SquareCellCare(indexPath: NSIndexPath)
    func SquareCellExpand(indexPath: NSIndexPath)
    func SquareCellShare(indexPath: NSIndexPath)
}

class SquareCell: UITableViewCell {
    
    
    // MARK: - Outlets
    
    /// 主人昵称
    @IBOutlet weak var keeperNameLabel: UILabel!
    /// 主人头像
    @IBOutlet private weak var keeperAvatarImageView: UIImageView!
    var avaterButtonImage : UIImage?{
        didSet{
            if let aImage = avaterButtonImage{
                keeperAvatarImageView.image = aImage
                let radius = min(keeperAvatarImageView.bounds.width, keeperAvatarImageView.bounds.height) / 2.0
                keeperAvatarImageView.layer.masksToBounds = true
                keeperAvatarImageView.layer.cornerRadius = radius
                
            }
            else{
                keeperAvatarImageView.image = UIImage(named: "image3")
            }
        }
    }

    /// 发送的内容
    
    @IBOutlet weak var postInfoLabel: UILabel!
    
    @IBOutlet weak var postInfoBlockHeight: NSLayoutConstraint!
    var postInfo: String? {
        didSet {
            if let content = postInfo {
                postInfoLabel.text = content
                var textHeight = content.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 16.0, 20000.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(twitterFontSize)], context: nil).height
                if textHeight > 86.0 && !expand {
                    textHeight = 86.0
                    textHeight += 16.0
                    postInfoLabel.numberOfLines = 6
                    fullButton.hidden = false
                } else {
                    fullButton.hidden = true
                    postInfoLabel.numberOfLines = 0
                }
                postInfoBlockHeight.constant = textHeight + 68.0
            } else {
                postInfoLabel.text = ""
                postInfoBlockHeight.constant = 68.0
            }
        }
    }
    @IBOutlet private weak var fullButton: UIButton!
    @IBAction func fullButtonPressed(sender: AnyObject) {
        delegate?.SquareCellExpand(indexPath)
    }
    var expand: Bool = false
    
    /// 中间的图片
    @IBOutlet private weak var headerBlockView: UIView!
    @IBOutlet weak var icyImageBlockHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var middleSizedImages: [UIImageView]!
    @IBOutlet private weak var onlyOneImageView: UIImageView!
    @IBOutlet weak var singleImageWidthConstraint: NSLayoutConstraint!
    let placeHolderColor = UIColor(white: 0.9, alpha: 1.0)
    var twitterImages: [UIImage]? {
        didSet {
            // 清除背景颜色
            onlyOneImageView.backgroundColor = UIColor.clearColor()
            for mid in middleSizedImages {
                mid.backgroundColor = UIColor.clearColor()
            }
            // 设置图片
            if let images = twitterImages {
                onlyOneImageView.image = nil
                if images.count == 0 {
                    icyImageBlockHeightConstraint.constant = 0.0
                    for one in middleSizedImages {
                        one.image = nil
                    }
                } else if images.count == 1 {
                
                    if images[0].size.width > images[0].size.height{
                        singleImageWidthConstraint.constant = UIScreen.mainScreen().bounds.width - 60 // / 4.0 * 2.0
                        //icyImageBlockHeightConstraint.constant = images[0].size.height  / images[0].size.width * CGFloat(UIScreen.mainScreen().bounds.width * 2.0 / 3.0)
                        icyImageBlockHeightConstraint.constant = UIScreen.mainScreen().bounds.width - 60
                    } else {
                        icyImageBlockHeightConstraint.constant = UIScreen.mainScreen().bounds.width - 60 // / 3.0 * 2.0
                        //singleImageWidthConstraint.constant = (UIScreen.mainScreen().bounds.width / 4.0 * 2.0) / images[0].size.height * images[0].size.width
                        icyImageBlockHeightConstraint.constant = UIScreen.mainScreen().bounds.width - 60
                    }
                    for one in middleSizedImages {
                        one.image = nil
                    }
                    
                    onlyOneImageView.contentMode = .Center
                    onlyOneImageView.backgroundColor = placeHolderColor
                    onlyOneImageView.image = images[0]
                    onlyOneImageView.contentMode = .ScaleAspectFill
                } else {
                    onlyOneImageView.image = nil
                    if images.count <= 3 {
                        // 2-3张\
                        icyImageBlockHeightConstraint.constant = UIScreen.mainScreen().bounds.width / 3.0
                    } else if images.count <= 6 {
                        // 4-6张
                        icyImageBlockHeightConstraint.constant = UIScreen.mainScreen().bounds.width / 3.0 * 2.0
                    } else {
                        // 9张
                        icyImageBlockHeightConstraint.constant = UIScreen.mainScreen().bounds.width
                    }
                    for middle in middleSizedImages {
                        if middle.tag > images.count {
                            middle.image = nil
                        } else {
                            middle.contentMode = .Center
                            middle.backgroundColor = placeHolderColor
                            middle.image = images[middle.tag - 1]
                            middle.contentMode = .ScaleAspectFill

                        }
                    }
                }
            } else {
                // 正常情况程序不会执行这一段
                println("no images")
                icyImageBlockHeightConstraint.constant = 0.0
                for one in middleSizedImages {
                    one.image = nil
                }
            }
        }
    }


    /// 点赞数量
    @IBOutlet weak var upNumberLabel: UILabel!
    /// 评论数量
    @IBOutlet weak var commentNumberLabel: UILabel!
    

    
    /// 用户是否点过赞
    @IBOutlet private weak var starButton: UIButton!
    var stared: Bool = false {
        didSet {
            if stared {
                starButton.setImage(UIImage(named: "twiZanFill"), forState: UIControlState.Normal)
            } else {
                starButton.setImage(UIImage(named: "twiZan"), forState: UIControlState.Normal)
            }
        }
    }
    
    // 用户性别


    
    @IBOutlet private weak var sepratorImageView: UIImageView!
    @IBOutlet private weak var sepractorHeightConstraint: NSLayoutConstraint!
    
    /// 代理，用于传递事件
    weak var delegate: SquareCellDelegate?
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    @IBAction func starButtonPressed(sender: AnyObject) {
        delegate?.SquareCellStar(indexPath)
    }
    @IBAction func commentButtonPressed(sender: AnyObject) {
        delegate?.SquareCellComment(indexPath)
    }
    @IBAction func headBlockTouched(sender: AnyObject) {
        delegate?.SquareCellTitleClicked(indexPath)
    }
    @IBAction func careButtonPressed(sender: AnyObject) {
        delegate?.SquareCellCare(indexPath)
    }
    @IBAction func shareButtonPressed(sender: AnyObject) {
        delegate?.SquareCellShare(indexPath)
    }
    
    /// 发布时间
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    // MARK: - Actions
    class var identifier: String {
        return "FindTwitterListCellIdentifier"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        keeperAvatarImageView.roundCorner()
        
        headerBlockView.bringSubviewToFront(onlyOneImageView)
        
        sepractorHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
                //        let placeHolderColor = UIColor(white: 0.95, alpha: 1.0)
        //        onlyOneImageView.backgroundColor = placeHolderColor
        //        for mid in middleSizedImages {
        //            mid.backgroundColor = placeHolderColor
        //        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

