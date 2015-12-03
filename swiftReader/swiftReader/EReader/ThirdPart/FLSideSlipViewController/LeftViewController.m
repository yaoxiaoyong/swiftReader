//
//  LeftViewController.m
//  test123
//
//  Created by kf1 on 14-9-20.
//  Copyright (c) 2014年 kf1. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:UITableViewStylePlain];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    menuArray = [NSMutableArray array];
    [menuArray addObject:@"删除所选项"];
    [menuArray addObject:@"更新所选项"];
    [menuArray addObject:@"退出编辑模式"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",menuArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ///need to do adapter
        //[[MyBookShelfViewController sharedInstance] deleteBook];
    }
}

@end
