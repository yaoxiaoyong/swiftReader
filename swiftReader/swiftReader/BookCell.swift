//
//  BookCell.swift
//  swiftReader
//
//  Created by 姚小勇 on 15/12/4.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {

    var imageview = UIImageView()
    var label = UILabel()

    convenience   required   init(coder : NSCoder){
        self.init(frame:CGRect(x: 0, y: 0, width: 80, height: 120))
    }

    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.imageview = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20))
        self.addSubview(self.imageview)

        self.label = UILabel(frame: CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20))
        self.label.textAlignment = NSTextAlignment.Center
        self.label.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(self.label)

    }
}
