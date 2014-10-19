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
#import "HbhWorkerDetailManage.h"
#import "UIImageView+WebCache.h"
#import "HbhMakeAppointMentViewController.h"
#import "HbhCommentViewController.h"

@interface HbhWorkerDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *workDetailTableView;
@property(nonatomic) int myWorkerId;
@property(nonatomic, strong)HbhWorkerDetailManage *workerDetailManage;

@property(nonatomic, strong) HbhWorkerData *workerData;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation HbhWorkerDetailViewController

- (instancetype)initWithWorkerId:(int)aWorkerId
{
    self = [super init];
    self.myWorkerId = aWorkerId;
    return self;
}

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
    
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    [self.workerDetailManage getWorkerDetailWithWorkerId:self.myWorkerId SuccBlock:^(HbhWorkerData *aData) {
        self.workerData = aData;
        [self.workDetailTableView reloadData];
        [self.activityView stopAnimating];
    } and:^{
        
    }];
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]
                         initWithFrame:CGRectMake(kMainScreenWidth/2-20, kMainScreenHeight/2-20, 40, 40)];
        _activityView.color = [UIColor blackColor];
    }
    return _activityView;
}

- (HbhWorkerDetailManage *)workerDetailManage
{
    if (!_workerDetailManage) {
        _workerDetailManage = [[HbhWorkerDetailManage alloc] init];
    }
    return _workerDetailManage;
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
            return 65;
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
        [cell.workerIcon sd_setImageWithURL:[NSURL URLWithString:self.workerData.photoUrl]];
        cell.workerNameLabel.text = self.workerData.name;
        cell.workerTypeLabel.text = [NSString stringWithFormat:@"[%@]", self.workerData.workTypeName];
        cell.workerYearLabel.text = self.workerData.workingAge;
        cell.workerMountLabel.text = self.workerData.orderCount;
        cell.personLabel.text = self.workerData.desc;
        cell.successLabel.text = self.workerData.succCaseDesc;
        cell.honorLabel.text = self.workerData.certificationDesc;
        [cell.appointmentBtn addTarget:self action:@selector(makeAppointment) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            HbhWorkerSecondTopTableViewCell *cell = [[HbhWorkerSecondTopTableViewCell alloc] init];
            [cell.moreBtn addTarget:self action:@selector(moreComment) forControlEvents:UIControlEventTouchUpInside];
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
            NSArray *array = self.workerData.comment;
            HbhWorkerComment *model = [array objectAtIndex:indexPath.row];
            [cell.userImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl]];
            cell.userNameLabel.text = model.username;
            cell.timeLabel.text = [NSString stringWithFormat:@"%d", (int)model.time];
            cell.typeLabel.text = model.cate;
            cell.commentLabel.text = model.content;
            cell.workerNameLabel.text = model.worker;
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
            NSArray *array = self.workerData.caseProperty;
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

#pragma mark 跳转到预约
- (void)makeAppointment
{
    [self.navigationController pushViewController:[[HbhMakeAppointMentViewController alloc] init] animated:YES];
}

#pragma mark 跳转到更多评论
- (void)moreComment
{
    [self.navigationController pushViewController:[[HbhCommentViewController alloc] initWithCommentArray:self.workerData.comment] animated:YES];
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