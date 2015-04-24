//
//  SquareCommentListCell.swift
//  Lolita
//
//  Created by Sam on 4/18/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class SquareCommentListCell: UITableViewCell {

    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentInfoLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sepratorHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var sepratorView: UIImageView!
    
    var avatar : UIImage?{
        didSet{
            if let pic = avatar {
                avatarImage.image = pic
            }
        }
    }
    
    
    class var identifier : String {
        get {
            return "SquareCommentListCell"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sepratorHeightContraint.constant = 1.0 / UIScreen.mainScreen().scale
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
