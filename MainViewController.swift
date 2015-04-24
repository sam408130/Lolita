//
//  MainViewController.swift
//  Lolita
//
//  Created by Sam on 4/6/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit






var rootController: MainViewController!
var rootSideMenu:SideMenuController!

class MainViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initTabBar()

        //发现
        let findStoryBoard = UIStoryboard(name: "Find", bundle: nil)
        let findVC = findStoryBoard.instantiateInitialViewController() as! UIViewController

        rootSideMenu = SideMenuController(nibName: nil, bundle: nil)
        rootSideMenu.rootViewController = findVC
        rootSideMenu.SideView = findStoryBoard.instantiateViewControllerWithIdentifier("SideView") as! UIViewController
        rootSideMenu.tabBarItem.title = "新品"
        rootSideMenu.tabBarItem.image = UIImage(named: "find")
        
        self.addChildViewController(rootSideMenu)
        
        
        //广场
        let squareVC = UIStoryboard(name: "Square", bundle: nil).instantiateInitialViewController() as! UINavigationController
        squareVC.tabBarItem.title = "二手市场"
        squareVC.tabBarItem.image = UIImage(named: "square")
        self.addChildViewController(squareVC)
        
        

        
        //我
        let aboutMeVC = UIStoryboard(name: "AboutMe", bundle: nil).instantiateInitialViewController() as! UINavigationController
        aboutMeVC.tabBarItem.title = "我"
        aboutMeVC.tabBarItem.image = UIImage(named: "me")
        self.addChildViewController(aboutMeVC)
        
        
    }

    
    
    func initTabBar(){
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(12),NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(12),NSForegroundColorAttributeName:UIColor.LolitaThemeDarkText()], forState: UIControlState.Selected)
        
        UITabBar.appearance().barTintColor = UIColor.LolitaTabBarTintColor()
        UITabBar.appearance().tintColor = UIColor.LolitaThemeDarkText()
        
        UIActionSheet.appearance().tintColor = UIColor.LolitaThemeDarkText()
        
    }
    
    
    
//    func showOrhideToolBar(opt:Bool){
//        if opt{
//            UIView.animateWithDuration(0.3, animations: {
//                self.tabBar.hidden = true
//            })
//        }else{
//            UIView.animateWithDuration(0.3, animations: {
//                self.tabBar.hidden = false
//            })
//        }
//    }
    
}
