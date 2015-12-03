//
//  chapterViewController.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

class chapterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var dataArray : NSArray = NSArray();

    public var selectedNovelNale:String = "";

    public var tableView : UITableView? = UITableView();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.frame = self.view.frame
        // 设置tableView的数据源
        self.tableView!.dataSource=self
        // 设置tableView的委托
        self.tableView!.delegate = self
        //
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
    }

    func reloadDataSource(){
        dataArray = chapter.findByCriteria(" WHERE novelName ='\(selectedNovelNale)'")
        self.tableView!.reloadData()
    }


    //////
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //dataArr = searchResult.findByCriteria(" WHERE searchkey ='\(self.tfSearch?.text)'")
        //dataArr = searchResult.findAll()
        NSLog("111115=\(dataArray.count)")
        return dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let obj = dataArray[indexPath.row]
        //NSLog("obj=\(obj)")
//        cell.textLabel!.text        = obj.novelName
//        cell.detailTextLabel?.text  = obj.novelIndexURL
        return cell;
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        NSLog("click af section:\(indexPath.section)  row:\(indexPath.row)")
//        let obj = dataArray[indexPath.row] as! searchResult
//        let book = novel()
//        book.novelName      = obj.novelName
//        book.novelSummary   = obj.novelSummary
//        book.novelJPGURL    = obj.novelJPGURL
//        book.novelIndexURL  = obj.novelIndexURL
//        book.novelAuthor    = obj.novelAuthor
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            let array = novel.findByCriteria(" WHERE novelName = '\(book.novelName)'")
//            if(array.count == 0){
//                book.save()
//            }
//            NSLog("开始下载")
//            ParseWebsite.sharedInstance.downloadNovel(book)
//        })
    }
}
