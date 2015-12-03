//
//  chapter.h
//  JKDBModel
//
//  Created by 姚小勇 on 15/11/30.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "JKDBModel.h"

@interface chapter : JKDBModel
@property (nonatomic, copy)     NSString                    *novelName;

@property (nonatomic, copy)     NSString                    *chapterName;

@property (nonatomic, copy)     NSString                    *chapterURL;

@property (nonatomic, copy)     NSString                    *chapterTitle;

@property (nonatomic, copy)  NSString                     *chapterContent;

@end
