//
//  BookShelfViewController.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

import Alamofire

class BookShelfViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionview  = UICollectionView();
    var dataArray       = NSArray();

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: "MyMotification", object: nil)


        let layout = UICollectionViewFlowLayout()
        /*

        allFlowLayout.minimumLineSpacing = lineSpacing;
        */
        layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        layout.minimumInteritemSpacing = 5.0
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)

        self.collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        self.collectionview.dataSource = self

        self.collectionview.delegate = self

        self.view.addSubview(self.collectionview)
        self.collectionview.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        
    }



    func handleNotification(sender:AnyObject){
        print("call to handle Notification here\(sender)");
        searchViewController.sharedInstance.reloadDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 8;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = self.collectionview.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.purpleColor()
        return cell
    }
}

