//
//  DSImageScrollView.swift
//  Lolita
//
//  Created by Sam on 4/18/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//


import UIKit

class DSImageScrollView: UIScrollView {
    
    weak var zoomView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let zoomView = zoomView {
            let boundsSize = bounds.size
            
            var frameToCenter = zoomView.frame
            
            if frameToCenter.size.width < boundsSize.width {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2.0
            } else {
                frameToCenter.origin.x = 0.0
            }
            
            if frameToCenter.size.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2.0
            } else {
                frameToCenter.origin.y = 0.0
            }
            
            zoomView.frame = frameToCenter
        }
    }
}
