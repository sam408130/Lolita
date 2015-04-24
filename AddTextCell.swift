//
//  AddTextCell.swift
//  Lolita
//
//  Created by Sam on 4/20/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class AddTextCell: UITableViewCell {

    
    @IBOutlet weak var textView: UITextView!
    
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
extension AddTextCell: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
