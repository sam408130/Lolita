//
//  FindCommentCell.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class FindCommentCell: UITableViewCell {

    @IBOutlet weak var avaterImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var userPostInfo: UILabel!
    
    @IBOutlet weak var postTime: UILabel!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
