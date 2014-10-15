//
//  SecondViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "SecondViewController.h"
#import "HbhWorkerTableViewCell.h"
#import "HbhWorkerDetailViewController.h"

@interface SecondViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) BOOL isSpecial;
@property(nonatomic, strong) UIView *btnBackView;
@property(nonatomic, strong) UITableView *showWorkerListTableView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约工人";
    [self.view addSubview:self.btnBackView];
    
    if (!_isSpecial)
    {
        self.showWorkerListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-66-40-49)];
    }
    else
    {
        self.showWorkerListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-66-40)];
    }
    
    self.showWorkerListTableView.delegate = self;
    self.showWorkerListTableView.dataSource = self;
    self.showWorkerListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showWorkerListTableView.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.view addSubview:self.showWorkerListTableView];
}

#pragma mark 上面三个btn
- (UIView *)btnBackView
{
    if (!_btnBackView)
    {
        _btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _btnBackView.backgroundColor = RGBCOLOR(242, 242, 242);
        NSArray *array = @[@"所有区域", @"所有工种", @"接单数"];
        for (int i=0; i<3; i++)
        {
            UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, 0, kMainScreenWidth/3, self.btnBackView.bottom)];
            btnView.tag = i+10;
            UITapGestureRecognizer *tapGestureBtnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBtnView:)];
            [btnView addGestureRecognizer:tapGestureBtnView];
            [_btnBackView addSubview:btnView];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth/3-80)/2, 10, 60, 20)];
            titleLabel.text = [array objectAtIndex:i];
            titleLabel.font = kFont15;
            [btnView addSubview:titleLabel];
            UIImageView *arrowDownImg;
            if (i==2)
            {
                arrowDownImg = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth/3-80)/2+50, 16, 13, 8)];
            }
            else
            {
                arrowDownImg = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth/3-80)/2+65, 16, 13, 8)];
            }
            arrowDownImg.image = [UIImage imageNamed:@"arrowDown"];
            [btnView addSubview:arrowDownImg];
            if (i!=0)
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, 5, 0.5, 30)];
                lineView.backgroundColor = RGBCOLOR(168, 168, 168);
                [_btnBackView addSubview:lineView];
            }
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_btnBackView addSubview:lineView];
    }
    
    return _btnBackView;
}

- (void)touchBtnView:(UITapGestureRecognizer *)aTapGesture
{
    MLOG(@"%ld",(long)aTapGesture.view.tag);
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    HbhWorkerTableViewCell *cell = (HbhWorkerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhWorkerTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:lineView];
    
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HbhWorkerDetailViewController *workDetailVC = [[HbhWorkerDetailViewController alloc] init];
    workDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:workDetailVC animated:YES];
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
