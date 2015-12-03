//
//  ParseWebSite.h
//  EReader
//
//  Created by 姚小勇 on 15/11/29.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseWebSite : NSObject


+ (instancetype) sharedInstance;

-(void)searchWithKey:(NSString*)keyValue
      withReturnValueHandleBlock: (ReturnValueHandleBlock)returnHandleBlock
            withErrorHandleBlock: (ErrorHandleBlock)errorHandleBlock
          withFailureHandleBlock: (FailureHandleBlock)failureHandleBlock;


-(void) downloadNovel:(NSDictionary*)dic;
@end
