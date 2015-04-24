//
//  DSImageController.swift
//  Lolita
//
//  Created by Sam on 4/18/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//


import UIKit

class DSImageController: UIViewController {
    
    var index: Int = 0
    var imagePath: String?
    var image: UIImage?
    var placeHolderImage: UIImage?
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    private var mainScroll: DSImageScrollView = DSImageScrollView(frame: CGRectZero)
    private var mainImageView = UIImageView(frame: CGRectZero)
    
    // 图片大小限制
    weak var imageHeight: NSLayoutConstraint?
    weak var imageWidth: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置ScrollView
        mainScroll.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainScroll.maximumZoomScale = 3.0
        view.addSubview(mainScroll)
        let topConstraint = NSLayoutConstraint(item:mainScroll, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item:mainScroll, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let leftConstraint = NSLayoutConstraint(item:mainScroll, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item:mainScroll, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
        view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        mainScroll.backgroundColor = UIColor.blackColor()
        mainScroll.delegate = self
        
        indicator.startAnimating()
        // 配置ImageView
        if image != nil {
            mainImageView.image = image
            indicator.stopAnimating()
        }
//        else if let url = NSURL(string: imagePath ?? "") {
//            let urlRequest = NSURLRequest(URL: url)
//            if let placeHolder = placeHolderImage {
//            } else {
//                mainImageView.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: { [weak self](_, _, finalImage) -> Void in
//                    self?.mainImageView.image = finalImage
//                    self?.indicator.stopAnimating()
//                    self?.updateImageConstraint()
//                    return
//                    }, failure: { [weak self](_, _, _) -> Void in
//                        self?.indicator.stopAnimating()
//                        return
//                    })
//            }
//        }
        
        mainImageView.backgroundColor = UIColor.blackColor()
        mainImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mainImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainScroll.addSubview(mainImageView)
        
        
        let imageLeadingConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mainScroll, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let imageTrailingConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainScroll, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        
        let imageCenterYConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: mainScroll, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        
        let imageWidthConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: UIScreen.mainScreen().bounds.width)
        
        let imageRatio = mainImageView.image != nil ? mainImageView.image!.size.width / mainImageView.image!.size.height : 1.0
        let imageHeightConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: UIScreen.mainScreen().bounds.width / imageRatio)
        
        let imageTopConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainScroll, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        imageTopConstraint.priority = 998.0
        let imageBottomConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainScroll, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        imageBottomConstraint.priority = 998.0
        
        imageWidth = imageWidthConstraint
        imageHeight = imageHeightConstraint
        
        mainScroll.addConstraints([imageLeadingConstraint, imageTrailingConstraint, imageCenterYConstraint, imageWidthConstraint, imageHeightConstraint, imageTopConstraint, imageBottomConstraint])
        
        mainScroll.zoomView = mainImageView
        
        // 配置indicator
        indicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(indicator)
        let indicatorCenterY = NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        let indicatorCenterX = NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        view.addConstraints([indicatorCenterX, indicatorCenterY])
    }
    
    private func updateImageConstraint() {
        if let uimageWidth = imageWidth {
            mainScroll.removeConstraint(uimageWidth)
            let imageWidthConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: UIScreen.mainScreen().bounds.width)
            imageWidth = imageWidthConstraint
            mainScroll.addConstraint(imageWidthConstraint)
        }
        if let uimageHeight = imageHeight {
            mainScroll.removeConstraint(uimageHeight)
            let imageRatio = mainImageView.image != nil ? mainImageView.image!.size.width / mainImageView.image!.size.height : 1.0
            let imageHeightConstraint = NSLayoutConstraint(item: mainImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: UIScreen.mainScreen().bounds.width / imageRatio)
            imageHeight = imageHeightConstraint
            mainScroll.addConstraint(imageHeightConstraint)
        }
        view.layoutIfNeeded()
    }
    
    func doubleTapHandler() {
        let currentZoomScale = mainScroll.zoomScale
        if currentZoomScale < 2.0 {
            mainScroll.setZoomScale(2.0, animated: true)
        } else if currentZoomScale < 3.0 {
            mainScroll.setZoomScale(3.0, animated: true)
        } else {
            mainScroll.setZoomScale(1.0, animated: true)
        }
    }
    
}

extension DSImageController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}