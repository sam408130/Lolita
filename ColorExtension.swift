//
//  ColorExtension.swift
//  Lolita
//
//  Created by Sam on 4/6/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import UIKit


extension UIColor{
    
    
    //TabBar背景颜色
    class func LolitaTabBarTintColor() ->UIColor{
        return UIColor(white: 80.0/255.0, alpha: 1.0)
    }
    
    //主题颜色-浅蓝色
    class func LolitaThemeColor() -> UIColor{
        return UIColor(red: 142.0/255.0, green: 197.0/255.0, blue: 223.0/255.0, alpha: 1.0)
    }
    
    //文字颜色-深蓝
    class func LolitaThemeDarkText() -> UIColor{
        return UIColor(red: 88.0/255.0, green: 158.0/255.0, blue:190.0/255.0 , alpha: 1.0)
    }
    
    //主题橘红色
    class func LolitaThemeOrange() -> UIColor{
        return UIColor(red: 254.0/255.0, green: 148.0/255.0, blue: 127.0/255.0, alpha: 1.0)
    }
    
    //列表区分颜色（浅蓝）

    class func LolitaTableLightBlue() -> UIColor {
        return UIColor(red: 228.0/255.0, green: 247.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    }
    
    //列表区分颜色（浅灰）

    class func LolitaTableLightGray() -> UIColor {
        //        return UIColor(white: 236.0/255.0, alpha: 1.0)
        return UIColor.whiteColor()
    }
}



extension String {

    
    func toAge() -> String {
        switch self {
        case "0":
            return "小于1岁"
        case "11":
            return "大于10岁"
        default:
            return "\(self)岁"
        }
    }
    
    func bridgeToObjectiveC() -> NSString {
        return self as NSString
    }
    
    func toTwitterDeltaTime() -> String {
        let current = NSDate()
        let strDate = NSDate(timeIntervalSince1970: self.bridgeToObjectiveC().doubleValue)
        
        let delta = current.timeIntervalSinceDate(strDate)
        if delta <= 60 {
            return "刚刚"
        } else if delta < 3600 {
            return "\(Int(delta/60.0))分钟前"
        } else if delta < 86400 {
            return "\(Int(delta/3600.0))小时前"
        } else {
            return "\(Int(delta/86400.0))天前"
        }
    }
    
    func toTwitterCalendar() -> NSAttributedString {
        let strDate = NSDate(timeIntervalSince1970: self.bridgeToObjectiveC().doubleValue)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.stringFromDate(strDate)
        let month = dateString.substringToIndex(advance(dateString.startIndex, 2))
        let day = dateString.substringFromIndex(advance(dateString.startIndex, 2))
        
        let map = [
            "01": "一月",
            "02": "二月",
            "03": "三月",
            "04": "四月",
            "05": "五月",
            "06": "六月",
            "07": "七月",
            "08": "八月",
            "09": "九月",
            "10": "十月",
            "11": "十一月",
            "12": "十二月",
        ]
        let monthString = map[month] ?? ""
        
        var aString = NSMutableAttributedString(string: "\(day)日\(monthString)")
        aString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17.0), range: NSRange(location: 0, length: 2))
        let range = (aString.string as NSString).rangeOfString(monthString)
        aString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10.0), range: range)
        return aString
    }
}


extension UIImageView {
    func roundCorner() {
        let radius = min(self.bounds.width, self.bounds.height) / 2.0
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}


extension UIImage {
    func imageOrientationUp() -> UIImage {
        if imageOrientation == UIImageOrientation.Up {
            return self
        }
        
        var transform = CGAffineTransformIdentity
        
        // 计算如何能把图片调整为向上的状态，一共需要2步
        // 1. 如果是Left/Right/Down 需要旋转方向
        // 2. 如果是Mirrored 需要轴对称翻转
        switch imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        default:
            break
        }
        
        switch imageOrientation {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
        default:
            break
        }
        
        //        let context = CGBitmapContextCreate(nil, UInt(size.width), UInt(size.height),
        //            CGImageGetBitsPerComponent(self.CGImage), 0,
        //            CGImageGetColorSpace(self.CGImage),
        //            CGImageGetBitmapInfo(self.CGImage))
        
        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage))
        
        CGContextConcatCTM(context, transform)
        
        switch imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: size.height, height: size.width)), CGImage)
        default:
            CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: size.width, height: size.height)), CGImage)
        }
        
        let fixedCGImage = CGBitmapContextCreateImage(context)
        let image = UIImage(CGImage: fixedCGImage)!
        
        return image
    }
}


extension UIViewController{
    

    func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    func addRightButton(buttonTitle: String, action: Selector) {
        self.navigationItem.rightBarButtonItem = nil
        let doneButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 50.0, height: 24.0)))
        doneButton.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor.LolitaThemeDarkText()
        let doneString = NSAttributedString(string: buttonTitle, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
        doneButton.setAttributedTitle(doneString, forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.layer.cornerRadius = 4.0
        let rightItem = UIBarButtonItem(customView: doneButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func alert(message: String) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    func alertWithDelegate(message: String, tag: Int, delegate: UIAlertViewDelegate?) {
        let alert = UIAlertView(title: nil, message: message, delegate: delegate, cancelButtonTitle: "确定")
        alert.tag = tag
        alert.show()
    }
}

