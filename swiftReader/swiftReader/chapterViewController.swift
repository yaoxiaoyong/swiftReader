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

    public var selectedNovelName:String = "";

    public var tableView : UITableView? = UITableView();


    class var sharedInstance : chapterViewController {
        struct Static {
            static let instance : chapterViewController = chapterViewController()
        }
        return Static.instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        selectedNovelName = "武道天心"

        self.tableView?.frame = self.view.frame
        // 设置tableView的数据源
        self.tableView!.dataSource=self
        // 设置tableView的委托
        self.tableView!.delegate = self
        //
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
    }

    func setNovelName(novelName:String){
        selectedNovelName = novelName
    }

    func reloadDataSource(){
        let array:NSArray = chapter.findByCriteria(" WHERE novelName ='\(selectedNovelName)'")
        dataArray = array.sort{($0 as! chapter).chapterName > ($1 as! chapter).chapterName}
        self.tableView!.reloadData()
    }


    //////
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let array:NSArray = chapter.findByCriteria(" WHERE novelName ='\(selectedNovelName)'")
        dataArray = array.sort{($0 as! chapter).chapterName < ($1 as! chapter).chapterName}

        return dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let obj = dataArray[indexPath.row]
        //NSLog("obj=\(obj)")
        cell.textLabel!.text        = obj.chapterTitle
        cell.detailTextLabel?.text  = obj.chapterName
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        NSLog("click af section:\(indexPath.section)  row:\(indexPath.row)")
        let obj = dataArray[indexPath.row] as! chapter
        ReaderViewController.sharedInstance().setNovelNameAndChapter(obj.novelName, chapterNum: indexPath.row)
        //print("\(obj)")
        self.navigationController?.pushViewController(ReaderViewController.sharedInstance(), animated: true)
    }
}
