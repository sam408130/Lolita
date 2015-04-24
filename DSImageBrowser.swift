//
//  DSImageBrowser.swift
//  Lolita
//
//  Created by Sam on 4/20/15.
//  Copyright (c) 2015 Ding Sai. All rights reserved.
//

import Foundation
import UIKit

class DSImageBrowser: UIPageViewController {
    
    /// 如果没有设置，默认为切换导航栏显示
    func setSingleTapHandler(handler:(() -> Void)?) {
        singleTapHandler = handler
    }
    private var singleTapHandler: (Void -> Void)?
    
    /// 导航栏右侧按钮样式，默认为没有
    func setRightButton(#image: UIImage?, title: String?, handler:((index: Int) -> Void)?) {
        rightButtonHandler = handler
        rightButtonImage = image
        rightButtonTitle = title
    }
    private var rightButtonHandler: ((Int) -> Void)?
    private var rightButtonImage: UIImage?
    private var rightButtonTitle: String?
    
    var imageDataSource: DSImageBrowserDataSource?
    
    var startIndex: Int = 0
    
    private var DSNavigation: UINavigationController!
    
    init() {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonPressed:")
        
        dataSource = self
        delegate = self

        
        
        if let imageDataSource = imageDataSource {
            let imageCount = imageDataSource.numberOfImagesInDSImageBrowser(self)
            assert(startIndex < imageCount, "图片index必须要小于图片数量，请调用之前检查图片数量。")
            let firstPage = DSImageController()
            firstPage.index = startIndex
            firstPage.image = imageDataSource.dsImageBrowser(self, pathForIndex: startIndex)
            firstPage.image = imageDataSource.dsImageBrowser(self, imageForIndex: startIndex)
            setViewControllers([firstPage], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            navigationItem.title = navigationTitle()
        }
        
        // 添加手势
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "doubleTapHandler:")
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "singleTapHandler:")
        tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
        view.addGestureRecognizer(tapGesture)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func cancelButtonPressed(sender: AnyObject) {
        hide()
    }
    
    func doubleTapHandler(sender: AnyObject) {
        if let currentPage = viewControllers.first as? DSImageController {
            currentPage.doubleTapHandler()
        }
    }
    
    func singleTapHandler(sender: AnyObject) {
        if let handler = singleTapHandler {
            handler()
            return
        }
        if let navigationHidden = navigationController?.navigationBarHidden {
            navigationController?.setNavigationBarHidden(!navigationHidden, animated: true)
        }
    }
    
    private func navigationTitle() -> String {
        if let currentPage = viewControllers.first as? DSImageController {
            if let DSDataSource = imageDataSource {
                return DSDataSource.dsImageBrowser(self, titleForIndex: currentPage.index) ?? "\(currentPage.index + 1)/\(DSDataSource.numberOfImagesInDSImageBrowser(self))"
            }
        }
        return ""
    }
    
    func hide() {
        navigationController?.dismissViewControllerAnimated(false, completion: nil)
        DSNavigation = nil
    }
    
    func show() {
        DSNavigation = UINavigationController(rootViewController: self)
        UIApplication.sharedApplication().delegate?.window??.rootViewController?.presentViewController(DSNavigation, animated: false
            , completion: nil)
        if let handler = rightButtonHandler {
            var rightButton: UIBarButtonItem!
            if let image = rightButtonImage {
                rightButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "rightButtonHandler:")
            } else if let title = rightButtonTitle {
                rightButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: "rightButtonHandler:")
            } else {
                rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "rightButtonHandler:")
            }
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func rightButtonHandler(sender: AnyObject) {
        if let handler = rightButtonHandler {
            if let currentController = viewControllers.first as? DSImageController {
                handler(currentController.index)
            }
        }
    }
    
    func reloadData() {
        var currentIndex = 0
        if let currentController = viewControllers.first as? DSImageController {
            currentIndex = currentController.index
        }
        if let DSDataSource = imageDataSource {
            let totalCount = DSDataSource.numberOfImagesInDSImageBrowser(self)
            if totalCount <= 0 {
                hide()
                return
            }
            if currentIndex > totalCount - 1 {
                currentIndex = totalCount - 1
            }
            let newPage = DSImageController()
            newPage.index = currentIndex
            newPage.image = DSDataSource.dsImageBrowser(self, pathForIndex: newPage.index)
            newPage.image = DSDataSource.dsImageBrowser(self, imageForIndex: newPage.index)
            setViewControllers([newPage], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        navigationItem.title = navigationTitle()
    }
    
    deinit{
        println("de init called")
    }
}

extension DSImageBrowser: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let currentController = viewController as? DSImageController {
            if currentController.index <= 0 {
                return nil
            } else {
                if let DSDataSource = imageDataSource {
                    let previous = DSImageController()
                    previous.index = currentController.index - 1
                    previous.image = DSDataSource.dsImageBrowser(self, pathForIndex: previous.index)
                    previous.image = DSDataSource.dsImageBrowser(self, imageForIndex: previous.index)
                    return previous
                } else {
                    return nil
                }
            }
        }
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let currentController = viewController as? DSImageController {
            if let DSDataSource = imageDataSource {
                if currentController.index >= DSDataSource.numberOfImagesInDSImageBrowser(self) - 1 {
                    return nil
                } else {
                    let next = DSImageController()
                    next.index = currentController.index + 1
                    next.image = DSDataSource.dsImageBrowser(self, pathForIndex: next.index)
                    next.image = DSDataSource.dsImageBrowser(self, imageForIndex: next.index)
                    return next
                }
            } else {
                return nil
            }
        }
        return nil
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if let currentController = pageViewController.viewControllers.first as? DSImageController {
            if let DSDataSource = imageDataSource {
                navigationItem.title = navigationTitle()
            }
        }
    }
}

protocol DSImageBrowserDataSource {
    func numberOfImagesInDSImageBrowser(dsImageBrowser: DSImageBrowser) -> Int
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, pathForIndex pathIndex: Int) -> UIImage?
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, imageForIndex imageIndex: Int) -> UIImage?
    func dsImageBrowser(dsImageBrowser: DSImageBrowser, titleForIndex titleIndex: Int) -> String?
}
