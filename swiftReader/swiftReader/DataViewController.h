//
//  DataViewController.h
//  PageViewControllerDemo
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (nonatomic,strong) NSString *index;
@property (nonatomic,strong) UIColor *backColor;






-(void)setDataSource:(NSString*)dataString;

-(void)setContainer:(NSTextContainer *)textContainer;

@end
