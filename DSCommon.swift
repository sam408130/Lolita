//
//  DSCommon.swift
//  Lolita
//
//  Created by Sam on 4/17/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit





class FeedData{
    init(){
        
    }
    var userid : String = "还没起名"
    var username : String = ""
    var feedid : String = ""
    var postImages = [UIImage]()
    var comment = 0
    var star = 0
    var postTime : String = ""
    var postInfo : String = "她什么都没说"
    var avatarImage = UIImage()
    var commentInfo = Array<CommentData>()
}

class CommentData{
    
    var commentUserName : String = ""
    var commentTime : String = ""
    var feedid : String = ""
    var commentInfo : String = ""
    var avatarImage : UIImage = UIImage()
    var receiverName : String = ""
}

class UserInfo{
    var username : String = ""
    var avatarImage = UIImage()
}

class DSCommon : NSObject{
    
    
    class var sharedInstance: DSCommon {
        struct Singleton {
            static let instance = DSCommon()
        }
        return Singleton.instance
    }
    
    
    private enum UserDefaultKeys: String {
        case kWelcomeGuideSkip = "kWelcomeGuideSkip"
        case kUserLogin = "kUserLogin"
        case kUserName = "kUserName"
        case kUserPhone = "kUserPhone"
        
        /// 纪录所在城市id
        case kRegionID = "kRegionID"
        
        // 记录上次访问宠友圈的时间
        case kTwitterLastTime = "kTwitterLastTime"
    }
    
    let rightButtonSize = CGSize(width: 50.0, height: 24.0)
    
    var welcomeGuide: Bool {
        get {
            let userDefault = NSUserDefaults.standardUserDefaults()
            
            if let unwrapped: AnyObject = userDefault.objectForKey(UserDefaultKeys.kWelcomeGuideSkip.rawValue) {
                if (unwrapped.boolValue != nil) && (unwrapped.boolValue!) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        set {
            let userDefault = NSUserDefaults.standardUserDefaults()
            if newValue {
                userDefault.setBool(newValue, forKey: UserDefaultKeys.kWelcomeGuideSkip.rawValue)
                userDefault.synchronize()
            }
        }
    }
    
    /// 用户登录后会返回true
    var userLogin: Bool {
        get {
            let userDefault = NSUserDefaults.standardUserDefaults()
            if let unwrapped: AnyObject = userDefault.objectForKey(UserDefaultKeys.kUserLogin.rawValue) {
                if unwrapped.boolValue! {
                    if let userName: AnyObject = userDefault.objectForKey(UserDefaultKeys.kUserName.rawValue) {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    var userName: String? {
        get {
            let userDefault = NSUserDefaults.standardUserDefaults()
            let name = userDefault.objectForKey(UserDefaultKeys.kUserName.rawValue) as! String?
            return name
        }
    }













}