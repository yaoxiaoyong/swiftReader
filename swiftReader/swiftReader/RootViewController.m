//
//  RootViewController.m
//  PageViewControllerDemo
//
//  Created by SACRELEE on 15/4/12.
//  Copyright (c) 2015年 Sumtice：http://sacrelee.me. All rights reserved.
//

#import "RootViewController.h"
#import "DataViewController.h"

#define DDLog(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface RootViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation RootViewController
{
    NSMutableArray *_dataArray;
    UIPageViewController *_pageViewController;
    BOOL _isRequestPrePage;
    NSTextStorage *storage;
    NSLayoutManager *layoutManager;
    NSTextContainer *textContainer;
    NSString *textString;
    NSInteger *fileIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    fileIndex = 1;

    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:@"1"];
    [_dataArray addObject:@"2"];



    [self createData];
    [self createUI];
}

-(void)setTextData:(NSString*)string{
}

-(void)createData
{
    NSString *filename = [NSString stringWithFormat:@"Chapter%d", fileIndex];
    DDLog();
    [self.navigationController setNavigationBarHidden:YES];
    DDLog(@"filename=%@", filename);
    textString = [[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    DDLog();
    // 2.将字符串封装到TextStorage中
    storage = [[NSTextStorage alloc]initWithString:textString];
    DDLog();
    // 3.为TextStorag添加一个LayoutManager
    layoutManager = [[NSLayoutManager alloc]init];
    [storage addLayoutManager:layoutManager];
    DDLog();
}

-(void)createUI
{
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]};
    _pageViewController  = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    DataViewController *dvc = [self dataViewControllerAtIndex:0 withLayout:layoutManager];
    [_pageViewController setViewControllers:@[dvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

// 根据返回dataSource数组中对应的viewController
-(DataViewController *)dataViewControllerAtIndex:(NSUInteger)index withLayout:(NSLayoutManager *)layoutManager
{
    NSLog(@"crete a new textView, fileIndex=%ld", fileIndex);

    textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [layoutManager addTextContainer:textContainer];
    // 排版结束的判断
    NSRange range = [layoutManager glyphRangeForTextContainer:textContainer];  // 此方法用来获取当前TextContainer内的文本Range
    if ( range.length + range.location == textString.length ){
        NSLog(@"out of range");
        fileIndex = 3;
        [self createData];
        NSLog(@"out of range111, count=%d", layoutManager.textContainers.count);
        [layoutManager removeTextContainerAtIndex:layoutManager.textContainers.count -1];
        textContainer = [[NSTextContainer alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"out of range222");
        [layoutManager addTextContainer:textContainer];
    }

    NSLog(@"333");



    DataViewController *dvc = [[DataViewController alloc]init];
    [dvc setContainer:textContainer];
    dvc.index = [_dataArray objectAtIndex:index];
    [dvc setDataSource:@"test"];
    dvc.backColor = [UIColor lightGrayColor];
    return dvc;
}

// 返回当前viewController数据在数组中所处位置
-(NSUInteger)indexOfViewController:(DataViewController *)dvc
{
    return [_dataArray indexOfObject:dvc.index];
}


#pragma mark - PageViewController Datasource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"go before");
    _isRequestPrePage = YES;
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    // index为0表示已经翻到最前页
    if (index == 0 || index == NSNotFound) {
        return  nil;
    }
    // 返回数据前关闭交互，确保只允许翻一页（有BUG 已作废，改进在代理方法中）
//    pageViewController.view.userInteractionEnabled = NO;
    index --;
    return [self dataViewControllerAtIndex:index withLayout:layoutManager];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"go after");
    _isRequestPrePage = NO;
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    // index为数组最末表示已经翻至最后页
    if (index == NSNotFound || index == _dataArray.count - 1)
        return nil;
    
    // 返回数据前关闭交互，确保只允许翻一页（有BUG 已作废，改进在代理方法中）
//    pageViewController.view.userInteractionEnabled = NO;
    index ++;
    return [self dataViewControllerAtIndex:index withLayout:layoutManager];
}

#pragma - mark PageViewController Delegate
// 翻页控制的改进在此处。
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    // 将要进行动画时才关闭交互，避免上下swipe手势引起永久性失去交互
//    [_pageViewController.view setUserInteractionEnabled:NO];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // 无论有无翻页，只要动画结束就恢复交互。
    if (finished){
        pageViewController.view.userInteractionEnabled = YES;
    }
    
    if (completed) {
       
        // 通过_isRequestPrePage来判断是翻到了上一页还是下一页，进一步做出对应计算。
        int currentIndex = _isRequestPrePage ? (int)[[_dataArray firstObject] integerValue]: (int)[[_dataArray lastObject] integerValue];
        [_dataArray removeAllObjects];
        for (int i = -1; i < 2; i ++) {
            if (currentIndex + i < 1 || currentIndex + i > 100)
                continue;
            [_dataArray addObject:[NSString stringWithFormat:@"%d",currentIndex + i]];
        }
    }
}


@end
