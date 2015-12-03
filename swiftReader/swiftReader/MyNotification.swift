//
//  MyNotification.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

class MyNotification: NSObject {




    func registerNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameOver:", name: "gameOverNotification", object: nil)
    }

    func postNotification(searchKey:String){
        let dic:[String:Int]=["key":123, "key1":124]
        NSNotificationCenter.defaultCenter().postNotificationName("gameOverNotification", object: "title", userInfo: dic)
    }
}
