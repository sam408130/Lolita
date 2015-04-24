//
//  FindCell.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

protocol FindCellDelegate: class {
    func findCellStar(indexPath: NSIndexPath)
    func findCellTitleClicked(indexPath: NSIndexPath)
    func findCellComment(indexPath: NSIndexPath)
    func findCellCare(indexPath: NSIndexPath)
    func findCellExpand(indexPath: NSIndexPath)
    func findCellShare(indexPath: NSIndexPath)
}





class FindCell: UITableViewCell {

    weak var delegate :FindCellDelegate?
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var avaterImage: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var avaterButtonHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var starcountLabel: UILabel!
    @IBOutlet weak var sharecountLable: UILabel!
    @IBOutlet weak var commentcountLabel: UILabel!
   
    @IBAction func starButtonPressed(sender: UIButton) {
        delegate?.findCellStar(indexPath)
    }
    
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        delegate?.findCellShare(indexPath)
    }
    
    
    @IBAction func commentButtonPressed(sender: UIButton) {
        delegate?.findCellComment(indexPath)
    }
    
    
    @IBAction func chatButtonPressed(sender: UIButton) {
    }
    
    var postTime : String?{
        didSet{
            if let pt = postTime{
                postTimeLabel.text = pt
            }
            else{
                postTimeLabel.text = "获取时间失败"
            }
        }
    }
    var postImage : UIImage?{
        didSet{
            if let pImage = postImage{
                postImageView.image = pImage
                let radius = CGFloat(10)
                postImageView.layer.masksToBounds = true
                postImageView.layer.cornerRadius = radius
            }
            else{
                postImageView.image = UIImage(named: "lolita1")
            }
        }
    
    }
    
    var avaterButtonImage : UIImage?{
        didSet{
            if let aImage = avaterButtonImage{
                avaterImage.imageView?.image = aImage
                let radius = min(avaterImage.bounds.width, avaterImage.bounds.height) / 2.0
                avaterImage.layer.masksToBounds = true
                avaterImage.layer.cornerRadius = radius
                
            }
            else{
                avaterImage.imageView?.image = UIImage(named: "image3")
            }
        }
    }
    
    var userDescription : String?{
        didSet{
            if let ud = userDescription{
                descriptionLabel.text = ud
            }
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
           }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
