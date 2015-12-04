//
//  BookShelfViewController.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

import Alamofire

class BookShelfViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionview  = UICollectionView(frame: CGRectMake(0, 0, 320, 480), collectionViewLayout: UICollectionViewFlowLayout());

    var dataArray       = NSArray();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: "MyMotification", object: nil)


        self.collectionview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.collectionview.dataSource = self

        self.collectionview.delegate = self

        self.view.addSubview(self.collectionview)
        self.collectionview.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    func handleNotification(sender:AnyObject){
        print("call to handle Notification here\(sender)");
        searchViewController.sharedInstance.reloadDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 8;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = self.collectionview.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.purpleColor()
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        NSLog("====>")
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(80, 120)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 5, 5, 5)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5.0
    }
}

