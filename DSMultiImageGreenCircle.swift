//
//  DSMultiImageGreenCircle.swift
//  Lolita
//
//  Created by Sam on 4/20/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class DSMultiImageGreenCircle: UIView {

    var number: Int = 0 {
        didSet {
            numberLabel.text = "\(number)"
            if number == 0 {
                hidden = true
            } else {
                hidden = false
            }
        }
    }
    
    private weak var numberLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 圆圈背景
        let circleImageView = UIImageView(image: UIImage(named: DSMultiImageGreenCircleImage))
        circleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(circleImageView)
        let imageCenterX = NSLayoutConstraint(item: circleImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        let imageCenterY = NSLayoutConstraint(item: circleImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        addConstraints([imageCenterX, imageCenterY])
        
        // 数字
        let myNumberLabel = UILabel()
        myNumberLabel.textColor = UIColor.whiteColor()
        myNumberLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        let labelCenterX = NSLayoutConstraint(item: myNumberLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: circleImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        let labelCenterY = NSLayoutConstraint(item: myNumberLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: circleImageView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        addSubview(myNumberLabel)
        addConstraints([labelCenterX, labelCenterY])
        myNumberLabel.text = "\(number)"
        
        numberLabel = myNumberLabel
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    deinit {
        println("green circle deinit")
    }
    
}

