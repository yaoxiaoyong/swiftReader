//
//  DataViewController.m
//  PageViewControllerDemo
//
//  Created by 姚小勇 on 15/12/1.
//  Copyright © 2015年 姚小勇. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()
@property (strong,nonatomic) NSString * dataString;

@property (strong, nonatomic) NSTextContainer *textContainer;
@end


#define Width  self.view.frame.size.width-20
#define Hight  self.view.frame.size.height-50

@implementation DataViewController

-(void)setContainer:(NSTextContainer *)textContainer{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-50) textContainer:textContainer];
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"AppleGothic" size:20];
    [self.view addSubview:textView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat height = self.view.bounds.size.height;
    CGFloat width = self.view.bounds.size.width;
    self.view.backgroundColor = [UIColor grayColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = _backColor;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake( width - 200, height - 45, 200, 60);
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"第%@页",_index];
    [self.view addSubview:label];
}

-(void)setDataSource:(NSString*)dataString{
    _dataString = dataString;
}

@end
