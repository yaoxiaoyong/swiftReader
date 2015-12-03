//
//  DataViewController.m
//  PageViewControllerDemo
//
//  Created by SACRELEE on 15/4/12.
//  Copyright (c) 2015年 Sumtice：http://sacrelee.me. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

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

    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, self.view.frame.size.height-50)];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
