//
//  LeftViewController.h
//  test123
//
//  Created by kf1 on 14-9-20.
//  Copyright (c) 2014年 kf1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
@public
    UITableView     *tableview;
    NSMutableArray  *menuArray;
}

@end
