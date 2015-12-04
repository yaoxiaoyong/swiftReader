//
//  ReaderUtils.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/4.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

class ReaderUtils: UIView {
    var label = UILabel()
    var textview = UITextView()
    var textContrainer = NSTextContainer()

    var chapterNum:NSInteger = 0;
    var pageNum : NSInteger  = 0;

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()

        self.textview = UITextView()//(frame: CGRectMake(0, 0, frame.width, frame.height), textContainer: self.textContrainer)

        self.textview.editable = false
        self.textview.textColor = UIColor.purpleColor()
        self.textview.backgroundColor = UIColor.greenColor()
        self.textview.font = UIFont(name: "AppleGothic", size: 20.0)
        self.addSubview(self.textview)
        self.label = UILabel(frame: CGRectMake(200, frame.height-20, 200, 20))
        self.label.textAlignment = NSTextAlignment.Center
        self.label.textColor = UIColor.purpleColor()
        self.label.font = UIFont(name: "AppleGothic", size: 10.0)
        self.label.text = "第\(chapterNum)章     第\(pageNum)页"
        self.addSubview(self.label)
    }
    func setContainer(container:NSTextContainer){
        self.textContrainer = container
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = (touches as NSSet).anyObject()?.location

        print("location=\(p)")
    }
}