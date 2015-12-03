//
//  E_ReaderViewController.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_ReaderViewController.h"
#import "E_ReaderView.h"
#import "E_CommonManager.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17

@interface E_ReaderViewController ()<E_ReaderViewDelegate>
{
    E_ReaderView *_readerView;
}

@end

@implementation E_ReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///need to do adapter
    //chaptrLabel = [[UILabel alloc]initWithFrame:CGRectMake(fDeviceWidth/2-100, fDeviceHeight - 30, 100, 30)];
    chaptrLabel.textAlignment = NSTextAlignmentCenter;
    chaptrLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];

    ///need to do adapter
    //chaptrLabel.text = [NSString stringWithFormat:@"第%ld章", [dataset sharedInstance]->currentNovenCurrentChapter];
    [self.view addSubview:chaptrLabel];
    
//    [MyNotification registerChapterChangedNotification:self];
    
    ///need to do adapter
    //pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(fDeviceWidth/2, fDeviceHeight - 30, 100, 30)];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    ///need to do adapter
    //pageLabel.text = [NSString stringWithFormat:@"第%ld页", [dataset sharedInstance]->currentNovenCurrentPage];
    [self.view addSubview:pageLabel];
    
//    [MyNotification registerPageChangedNotification:self];

    ///need to do adapter
    //_readerView = [[E_ReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y, fDeviceWidth - 2 * offSet_x, fDeviceHeight - offSet_y - 20)];
    _readerView.keyWord = _keyWord;
    _readerView.magnifiterImage = _themeBgImage;
    _readerView.delegate = self;
    [self.view addSubview:_readerView];
    
}

-(void)PageChanged:(NSNotification *)sender{
    _pageNum = [[sender userInfo] valueForKey:@"pageNum"];
    NSLog(@"chapter=======%@",[NSString stringWithFormat:@"第%@章", _pageNum]);
}

-(void)ChapterChanged:(NSNotification *)sender{
    _chapterNum = [[sender userInfo] valueForKey:@"chapterNum"];
    NSLog(@"page=========%@",[NSString stringWithFormat:@"第%@章", _chapterNum]);
}

#pragma mark - ReaderViewDelegate
- (void)shutOffGesture:(BOOL)yesOrNo{
    [_delegate shutOffPageViewControllerGesture:yesOrNo];
}

- (void)ciBa:(NSString *)ciBaString{

    [_delegate ciBaWithString:ciBaString];
}

- (void)hideSettingToolBar{
    [_delegate hideTheSettingBar];
}

- (void)setFont:(NSUInteger )font_
{
    _readerView.font = font_;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _readerView.text = text;
   
    [_readerView render];
}

- (NSUInteger )font
{
    return _readerView.font;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)readerTextSize
{
    return _readerView.bounds.size;
}
@end
