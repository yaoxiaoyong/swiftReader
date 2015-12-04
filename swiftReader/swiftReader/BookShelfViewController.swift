//
//  BookShelfViewController.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

import Alamofire

class BookShelfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotification:", name: "MyMotification", object: nil)
        
    }



    func handleNotification(sender:AnyObject){
        print("call to handle Notification here\(sender)");
        searchViewController.sharedInstance.reloadDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

