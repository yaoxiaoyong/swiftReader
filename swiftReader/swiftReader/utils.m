//
//  utils.m
//  swiftReader
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import "utils.h"



@implementation utils
//static utils *sharedInstance;
//+ (instancetype)sharedInstance
//{
//    static dispatch_once_t DDASLLoggerOnceToken;
//    dispatch_once(&DDASLLoggerOnceToken, ^{
//        sharedInstance = [[[self class] alloc] init];
//    });
//
//    return sharedInstance;
//}

+(NSString*)parseGBKStr:(NSString*)str{
    return [str stringByAddingPercentEscapesUsingEncoding:CHINESE_CODING];
}


+(TFHpple*)THppleParseWithKey:(NSString*)keyValue
{
    NSString *requestURLwithParams = [NSString stringWithFormat:@"%@%@",QINGDISEARCHARTICLENAMEBASE, keyValue];
    //return [self THppleParseWithURL:[requestURLwithParams stringByAddingPercentEscapesUsingEncoding:CHINESE_CODING]];
    return [self THppleParseWithURL:requestURLwithParams];
}

+(TFHpple*)THppleParseWithURL:(NSString*)url{
    NSError *err = nil;
    //NSLog(@"url:%@", url);
    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:CHINESE_CODING]]
                                                    encoding:CHINESE_CODING
                                                       error:&err];
    //NSLog(@"htmlString:%@", htmlString);
    TFHpple *xpathParser = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]];
    return xpathParser;
}

+(NSString *)getNovelContentFromChaptrURL:(NSString*)chapterURL
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"", nil];
    TFHpple *xpathParser = [self THppleParseWithURL:chapterURL];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//div[@class='readerContent']//div[@id='content']"]; // get the title

    for(TFHppleElement *hppleElement in elements){
        for (TFHppleElement* child in hppleElement.children){
            if ([child isTextNode]){
                NSLog(@"child=%@", child);
                [array addObject:child.content];
            }
        }
    }
    NSString *chapterContent = [array componentsJoinedByString:@" "];
    return chapterContent;
}
@end
