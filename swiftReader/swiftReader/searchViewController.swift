//
//  searchViewController.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    //数据源
    var  dataArr = NSArray();
    //声明tableView
    public var tableView :UITableView? = UITableView();
    
    var tfSearch :UITextField? = UITextField();

    class var sharedInstance : searchViewController {
        struct Static {
            static let instance : searchViewController = searchViewController()
        }
        return Static.instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.tfSearch?.frame  = CGRectMake(0, 30, self.view.frame.size.width, 30)
        self.tfSearch?.placeholder = "请输入搜索关键字"
        self.tfSearch?.text = "魔"
        self.tfSearch?.delegate = self
        self.tfSearch?.keyboardType = UIKeyboardType.WebSearch
        self.tfSearch?.backgroundColor = UIColor.lightGrayColor()

        self.view.addSubview(self.tfSearch!)

        //self.tableView = UITableView(frame: CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.height-60), style:UITableViewStyle.Plain)
        self.tableView?.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.height-60)
        // 设置tableView的数据源
        self.tableView!.dataSource=self
        // 设置tableView的委托
        self.tableView!.delegate = self
        //
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadDataSource(){
        NSLog("tfSearch?.text=%@", (tfSearch?.text)!)
        dataArr = searchResult.findByCriteria(" WHERE searchkey ='\((tfSearch?.text)!)'")
        self.tableView!.reloadData()
    }


    //////
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        NSLog("111115=\(dataArr.count)")
        return dataArr.count
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let obj = dataArr[indexPath.row]
        //NSLog("obj=\(obj)")
        cell.textLabel!.text        = obj.novelName
        cell.detailTextLabel?.text  = obj.novelIndexURL
        cell.imageView!.image = UIImage(named:"green.png")
        return cell;
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        NSLog("click af section:\(indexPath.section)  row:\(indexPath.row)")
        let obj = dataArr[indexPath.row] as! searchResult
        let book = novel()
        book.novelName      = obj.novelName
        book.novelSummary   = obj.novelSummary
        book.novelJPGURL    = obj.novelJPGURL
        book.novelIndexURL  = obj.novelIndexURL
        book.novelAuthor    = obj.novelAuthor

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let array = novel.findByCriteria(" WHERE novelName = '\(book.novelName)'")
            if(array.count == 0){
                book.save()
            }
            NSLog("开始下载")
            ParseWebsite.sharedInstance.downloadNovel(book)
        })
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.tfSearch?.resignFirstResponder()
        print("text ========= \(textField.text!)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            ParseWebsite.sharedInstance.searchWithKey(textField.text!)
        })
        return true
    }
}
