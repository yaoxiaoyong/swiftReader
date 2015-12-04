//
//  UIScrollView+DXRefresh.m
//  DXRefresh
//
//  Created by xiekw on 10/11/14.
//  Copyright (c) 2014 xiekw. All rights reserved.
//

#import "UIScrollView+DXRefresh.h"
#import <objc/runtime.h>



@protocol DXRefreshView <NSObject>

@required
- (void)beginRefreshing;
- (void)endRefreshing;

@end

@interface DXRfreshFooter : UIControl<DXRefreshView>

@property (nonatomic, strong) UIActivityIndicatorView *acv;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL refreshing;


- (void)beginRefreshing;
- (void)endRefreshing;


+ (CGFloat)standHeight;
+ (CGFloat)standTriggerHeight;

@end

@implementation DXRfreshFooter

+ (CGFloat)standHeight
{
    return 44.0;
}

+ (CGFloat)standTriggerHeight
{
    return [self standHeight] + 20.0;
}

- (void)beginRefreshing
{
    self.refreshing = YES;
    [self.acv startAnimating];
}

- (void)endRefreshing
{
    //wierd handle way, otherwise it will flash the table view when reloaddata
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshing = NO;
        [self.acv stopAnimating];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0, 0.0f);
        } completion:^(BOOL finished) {
        }];
    });
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.acv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat height = CGRectGetHeight(frame) * 0.8;
        self.acv.frame = CGRectMake((CGRectGetWidth(frame)-height)*0.5, 0, height, height);
        [self addSubview:self.acv];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self endRefreshing];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];

    
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

        self.scrollView = (UIScrollView *)newSuperview;
        [self adjustFrameWithContentSize];
    }
}

- (void)adjustFrameWithContentSize
{
    CGFloat contentHeight = self.scrollView.contentSize.height;
    CGFloat scrollHeight = self.scrollView.frame.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
    
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = MAX(contentHeight, scrollHeight);
    self.frame = selfFrame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self adjustFrameWithContentSize];
    } else if ([@"contentOffset" isEqualToString:keyPath]) {
        if (self.scrollView.contentOffset.y <= 0) {
            return;
        }
        
        if (self.scrollView.contentOffset.y+(self.scrollView.frame.size.height) > self.scrollView.contentSize.height+[DXRfreshFooter standTriggerHeight]  && !self.refreshing) {
            
            [self beginRefreshing];
            
            [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, [DXRfreshFooter standHeight], 0.0f);
            } completion:^(BOOL finished) {
                
            }];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


@end


@interface UIScrollView ()

@property (nonatomic, strong) UIControl<DXRefreshView> *header;
@property (nonatomic, strong) UIControl<DXRefreshView> *footer;

@end

@implementation UIScrollView (DXRefresh)

static char DXRefreshHeaderViewKey;
static char DXRefreshFooterViewKey;

- (void)setHeader:(UIView *)header {
    objc_setAssociatedObject(self, &DXRefreshHeaderViewKey, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)header {
    return objc_getAssociatedObject(self, &DXRefreshHeaderViewKey);
}

- (void)setFooter:(UIView *)footer {
    objc_setAssociatedObject(self, &DXRefreshFooterViewKey, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)footer {
    return objc_getAssociatedObject(self, &DXRefreshFooterViewKey);
}

- (void)addHeaderWithTarget:(id)target action:(SEL)action
{
    if (self.header) {
        [self.header removeFromSuperview];
        self.header = nil;
    }
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [self addSubview:refresh];
    self.alwaysBounceVertical = YES;
    self.header = (UIControl<DXRefreshView> *)refresh;
}

- (void)headerBeginRefreshing
{
    if ([self.header isKindOfClass:[UIRefreshControl class]]) {
        UIRefreshControl *refresh = (UIRefreshControl *)self.header;
        CGFloat contentOffsetY = - 64.0;
        if (self.contentOffset.y < 0) {
            contentOffsetY = -124.0f;
        }
        [self setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        [refresh beginRefreshing];
    }
}

- (void)headerEndRefreshing
{
    if ([self.header isKindOfClass:[UIRefreshControl class]]) {
        UIRefreshControl *refresh = (UIRefreshControl *)self.header;
        [refresh endRefreshing];
    }
}

- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    if (self.footer) {
        [self.footer removeFromSuperview];
        self.footer = nil;
    }
    self.footer = [[DXRfreshFooter alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), [DXRfreshFooter standHeight])];
    [self.footer addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.footer];
}

- (void)footerBeginRefreshing
{
    if (!self.footer) {
        return;
    }
    
    CGFloat upOffset = self.contentSize.height - CGRectGetHeight(self.bounds);
    upOffset = MAX(0, upOffset);
    [self setContentOffset:CGPointMake(0, upOffset + [DXRfreshFooter standTriggerHeight]) animated:YES];

    [self.footer beginRefreshing];
}

- (void)footerEndRefreshing
{
    [self.footer endRefreshing];
}

- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
