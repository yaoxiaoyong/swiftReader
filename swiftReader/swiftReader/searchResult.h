//
//  searchResult.h
//  EReader
//
//  Created by 姚小勇 on 15/11/30.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import "JKDBModel.h"

@interface searchResult : JKDBModel

@property (nonatomic, copy)     NSString                    *searchkey;

@property (nonatomic, copy)     NSString                    *novelName;

@property (nonatomic, copy)     NSString                    *novelIndexURL;

@property (nonatomic, copy)     NSData                      *novelJPGURL;

@property (nonatomic, copy)     NSString                    *novelSummary;
@property (nonatomic, copy)     NSString                    *novelAuthor;



@end
