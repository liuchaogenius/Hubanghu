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
#import "HbhDropDownView.h"
#import "UIImageView+WebCache.h"
#import "HbhWorkerListManage.h"


typedef enum : NSUInteger {
    btnViewTypeAreas=10,
    btnViewTypeWorkerTypes,
    btnViewTypeOrderCount,
} btnViewType;

@interface SecondViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) BOOL isSpecial;
@property(nonatomic, strong) UIView *btnBackView;
@property(nonatomic, strong) UITableView *showWorkerListTableView;

@property(nonatomic, strong) HbhWorkerListManage *workerListManage;

@property(nonatomic, strong) HbhDropDownView *dropAreasView;
@property(nonatomic, strong) HbhDropDownView *dropWorkerTypesView;
@property(nonatomic, strong) HbhDropDownView *dropOrderCountView;

@property(nonatomic, strong) NSMutableArray *workersArray;
@property(nonatomic, strong) NSMutableArray *areasArray;
@property(nonatomic, strong) NSMutableArray *workerTypeArray;
@property(nonatomic, strong) NSMutableArray *orderCountArray;
//蒙层
@property(nonatomic, strong) UIView *maskingView;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;

@property(nonatomic, strong) void(^myWorkerDetailBlock)(HbhWorkers *);
@property(nonatomic, strong) UIView *failView;
@end

@implementation SecondViewController

- (instancetype)initAndUseWorkerDetailBlock:(void (^)(HbhWorkers *))aBlock
{
    self = [super init];
    _isSpecial = YES;
    self.myWorkerDetailBlock = aBlock;
    return self;
}

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
    
    
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
#pragma mark 网络请求
    [self.workerListManage getWorkerListSuccBlock:^(HbhData *aData) {
        self.workersArray = [(NSMutableArray *)aData.workers mutableCopy];
        self.areasArray = [(NSMutableArray *)aData.areas mutableCopy];
        self.workerTypeArray = [(NSMutableArray *)aData.workerTypes mutableCopy];
        self.orderCountArray = [(NSMutableArray *)aData.orderCountRegions mutableCopy];
        [self.showWorkerListTableView reloadData];
        [self.activityView stopAnimating];
    } andFailBlock:^{
        [self.view addSubview:self.failView];
    }];
}

#pragma mark 上面三个btn
- (UIView *)btnBackView
{
    if (!_btnBackView)
    {
        _btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _btnBackView.backgroundColor = RGBCOLOR(242, 242, 242);
        NSArray *array = @[@"所有区域", @"所有工种", @"接单量"];
        for (int i=0; i<3; i++)
        {
            UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, 0, kMainScreenWidth/3, self.btnBackView.bottom)];
            btnView.tag = i+10;
            UITapGestureRecognizer *tapGestureBtnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBtnView:)];
            [btnView addGestureRecognizer:tapGestureBtnView];
            [_btnBackView addSubview:btnView];
            UIImageView *arrowDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3-16, 16, 13, 8)];
            arrowDownImg.image = [UIImage imageNamed:@"arrowDown"];
            [btnView addSubview:arrowDownImg];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth/3, 20)];
            titleLabel.text = [array objectAtIndex:i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = kFont15;
            [btnView addSubview:titleLabel];
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
    [self.view addSubview:self.maskingView];
    if (aTapGesture.view.tag==btnViewTypeAreas)
    {
        [self showDropView:self.dropAreasView];
        [self.view bringSubviewToFront:self.dropAreasView];
    }
    else if (aTapGesture.view.tag==btnViewTypeWorkerTypes)
    {
        [self showDropView:self.dropWorkerTypesView];
        [self.view bringSubviewToFront:self.dropWorkerTypesView];
    }
    else if(aTapGesture.view.tag==btnViewTypeOrderCount)
    {
        [self showDropView:self.dropOrderCountView];
        [self.view bringSubviewToFront:self.dropOrderCountView];
    }
}

- (void)showDropView:(UIView *)aViewBtn
{
    if (self.dropWorkerTypesView != aViewBtn)
    {
        self.dropWorkerTypesView.hidden = YES;
    }
    if (self.dropAreasView != aViewBtn)
    {
        self.dropAreasView.hidden = YES;
    }
    if (self.dropOrderCountView != aViewBtn)
    {
        self.dropOrderCountView.hidden = YES;
    }
    if (!aViewBtn.superview)
    {
        [self.view addSubview:aViewBtn];
        aViewBtn.hidden = YES;
    }
    if (aViewBtn.hidden==NO) {
        aViewBtn.hidden = YES;
        [self.maskingView removeFromSuperview];
    }else if (aViewBtn.hidden==YES)
    {
        aViewBtn.hidden = NO;
    }
}

#pragma mark getter
- (UIView *)failView
{
    if (!_failView) {
        _failView = [[UIView alloc] init];
        _failView.frame = self.showWorkerListTableView.frame;
        UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-100, kMainScreenHeight/2-100, 200, 50)];
        failLabel.text = @"暂时没有数据";
        failLabel.font = kFont14;
        failLabel.textAlignment = NSTextAlignmentCenter;
        failLabel.textColor = [UIColor lightGrayColor];
        [_failView addSubview:failLabel];
        _failView.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _failView;
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

- (HbhWorkerListManage *)workerListManage
{
    if (!_workerListManage)
    {
        _workerListManage = [[HbhWorkerListManage alloc] init];
    }
    return _workerListManage;
}

- (UIView *)maskingView
{
    if (!_maskingView) {
        _maskingView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight)];
        _maskingView.backgroundColor = [UIColor grayColor];
        _maskingView.alpha = 0.5;
    }
    return _maskingView;
}

- (HbhDropDownView *)dropAreasView
{
    if (!_dropAreasView) {
//        [self.areasArray removeObjectAtIndex:0];
        _dropAreasView = [[HbhDropDownView alloc] initWithArray:self.areasArray andButton:[self.view viewWithTag:btnViewTypeAreas]];
        [_dropAreasView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropAreasView.hidden = YES;
            [self.maskingView removeFromSuperview];
        }];
    }
    return _dropAreasView;
}

- (HbhDropDownView *)dropWorkerTypesView
{
    if (!_dropWorkerTypesView) {
//        [self.workerTypeArray removeObjectAtIndex:0];
        _dropWorkerTypesView = [[HbhDropDownView alloc] initWithArray:self.workerTypeArray andButton:[self.view viewWithTag:btnViewTypeWorkerTypes]];
        [_dropWorkerTypesView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropWorkerTypesView.hidden = YES;
            [self.maskingView removeFromSuperview];
        }];
    }
    return _dropWorkerTypesView;
}

- (HbhDropDownView *)dropOrderCountView
{
    if (!_dropOrderCountView) {
//        [self.orderCountArray removeObjectAtIndex:0];
        _dropOrderCountView = [[HbhDropDownView alloc] initWithArray:self.orderCountArray andButton:[self.view viewWithTag:btnViewTypeOrderCount]];
        [_dropOrderCountView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropOrderCountView.hidden = YES;
            [self.maskingView removeFromSuperview];
        }];
    }
    return _dropOrderCountView;
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workersArray.count;
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
    HbhWorkers *model = [self.workersArray objectAtIndex:indexPath.row];
    [cell.workerIcon sd_setImageWithURL:[NSURL URLWithString:model.photoUrl]];
    cell.workerNameLabel.text = model.name;
    cell.workerMountLabel.text = [NSString stringWithFormat:@"%d", (int)model.orderCount];
    cell.workYearLabel.text = model.workingAge;
    cell.workerTypeLabel.text = [NSString stringWithFormat:@"[%@]", model.workTypeName];
    [cell addSubview:lineView];
    
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_isSpecial==YES)
    {
        HbhWorkers *model = [self.workersArray objectAtIndex:indexPath.row];
        self.myWorkerDetailBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        HbhWorkers *model = [self.workersArray objectAtIndex:indexPath.row];
        HbhWorkerDetailViewController *workDetailVC = [[HbhWorkerDetailViewController alloc] initWithWorkerId:(int)model.id];
        workDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:workDetailVC animated:YES];
    }
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
