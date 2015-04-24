//
//  SideMenuController.swift
//  Lolita
//
//  Created by Sam on 4/6/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController ,UIGestureRecognizerDelegate{

    var _needSwipeShowMenu:Bool!
    var needSwipeShowMenu:Bool!{
        set{
            self._needSwipeShowMenu = newValue
            if newValue == true {
                self.view.addGestureRecognizer(self.panGestureRecognizer)
            }else{
                self.view.removeGestureRecognizer(self.panGestureRecognizer)
            }
        }
        get{
            return self._needSwipeShowMenu
        }
    }
    
    var _leftViewController:UIViewController!
    var SideView:UIViewController!{
        get{
            return self._leftViewController
        }
        set{
            if self.SideView != newValue{
                self._leftViewController = newValue
                self._leftViewController.view.frame = self.view.bounds
                self.view.insertSubview(self._leftViewController.view, atIndex: 1)
            }
        }
    }
    
    var _rootViewController:UIViewController!
    var rootViewController:UIViewController!{
        get{
            return self._rootViewController
        }
        set{
            if self.rootViewController != newValue{
                self._rootViewController = newValue
                self._rootViewController.view.frame = self.view.bounds
                self.view.addSubview(self._rootViewController.view)
            }
        }
    }
    
    var leftViewShowWidth:CGFloat!
    
    var animationDuration:NSTimeInterval!
    var showBoundsShadow:Bool!
    
    var panGestureRecognizer:UIPanGestureRecognizer!
    
    var startPanPoint:CGPoint!
    var lastPanPoint:CGPoint!
    var panMovingRightOrLeft:Bool!//true是向右，false是向左
    
    var coverButton:UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initData()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initData(){
        self.leftViewShowWidth = 267
        self.animationDuration = 0.35
        self.showBoundsShadow = true
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target:self,action:"pan:")
        self.panGestureRecognizer.delegate = self
        
        self.panMovingRightOrLeft = false
        self.lastPanPoint = CGPointZero
        self.coverButton = UIButton(frame:CGRect(origin: CGPoint(), size: UIScreen.mainScreen().bounds.size))
        self.coverButton.addTarget(self,action:"hideSideViewController", forControlEvents:UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:1,green:1,blue:1,alpha:1)
        var image = UIImageView(image: UIImage(named: "find"))
        self.view.insertSubview(image, atIndex: 0)
        self.needSwipeShowMenu = true
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
        self.hidesBottomBarWhenPushed = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func showShadow(show:Bool){
        self.rootViewController.view.layer.shadowOpacity    = show ? 0.8 : 0.0
        if show {
            self.rootViewController.view.layer.cornerRadius = 4.0
            self.rootViewController.view.layer.shadowOffset = CGSizeZero
            self.rootViewController.view.layer.shadowRadius = 4.0
            self.rootViewController.view.layer.shadowPath   = UIBezierPath(rect:self.rootViewController.view.bounds).CGPath;
        }
    }
    
    func showLeftViewController(animated:Bool){
        //rootController.showOrhideToolBar(false)
        if (self.SideView == nil) {
            return
        }
        var animatedTime:CGFloat = 0
        if animated {
            animatedTime = abs(self.leftViewShowWidth - self.rootViewController.view.frame.origin.x) / CGFloat(self.leftViewShowWidth) * CGFloat(self.animationDuration)
        }
        UIView.animateWithDuration(NSTimeInterval(animatedTime), delay: 0.0, options:UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.layoutCurrentViewWithOffset(self.leftViewShowWidth)
            self.rootViewController.view.addSubview(self.coverButton)
            self.showShadow(self.showBoundsShadow)
            }, completion: {(_)->Void in
                
        })
    }
    
    
    func hideSideViewController(animated:Bool){
        //rootController.showOrhideToolBar(true)
        self.showShadow(false)
        var animatedTime:CGFloat = 0
        if (animated) {
            animatedTime = abs(self.rootViewController.view.frame.origin.x / self.leftViewShowWidth) * CGFloat(self.animationDuration)
        }
        
        UIView.animateWithDuration(NSTimeInterval(animatedTime), delay: 0.0, options:UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.layoutCurrentViewWithOffset(0)
            }, completion: {(_)->Void in
                self.coverButton.removeFromSuperview()
        })
    }
    
    func hideSideViewController(){
        self.hideSideViewController(true)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if gestureRecognizer == self.panGestureRecognizer {
            var panGesture = gestureRecognizer as! UIPanGestureRecognizer
            var translation = panGesture.translationInView(self.view)
            if panGesture.velocityInView(self.view).x < 600 && abs(translation.x)/abs(translation.y)>1 {
                return true
            }
            return false
        }
        return true
    }
    
    func pan(pan:UIPanGestureRecognizer){
        if self.panGestureRecognizer.state == UIGestureRecognizerState.Began {
            //rootController.showOrhideToolBar(false)
            self.startPanPoint = self.rootViewController.view.frame.origin
            if self.rootViewController.view.frame.origin.x == 0 {
                self.showShadow(self.showBoundsShadow)
            }
            return
        }
        var currentPostion = pan.translationInView(self.view)
        var xoffset = self.startPanPoint.x + currentPostion.x
        if (xoffset>0) {//向右滑
            if (self.SideView != nil)  {
                if (self.SideView.view.superview != nil){
                    xoffset = xoffset>self.leftViewShowWidth ? self.leftViewShowWidth : xoffset
                }
            }else{
                xoffset = 0
            }
        }else if xoffset<0 {//向左滑
            xoffset = 0
        }
        if xoffset != self.rootViewController.view.frame.origin.x {
            self.layoutCurrentViewWithOffset(xoffset)
        }
        if self.panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if (self.rootViewController.view.frame.origin.x != 0 && self.rootViewController.view.frame.origin.x != self.leftViewShowWidth ) {
                if((self.startPanPoint.x < currentPostion.x)&&self.rootViewController.view.frame.origin.x>20){
                    self.showLeftViewController(true)
                }else{
                    self.hideSideViewController()
                }
            }else if self.rootViewController.view.frame.origin.x == 0 {
                self.showShadow(false)
            }
            self.lastPanPoint = CGPointZero
        }else{
            var velocity = pan.velocityInView(self.view)
            if velocity.x > 0 {
                self.panMovingRightOrLeft = true
            }else if velocity.x < 0 {
                self.panMovingRightOrLeft = false
            }
        }
    }
    
    func layoutCurrentViewWithOffset(xoffset:CGFloat){
        if (self.showBoundsShadow != nil) {
            self.rootViewController.view.layer.shadowPath = UIBezierPath(rect:self.rootViewController.view.bounds).CGPath
        }
        var scale = abs(600 - abs(xoffset)) / 600
        scale = max(0.8, scale)
        self.rootViewController.view.transform = CGAffineTransformMakeScale(CGFloat(scale), CGFloat(scale))
        
        var totalWidth:CGFloat = self.view.frame.size.width
        var totalHeight:CGFloat = self.view.frame.size.height
        if xoffset > 0  {//向右滑的
            self.rootViewController.view.frame = CGRectMake(xoffset,self.view.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale)
        }else{//向左滑的
            self.rootViewController.view.frame = CGRectMake(self.view.frame.size.width * (1 - scale) + xoffset, self.view.bounds.origin.y + (totalHeight*(1 - scale) / 2), totalWidth * scale, totalHeight * scale)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
