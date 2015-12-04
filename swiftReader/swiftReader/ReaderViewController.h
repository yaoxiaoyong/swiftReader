//
//  ReaderViewController.h
//  PageViewControllerDemo
//
//  Created by 姚小勇. on 15/4/12.
//  Copyright (c) 2015年 姚小勇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JKDBModel.h"
#import "JKDBHelper.h"

#import "novel.h"
#import "chapter.h"
#import "searchResult.h"

#import "utils.h"

#import "ReaderViewController.h"
#import "DataViewController.h"


@interface ReaderViewController : UIViewController



+ (instancetype) sharedInstance;

-(void)setNovelNameAndChapter:(NSString*)novelName chapterNum:(NSInteger)chapterNum;




@end
