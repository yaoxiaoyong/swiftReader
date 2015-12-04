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

        self.label = UILabel(frame: CGRectMake(self.frame.width-200, self.frame.height-45, 200, 60))
        self.label.textAlignment = NSTextAlignment.Center
        self.label.textColor = UIColor.whiteColor()
        self.label.text = "第\(chapterNum)章     第\(pageNum)页"
        self.addSubview(self.label)

        self.textview = UITextView(frame: self.frame, textContainer: textContrainer)

        self.textview.editable = false
        self.textview.font = UIFont(name: "AppleGothic", size: 20.0)
        self.addSubview(self.textview)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = (touches as NSSet).anyObject()?.location

        print("location=\(p)")
    }
}