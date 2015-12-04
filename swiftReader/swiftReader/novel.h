//
//  novel.h
//  JKDBModel
//
//  Created by 姚小勇 on 15/11/30.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "JKDBModel.h"

@interface novel : JKDBModel

@property (nonatomic, copy)     NSString                    *novelName;

@property (nonatomic, copy)     NSString                    *novelIndexURL;

@property (nonatomic, copy)     NSData                      *novelJPGURL;

@property (nonatomic, copy)     NSString                    *novelSummary;
@property (nonatomic, copy)     NSString                    *novelAuthor;


@end
