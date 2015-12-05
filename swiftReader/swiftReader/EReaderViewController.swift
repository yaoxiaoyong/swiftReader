//
//  EReaderViewController.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/4.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

class EReaderViewController: UIViewController ,UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    var pageVC = UIPageViewController();
    var dataArray = NSArray();
    var currentChapter:Int = 0;
    var viewControllers = NSMutableArray()
    var ReadingNovelName:String = NSString() as String
    var textString : String = NSString() as String
    var layoutManager = NSLayoutManager()

    class var sharedInstance : EReaderViewController {
        struct Static {
            static let instance : EReaderViewController = EReaderViewController()
        }
        return Static.instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.tabBarController?.hidesBottomBarWhenPushed = true
        currentChapter = 0
        self.pageVC = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation:.Horizontal, options: [UIPageViewControllerOptionSpineLocationKey:NSNumber(float: 10)])
        self.pageVC.delegate = self;//设置delegate,提供展示相关的信息和接收手势发起的转换的通知
        self.pageVC.dataSource = self;//设置datasource,提供展示的内容
        dataArray = chapter.findByCriteria(" WHERE novelName ='\(self.ReadingNovelName)'")
        let page = self.generateNewContainer(0, layoutManager: layoutManager, textString: textString)
        viewControllers.addObject(page)
        pageVC.setViewControllers([viewControllers.objectAtIndex(0) as! UIViewController], direction: .Forward, animated: true, completion:nil)
        self.addChildViewController(pageVC)
        self.view.addSubview(pageVC.view)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        print("go before")
        let page = self.generateNewContainer(-1, layoutManager: layoutManager, textString: textString)
        return page
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let page = self.generateNewContainer(1, layoutManager: layoutManager, textString: textString)
        return page
    }

    func generateNewContainer(direction:NSInteger, var layoutManager:NSLayoutManager, var textString:String)->UIViewController{
        var textContainer = NSTextContainer(size: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-50))
        layoutManager.addTextContainer(textContainer)
        let range:NSRange = layoutManager.glyphRangeForTextContainer(textContainer)
        var oneChapter  = chapter()
        if(range.length+range.location >= textString.characters.count ){
            if(direction == 1){
                oneChapter = dataArray[currentChapter++] as! chapter
            }else if(direction == -1){
                if(currentChapter == 0){
                    oneChapter = dataArray[currentChapter] as! chapter
                }else{
                    oneChapter = dataArray[currentChapter--] as! chapter
                }
            }else{
                oneChapter = dataArray[currentChapter] as! chapter
            }
            textString = oneChapter.chapterContent
            let storage = NSTextStorage(string: textString)
            layoutManager = NSLayoutManager()
            storage.addLayoutManager(layoutManager)

            textContainer = NSTextContainer(size: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-50))
            layoutManager.addTextContainer(textContainer)
            let range:NSRange = layoutManager.glyphRangeForTextContainer(textContainer)
        }
        let textview = UITextView(frame: CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-50), textContainer: textContainer)
        let page = UIViewController()
        page.view.frame = self.view.frame
        page.view.addSubview(textview)
        viewControllers.addObject(page)
        return page
    }

    func setReadingNovelNameAndChapter(novelName:String, chapterNum:NSInteger){
        self.ReadingNovelName = novelName
        currentChapter = chapterNum
    }

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]){
        self.pageVC.view.userInteractionEnabled = false
    }

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if(finished){
            self.pageVC.view.userInteractionEnabled = true
        }
    }











    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageVC.viewControllers!.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentChapter
    }
}
