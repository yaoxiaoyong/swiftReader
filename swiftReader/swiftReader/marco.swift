//
//  marco.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit
import Alamofire

let OBJ_NovelName           = "novelName"
let OBJ_NovelIndexURL       = "novelIndexURL"
let OBJ_NovelJPGURL         = "novelJPGURL"
let OBJ_NovelSummary        = "novelSummary"
let OBJ_NovelAuthor         = "novelAuthor"

let OBJ_ChapterName         = "chapterName"
let OBJ_ChapterTitle        = "chapterTitle"
let OBJ_ChapterURL          = "chapterURL"

class marco: NSObject {
    func dlog() {
        print("file:\(__FILE__), line:\(__LINE__)")
    }


    class func getHtmlString(key:String){
        Alamofire.request(.GET, utils.ParseWithKey(key), parameters: nil).response {
            (request, response, string, error) in
                print(request)
                print(response)
                print(error)
            print(string)
        }
    }
}
