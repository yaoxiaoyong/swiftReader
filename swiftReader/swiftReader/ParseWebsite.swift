//
//  ParseWebsite.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

import Alamofire
import Async

class ParseWebsite: NSObject {

    class var sharedInstance : ParseWebsite {
        struct Static {
            static let instance : ParseWebsite = ParseWebsite()
        }
        return Static.instance
    }

    func parseANovelIndex(xpathParser:TFHpple, keyValue:NSString){
        var items = xpathParser.searchWithXPathQuery("//div[@class='articleInfo']")
        print("========>item1=\(items.count)")
        if(items.count == 0){
            //var items1 = xpathParser.searchWithXPathQuery("//div")
            return
        }else{
            var hppleElement  = items[0]
            let novelIndexURL = hppleElement.firstChildWithClassName("articleInfoLeft").firstChildWithTagName("p").firstChildWithTagName("a").objectForKey("href")
            let nodevalue     = hppleElement.firstChildWithClassName("articleInfoLeft").firstChildWithTagName("p").firstChildWithTagName("a").firstChildWithTagName("img").attributes as NSDictionary
            let jpgurl:String = nodevalue.valueForKey("src") as! String

            let novelJPGURL   = NSData(contentsOfURL:NSURL(string: jpgurl)!)

            var novelName     = nodevalue.valueForKey("alt")
            let novelTitle    = nodevalue.valueForKey("title")
            let novelSummary  = hppleElement.firstChildWithClassName("articleInfoRight").firstChildWithTagName("span").firstChildWithTagName("dl").firstChildWithTagName("dd").text()
            let novelAuthor   = hppleElement.firstChildWithClassName("articleInfoRight").firstChildWithTagName("span").firstChildWithTagName("h1").firstChildWithTagName("b").text()

            let result123 = novelName?.rangeOfString(":", options: .LiteralSearch)
            print("====rsult123======>\(result123)")

            if((novelName?.containsString("：")) != nil){
                let array = (novelName?.componentsSeparatedByString("："))! as NSArray
                novelName = array.lastObject as! String
            }
            if((novelName?.containsString(":")) != nil){
                let array = (novelName?.componentsSeparatedByString(":"))! as NSArray
                novelName = array.lastObject as! String
            }
            let result = searchResult()
            result.searchkey        = keyValue as String
            result.novelName        = novelName as! String
            result.novelIndexURL    = novelIndexURL
            result.novelJPGURL      = novelJPGURL
            result.novelSummary     = novelSummary
            result.novelAuthor      = novelAuthor

            NSLog("链接==\(novelIndexURL)")
            NSLog("title==\(novelTitle)");
            //NSLog("封页=\(novelJPGURL)")
            NSLog("书名=\(novelName)")
            NSLog("简介=\(novelSummary)")
            NSLog("作者=\(novelAuthor)")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                result.save()
                NSLog("%@", result)
                dispatch_async(dispatch_get_main_queue(), {
                    print("send a notofication")
                    NSNotificationCenter.defaultCenter().postNotificationName("MyMotification", object: self, userInfo: ["action":"searchOK"])
                })
            })

        }

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func searchWithKey(keyValue:String){
        let array = searchResult.findByCriteria(" WHERE searchkey ='\(keyValue)'") as NSArray
        if(array.count > 0){
            //NSLog("有搜索记录:\(array)")
            dispatch_async(dispatch_get_main_queue(), {
                print("send a notofication")
                NSNotificationCenter.defaultCenter().postNotificationName("MyMotification", object: self, userInfo: ["action":"searchOK"])
                searchViewController.sharedInstance.reloadDataSource()
            })
        }else{
            NSLog("没有搜索记录")
            Alamofire.request(.GET, utils.ParseWithKey(keyValue), parameters: nil).response {
                (request, response, data, error) in
                //print(response)
                let hppleParse = TFHpple(HTMLData: data)
                let array = hppleParse.searchWithXPathQuery("//ul[@class='info']")
                if(array.count > 0){
                    print("有结果，说明吧")
                    for item in array{
                        let urlstr = item.firstChildWithTagName("a").objectForKey("href")
                        let parse = utils.THppleParseWithURL(urlstr)
                        self.parseANovelIndex(parse, keyValue: keyValue)
//                        Alamofire.request(.GET, urlstr, parameters: nil).response {
//                            (request, response, string, error) in
//                            print(urlstr)
//                            print(response)
//                            let parse = TFHpple(HTMLData: data)
//                            self.parseANovelIndex(parse, keyValue: keyValue)
//                        }
                    }
                }
                else{
                    print("没结果，说明吧")
                    self.parseANovelIndex(hppleParse, keyValue: keyValue)
                }

            }

        }
    }

    func downloadNovel(book:novel){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let array = novel.findByCriteria(" WHERE novelName = '\(book.novelName)'")
            if(array.count == 0){
                book.save()
            }
        })

        //let hppleParse : TFHpple =  utils.THppleParseWithURL(book.novelIndexURL)
        Alamofire.request(.GET, book.novelIndexURL, parameters: nil).response {
            (request, response, data, error) in
            let hppleParse = TFHpple(HTMLData: data)
            let array = hppleParse.searchWithXPathQuery("//tr//td//a")

            var downloadNum = 0
            let totalChapterNum = array.count

            Async.background {
                for var index = 0; index < totalChapterNum; index++ {
                    let hppleElement:TFHppleElement = array[index] as! TFHppleElement
                    let chapterName = hppleElement.objectForKey("href")
                    let chapterURL = book.novelIndexURL.stringByReplacingOccurrencesOfString("index.html", withString: chapterName)
                    Alamofire.request(.GET, chapterURL, parameters: nil).response {
                        (request, response, data, error) in

                        downloadNum++

                        let chapterParse: TFHpple = TFHpple.init(HTMLData: data)

                        let elements = chapterParse.searchWithXPathQuery("//div[@class='readerTitle']")
                        if(elements.count == 0){
                            //print("=======1>\(request)-------\(response)")
                            return
                        }else if(elements == nil){
                            //print("=======3>\(data)")
                        }
                        let chapterTitle = elements[0].firstChildWithTagName("h1").text()

                        let contentElement = chapterParse.searchWithXPathQuery("//div[@class='readerContent']//div[@id='content']")
                        if(contentElement.count == 0){
                            print("=======2>\(chapterURL)")
                            return
                        }else if(contentElement == nil){
                            print("=======4>\(chapterURL)")
                        }
                        let array = NSMutableArray()
                        for hppleElement in contentElement{
                            for child in hppleElement.children as NSArray{
                                if (child.isTextNode()){
                                    array.addObject(child.content)
                                }
                            }
                        }
                        let chapterContent = array.componentsJoinedByString(" ")


                        print("\(chapterTitle)-----\(downloadNum)-----\(totalChapterNum)")

                        let oneChapter = chapter()
                        oneChapter.novelName = book.novelName
                        oneChapter.chapterURL = chapterURL
                        oneChapter.chapterName = chapterName
                        oneChapter.chapterTitle = chapterTitle
                        oneChapter.chapterContent = chapterContent
                        let findResult = chapter.findByCriteria(" WHERE chapterName ='\(chapterName)' and novelName = '\(book.novelName)'")
                        if(findResult.count == 0){
                            oneChapter.save()
                        }
                    }
                }
                }.main {
                    print("send a notofication")
                    NSNotificationCenter.defaultCenter().postNotificationName("MyMotification", object: self, userInfo: ["action":"downloadOK"])
            }

        }
    }



}
