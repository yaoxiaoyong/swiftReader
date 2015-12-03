//
//  ParseWebSite.m
//  EReader
//
//  Created by 姚小勇 on 15/11/29.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import "ParseWebSite.h"
#import "TFHpple.h"


@implementation ParseWebSite
static ParseWebSite *instance;
+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//////////////////////////////////////////////////////////////////////////////////
-(TFHpple*)THppleParseURL:(NSString*)keyValue
{
    NSString *requestURLwithParams = [NSString stringWithFormat:@"%@%@",QINGDISEARCHARTICLENAMEBASE, keyValue];

    NSURL *url = [NSURL URLWithString:[requestURLwithParams stringByAddingPercentEscapesUsingEncoding:CHINESE_CODING]];
    //NSLog(@"url1=%@",url);
    NSError *err = nil;

    NSString *htmlString = [NSString stringWithContentsOfURL:url
                                                    encoding:CHINESE_CODING
                                                       error:&err];
    //NSLog(@"htmlString:%@", htmlString);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]];
    return xpathParser;
}

-(void)parseANovelIndex:(TFHpple *)xpathParser key:(NSString*)keyValue{
    NSArray *items = [xpathParser searchWithXPathQuery:@"//div[@class='articleInfo']"];
    if(items.count == 0){
        return;
    }
    TFHppleElement *hppleElement = items[0];
    NSString *novelIndexURL     = [[[[hppleElement firstChildWithClassName:@"articleInfoLeft"] firstChildWithTagName:@"p"] firstChildWithTagName:@"a"] objectForKey:@"href"];
    NSString *novelIndexJPGURL  = [[[[[[hppleElement firstChildWithClassName:@"articleInfoLeft"] firstChildWithTagName:@"p"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"] attributes] objectForKey:@"src"];
    NSString *novelName         = [[[[[[hppleElement firstChildWithClassName:@"articleInfoLeft"] firstChildWithTagName:@"p"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"] attributes] objectForKey:@"alt"];
    NSString *novelRitle        = [[[[[[hppleElement firstChildWithClassName:@"articleInfoLeft"] firstChildWithTagName:@"p"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"] attributes] objectForKey:@"title"];
    NSString *novelSummary      = [[[[[hppleElement firstChildWithClassName:@"articleInfoRight"] firstChildWithTagName:@"span"] firstChildWithTagName:@"dl"] firstChildWithTagName:@"dd"] text];
    NSString *novelAuthor       = [[[[[hppleElement firstChildWithClassName:@"articleInfoRight"] firstChildWithTagName:@"span"] firstChildWithTagName:@"h1"] firstChildWithTagName:@"b"] text];
    NSMutableArray *array = [NSMutableArray array];
    //NSLog(@"书名000=%@",     novelName);
    if([novelName containsString:@"："]){
        array = [novelName componentsSeparatedByString:@"："];
    }else{
        array = [novelName componentsSeparatedByString:@":"];
    }
    novelName = [array lastObject];

    if([novelAuthor containsString:@"："]){
        array = [novelAuthor componentsSeparatedByString:@"："];
    }else{
        array = [novelAuthor componentsSeparatedByString:@":"];
    }
    novelAuthor = [array lastObject];

//    NSLog(@"链接==%@",    novelIndexURL);
//    NSLog(@"封页=%@",     novelIndexJPGURL);
//    NSLog(@"书名=%@",     novelName);
//    NSLog(@"标题=%@",     novelRitle);
//    NSLog(@"简介=%@",     novelSummary);
//    NSLog(@"作者=%@",     novelAuthor);
    NSLog(@"================================================================");

    searchResult *result = [[searchResult alloc]init];
    result.searchkey = keyValue;
    result.novelName = novelName;
    result.novelIndexURL = novelIndexURL;
    result.novelJPGURL = novelIndexJPGURL;
    result.novelAuthor = novelAuthor;
    result.novelSummary = novelSummary;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [searchResult findByCriteria:[NSString stringWithFormat:@" WHERE searchkey ='%@' and novelName = '%@'", keyValue, novelName]];
        if(array.count > 0)
        {
            DDLog();
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLog();
                [[searchViewController sharedInstance] reloadDataSource];
            });
        }else{
            DDLog(@"save searchResult");
            [result save];
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLog();
                [[searchViewController sharedInstance] reloadDataSource];
            });

        }
    });
}

//////////////////////////////////////////////////////////////////////////////////
-(void)searchWithKey:(NSString*)keyValue
      withReturnValueHandleBlock: (ReturnValueHandleBlock)returnHandleBlock
            withErrorHandleBlock: (ErrorHandleBlock)errorHandleBlock
          withFailureHandleBlock: (FailureHandleBlock)failureHandleBlock
{
    [[NSUserDefaults standardUserDefaults] setObject:keyValue forKey:@"searchkey"];
    NSMutableArray *searchResultArray = [NSMutableArray array];
    NSArray *array = [searchResult findByCriteria:[NSString stringWithFormat:@" WHERE searchkey ='%@'", keyValue]];
    if(array.count > 0){
        DDLog(@"有搜索记录");
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLog();
            [[searchViewController sharedInstance] reloadDataSource];
        });
    }else{
        TFHpple *xpathParser = [self THppleParseURL:keyValue];

        NSArray *items = [NSMutableArray array];
        DDLog();
        items = [xpathParser searchWithXPathQuery:@"//ul[@class='info']"];
        if([items count] > 0){
            DDLog();
            for(TFHppleElement *hppleElement in items){
                NSError *err = nil;
                DDLog();
                NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[[hppleElement firstChildWithTagName:@"a"] objectForKey:@"href"]]
                                                                encoding:CHINESE_CODING
                                                                   error:&err];
                //NSLog(@"htmlString:%@", htmlString);
                TFHpple *xpathParser2 = [[TFHpple alloc] initWithHTMLData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]];
                [self parseANovelIndex:xpathParser2 key:keyValue];

            }
        }else{
            DDLog();
            [self parseANovelIndex:xpathParser key:keyValue];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////
-(void) downloadNovel:(NSDictionary*)dic{
    NSError *err = nil;
    NSString *novelName     =   [dic valueForKey:OBJ_NOVELNAME];
    NSString *novelIndexURL =   [dic valueForKey:OBJ_NOVELINDEXURL];

    novel *book             =   [[novel alloc]init];
    book.novelName          =   novelName;
    book.novelIndexURL      =   [dic valueForKey:OBJ_NOVELINDEXURL];
    book.novelSummary       =   [dic valueForKey:NOVELSUMMARY];
    book.novelJPGURL        =   [dic valueForKey:OBJ_NOVELJPGURL];
    book.novelAuthor        =   [dic valueForKey:OBJ_NOVELAUTHOR];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [book save];
        NSArray *array = [novel findByCriteria:[NSString stringWithFormat:@" WHERE novelName = '%@'", novelName]];
        if(array.count > 0){
        }else{
            DDLog(@"save novel");
            [book save];
        }
    });

    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:novelIndexURL]
                                                    encoding:CHINESE_CODING
                                                       error:&err];
    //NSLog(@"htmlString:%@", htmlString);

    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding]];

    NSArray *data                    = [xpathParser searchWithXPathQuery:@"//tr//td//a"];
    NSLog(@"[data.count]=%lu", (unsigned long)data.count);
    NSInteger __block downloadedNum = 0;

    NSInteger __block totalChapterNum = data.count;
    for (NSInteger i = 0; i < totalChapterNum; i++){
        TFHppleElement *element = [data objectAtIndex:i];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *chapterNovelName = [[element objectForKey:@"href"] stringByReplacingOccurrencesOfString:@"html" withString:@"txt"];
            NSString *chapterURL = [novelIndexURL stringByReplacingOccurrencesOfString:@"index.html" withString:[element objectForKey:@"href"]];
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:chapterURL]];
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                //NSLog(@" http response : %ld",(long)httpResponse.statusCode);
                if(200 != httpResponse.statusCode){
                }else{
                    NSString *aString = [[NSString alloc] initWithData:data encoding:CHINESE_CODING];
                    //NSLog(@"aString = %@", aString);
                    TFHpple *xpathParser                = [[TFHpple alloc] initWithHTMLData:[aString dataUsingEncoding:NSUnicodeStringEncoding]];
                    NSArray *elements                   = [xpathParser searchWithXPathQuery:@"//div[@class='readerTitle']"]; // get the title
                    if(elements.count == 0){
                        downloadedNum++;
                        NSLog(@"chapterURL=%@", chapterURL);
                        return;
                    }else{
                        TFHppleElement *hppleElement    = elements[0];
                        NSString *chapterTitle          = [[hppleElement firstChildWithTagName:@"h1"] text];
                        NSString *chapterContent        = [self getNovelContentFromChaptrURL:chapterURL];

                        chapter *newchapter             = [[chapter alloc]init];
                        newchapter.novelName            = novelName;
                        newchapter.chapterName          = chapterNovelName;
                        newchapter.chapterURL           = chapterURL;
                        newchapter.chapterContent       = chapterContent;//@"内容是不是太长了，怎么没有存下来";
                        newchapter.chapterTitle         = chapterTitle;
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            NSArray *array = [chapter findByCriteria:[NSString stringWithFormat:@" WHERE chapterName ='%@' and novelName = '%@'", chapterNovelName, novelName]];
                            if(array.count > 0)
                            {
//                                DDLog(@"update chapter");
//                                [newchapter update];
                            }else{
                                [newchapter save];
                            }
                        });
                    }
                }

                downloadedNum++;
                if(totalChapterNum == (downloadedNum +1)){
                    //DDLog(@"allkeyss=%@", [dic allKeys]);
                    NSMutableDictionary *novelDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    NSMutableDictionary *downloadOK = [NSMutableDictionary dictionary];
                    [downloadOK setObject:@"downloadOK" forKey:@"action"];
                    [[NotificationCenter sharedInstance] sendNotification:downloadOK];
                }

                printf("%ld  ",(long)downloadedNum);
            }];

            [task resume];
        });
    }
}


-(NSString *)getNovelContentFromChaptrURL:(NSString*)chapterURL
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"", nil];
    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:chapterURL]
                                                    encoding:CHINESE_CODING
                                                       error:nil];
    NSData *htmlData = [htmlString dataUsingEncoding:CHINESE_CODING];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//div"]; // get the title

    for(TFHppleElement *hppleElement in elements){
        if ([[hppleElement objectForKey:@"id"] isEqualToString:@"content"]) {
            for (TFHppleElement* child in hppleElement.children){
                if ([child isTextNode]){
                    [array addObject:child.content];
                }
            }
        }
    }
    NSString *chapterContent = [array componentsJoinedByString:@" "];
    return chapterContent;
}

@end
