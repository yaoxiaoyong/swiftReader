//
//  UIScrollView+DXRefresh.h
//  DXRefresh
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DXRefresh)

- (void)addHeaderWithTarget:(id)target action:(SEL)action;
- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;

- (void)addFooterWithTarget:(id)target action:(SEL)action;
- (void)footerBeginRefreshing;
- (void)footerEndRefreshing;
- (void)removeFooter;

@end
