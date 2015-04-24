//
//  FindHistoryCommentCell.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class FindHistoryCommentCell: UITableViewCell {

    @IBOutlet weak var CommentUserAvater: UIImageView!
    
    @IBOutlet weak var CommentUserName: UILabel!
    
    @IBOutlet weak var CommentPostTime: UILabel!
    
    @IBOutlet weak var CommentInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
