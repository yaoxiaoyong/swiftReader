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


    func getHtmlString(urlstr:String){

        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"]).response {
            (request, response, data, error) in
                print(request)
                print(response)
                print(error)
        }

        Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: { (temporaryURL, response) in
            if let directoryURL = NSFileManager.defaultManager()
                .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                    print(response)
//                    let pathComponent = response.suggestedFilename
//
//                    return directoryURL.URLByAppendingPathComponent(pathComponent!)
                }

            return temporaryURL
        })
    }
}
