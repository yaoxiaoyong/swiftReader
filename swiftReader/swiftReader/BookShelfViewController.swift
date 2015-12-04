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

        self.view.backgroundColor = UIColor.purpleColor()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: "MyMotification", object: nil)

        self.collectionview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        self.collectionview.backgroundColor = UIColor.purpleColor()
        self.view.addSubview(self.collectionview)
        self.collectionview.registerClass(BookCell.self, forCellWithReuseIdentifier: "cell")
    }

    func handleNotification(sender:AnyObject){
        print("call to handle Notification here\(sender)");
        searchViewController.sharedInstance.reloadDataSource()
    }

    func reloadDataSource(){
        dataArray = novel.findAll()
        self.collectionview.reloadData()
    }

    // MARK:UICollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        dataArray = novel.findAll()
        return dataArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:BookCell = self.collectionview.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! BookCell
        let book:novel = dataArray[indexPath.row] as! novel
        if(book.novelJPGURL.length == 0){
            cell.imageview.image = UIImage(named: "img0")
        }else{
            cell.imageview.image = UIImage(data: NSData(data: book.novelJPGURL))
        }
        cell.backgroundColor = UIColor.purpleColor()
        cell.label.text = book.novelName
        return cell
    }

    // MARK:UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let book:novel = dataArray[indexPath.row] as! novel
        NSLog("====>\(book.novelName)")
        chapterViewController.sharedInstance.setNovelName(book.novelName)
        self.navigationController?.pushViewController(chapterViewController.sharedInstance, animated: true)

    }

    // MARK:UICollectionViewFlowLayout Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(80, 120)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0
    }
}

