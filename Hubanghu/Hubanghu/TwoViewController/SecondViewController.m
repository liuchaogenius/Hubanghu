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
#import "HbhDataModels.h"

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
    
#pragma mark 网络请求
    [self.workerListManage getWorkerListSuccBlock:^(HbhData *aData) {
        self.workersArray = [(NSMutableArray *)aData.workers mutableCopy];
        self.areasArray = [(NSMutableArray *)aData.areas mutableCopy];
        self.workerTypeArray = [(NSMutableArray *)aData.workerTypes mutableCopy];
        self.orderCountArray = [(NSMutableArray *)aData.orderCountRegions mutableCopy];
        [self.showWorkerListTableView reloadData];
    } and:^{
        
    }];
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
    if (aTapGesture.view.tag==btnViewTypeAreas)
    {
        [self showDropView:self.dropAreasView];
    }
    else if (aTapGesture.view.tag==btnViewTypeWorkerTypes)
    {
        [self showDropView:self.dropWorkerTypesView];
    }
    else if(aTapGesture.view.tag==btnViewTypeOrderCount)
    {
        [self showDropView:self.dropOrderCountView];
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
    BOOL state = aViewBtn.hidden;
    aViewBtn.hidden = !state;
}

#pragma mark getter
- (HbhWorkerListManage *)workerListManage
{
    if (!_workerListManage)
    {
        _workerListManage = [[HbhWorkerListManage alloc] init];
    }
    return _workerListManage;
}

- (HbhDropDownView *)dropAreasView
{
    if (!_dropAreasView) {
        [self.areasArray removeObjectAtIndex:0];
        _dropAreasView = [[HbhDropDownView alloc] initWithArray:self.areasArray andButton:[self.view viewWithTag:btnViewTypeAreas]];
        [_dropAreasView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropAreasView.hidden = YES;
        }];
    }
    return _dropAreasView;
}

- (HbhDropDownView *)dropWorkerTypesView
{
    if (!_dropWorkerTypesView) {
        [self.workerTypeArray removeObjectAtIndex:0];
        _dropWorkerTypesView = [[HbhDropDownView alloc] initWithArray:self.workerTypeArray andButton:[self.view viewWithTag:btnViewTypeWorkerTypes]];
        [_dropWorkerTypesView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropWorkerTypesView.hidden = YES;
        }];
    }
    return _dropWorkerTypesView;
}

- (HbhDropDownView *)dropOrderCountView
{
    if (!_dropOrderCountView) {
        [self.orderCountArray removeObjectAtIndex:0];
        _dropOrderCountView = [[HbhDropDownView alloc] initWithArray:self.orderCountArray andButton:[self.view viewWithTag:btnViewTypeOrderCount]];
        [_dropOrderCountView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropOrderCountView.hidden = YES;
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
    cell.workerNameLabel.text = model.workTypeName;
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
