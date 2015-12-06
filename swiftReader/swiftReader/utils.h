//
//  utils.h
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"



#define CHINESE_CODING              CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
#define CHINESE_CONTENTTYPE         @"application/x-www-form-urlencoded"
#define TEXTHTMLCONTENTTYPE         @"text/html"

#define QINGDISEARCHARTICLENAMEBASE @"http://www.qingdi.com/modules/article/search.php?searchtype=articlename&searchkey="


@interface utils : NSObject






+(NSString*)parseGBKStr:(NSString*)str;

+(TFHpple*)THppleParseWithKey:(NSString*)keyValue;
+(NSString*)ParseWithKey:(NSString*)keyValue;

+(TFHpple*)THppleParseWithURL:(NSString*)url;


+(NSString *)getNovelContentFromChaptrURL:(NSString*)chapterURL;





@end
