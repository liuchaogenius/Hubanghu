//
//  workerDetailViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerDetailViewController.h"
#import "HbhTopTableViewCell.h"
#import "HbhWorkerSecondTopTableViewCell.h"
#import "HbhWorkerCommentTableViewCell.h"
#import "HbhWorkerThirdTopTableViewCell.h"
#import "HbhWorkerImgTableViewCell.h"

@interface HbhWorkerDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *workDetailTableView;
@end

@implementation HbhWorkerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"工人详情";
    
    self.workDetailTableView = [[UITableView alloc]
                                initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.workDetailTableView.dataSource = self;
    self.workDetailTableView.delegate = self;
    self.workDetailTableView.allowsSelection = NO;
    self.workDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.workDetailTableView.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.view addSubview:self.workDetailTableView];
}

#pragma mark tableView datasource datadelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 5)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 216;
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            return 35;
        }
        else{
            return 70;
        }
        return 0;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            return 35;
        }
        else{
            return 70;
        }
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        return 3;
    }
    else if(section==2)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        HbhTopTableViewCell *cell = [[HbhTopTableViewCell alloc] init];
        return cell;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            HbhWorkerSecondTopTableViewCell *cell = [[HbhWorkerSecondTopTableViewCell alloc] init];
            return cell;
        }
        else
        {
            HbhWorkerCommentTableViewCell *cell = [[HbhWorkerCommentTableViewCell alloc] init];
            if (indexPath.row==2)
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, kMainScreenWidth, 1)];
                lineView.backgroundColor = RGBCOLOR(218, 218, 218);
                [cell addSubview:lineView];
            }
            return cell;
        }
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            HbhWorkerThirdTopTableViewCell *cell = [[HbhWorkerThirdTopTableViewCell alloc] init];
            return cell;
        }
        else
        {
            NSArray *array = @[@"1", @"2", @"3", @"4"];
            HbhWorkerImgTableViewCell *cell = [[HbhWorkerImgTableViewCell alloc] initWithImgArray:array];
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end