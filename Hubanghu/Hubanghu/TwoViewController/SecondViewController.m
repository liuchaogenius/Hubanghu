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
#import "SVPullToRefresh.h"
#import "HbuAreaLocationManager.h"
#import "AreasDBManager.h"
#import "HbuAreaListModelAreas.h"

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

@property(nonatomic, strong) NSArray *locationArray;
@property(nonatomic) BOOL isLocationed;
@property(nonatomic, strong) AreasDBManager *areasDBManage;
@property(nonatomic, strong) HbhDropDownView *dropLocationView;
@property(nonatomic, assign) int locationAreaId;
@property(nonatomic, assign) int locationDistrictId;

@property(nonatomic, strong) UITapGestureRecognizer *maskingViewTapGestureRecognizer;
@end

@implementation SecondViewController

- (instancetype)initAndUseWorkerDetailBlock:(void (^)(HbhWorkers *))aBlock
{
    self = [super init];
    _isSpecial = YES;
    self.myWorkerDetailBlock = aBlock;
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"预约工人"];
    [self.view addSubview:self.btnBackView];
    
    if ([HbuAreaLocationManager sharedManager].currentAreas.areaId)
    {
        _locationAreaId = [HbuAreaLocationManager sharedManager].currentAreas.areaId;
        [self.areasDBManage selCityOfDistrict:[NSString stringWithFormat:@"%d", (int)[HbuAreaLocationManager sharedManager].currentAreas.areaId] district:^(NSMutableArray *districtArry) {
            self.locationArray = districtArry;
            _isLocationed = YES;
        }];
    }
    else
    {
        _isLocationed = NO;
    }
    
    
    
    if (!_isSpecial)
    {
        self.showWorkerListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40-49)];
    }
    else
    {
        self.showWorkerListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-64-40)];
    }
    
    self.showWorkerListTableView.delegate = self;
    self.showWorkerListTableView.dataSource = self;
    self.showWorkerListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showWorkerListTableView.backgroundColor = kViewBackgroundColor;
    [self.view addSubview:self.showWorkerListTableView];
    
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    [self addTableViewTrag];
    
#pragma mark 网络请求
    if (_isLocationed) {
        if ([HbuAreaLocationManager sharedManager].currentDistrict) {
            HbuAreaListModelAreas *area = [HbuAreaLocationManager sharedManager].currentDistrict;
            _locationDistrictId = area.areaId;
            [self getWorkerListWithAreaId:area.areaId andWorkerTypeId:0 andOrderCountId:0];
            UILabel *temLabel = (UILabel *)[self.view viewWithTag:100];
            temLabel.text = area.name;
        }
        else
        {
            HbuAreaListModelAreas *model = [self.locationArray objectAtIndex:0];
            [self getWorkerListWithAreaId:model.areaId andWorkerTypeId:0 andOrderCountId:0];
        }
    }
    else
    {
        [self getWorkerListWithAreaId:0 andWorkerTypeId:0 andOrderCountId:0];
    }
}

- (void)getWorkerListWithAreaId:(int)aAreaId andWorkerTypeId:(int)aWorkTypeId andOrderCountId:(int)aOrderId
{
    [self.showWorkerListTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.workerListManage getWorkerListWithAreaId:aAreaId andWorkerTypeId:aWorkTypeId andOrderCountId:aOrderId SuccBlock:^(HbhData *aData) {
//        [self.failView removeFromSuperview];
        self.workersArray = [(NSMutableArray *)aData.workers mutableCopy];
        self.areasArray = [(NSMutableArray *)aData.areas mutableCopy];
        self.workerTypeArray = [(NSMutableArray *)aData.workerTypes mutableCopy];
        self.orderCountArray = [(NSMutableArray *)aData.orderCounts mutableCopy];
        [self.showWorkerListTableView reloadData];
        [self.dropOrderCountView reloadTableView];
        [self.dropWorkerTypesView reloadTableView];
        if (self.workersArray.count==0) {
//            [self.view addSubview:self.failView];
        }
        [self.activityView stopAnimating];
        if (aAreaId!=-1 && aWorkTypeId!=-1 && aOrderId !=-1)
        {
            [self updateBtn];
        }
    } andFailBlock:^{
//        [self.view addSubview:self.failView];
    }];
}

#pragma mark 上拉下拉
#pragma mark 增加上拉下拉
- (void)addTableViewTrag
{
    __weak SecondViewController *weakself = self;
    [weakself.showWorkerListTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.showWorkerListTableView.pullToRefreshView stopAnimating];
            
            int shareDistrictId = [HbuAreaLocationManager sharedManager].currentDistrict.areaId;
            int shareAreaId = [HbuAreaLocationManager sharedManager].currentAreas.areaId;
            if(shareAreaId && shareAreaId != _locationAreaId)
            {
                _locationAreaId = shareAreaId;
                [self.areasDBManage selCityOfDistrict:[NSString stringWithFormat:@"%d", (int)[HbuAreaLocationManager sharedManager].currentAreas.areaId] district:^(NSMutableArray *districtArry) {
                    self.locationArray = districtArry;
                    self.dropLocationView.tableArray = self.locationArray;
                    [self.dropLocationView reloadTableView];
                    _isLocationed = YES;
                    if (shareDistrictId && shareDistrictId!=_locationDistrictId)
                    {
                        _locationDistrictId = shareDistrictId;
                        [self getWorkerListWithAreaId:shareDistrictId andWorkerTypeId:-1 andOrderCountId:-1];
                        UILabel *temLabel = (UILabel *)[self.view viewWithTag:100];
                        temLabel.text = [HbuAreaLocationManager sharedManager].currentDistrict.name;
                        [self getWorkerListWithAreaId:_locationDistrictId andWorkerTypeId:-1 andOrderCountId:-1];
                    }
                    else
                    {
                        HbuAreaListModelAreas *model = [self.locationArray objectAtIndex:0];
                        UILabel *label0 = (UILabel *)[self.view viewWithTag:100];
                        label0.text = model.name;
                        [self getWorkerListWithAreaId:model.areaId andWorkerTypeId:-1 andOrderCountId:-1];
                    }
                }];
            }
            else if (shareDistrictId && shareDistrictId!=_locationDistrictId)
            {
                _locationDistrictId = shareDistrictId;
                [self getWorkerListWithAreaId:shareDistrictId andWorkerTypeId:-1 andOrderCountId:-1];
                UILabel *temLabel = (UILabel *)[self.view viewWithTag:100];
                temLabel.text = [HbuAreaLocationManager sharedManager].currentDistrict.name;
                [self getWorkerListWithAreaId:_locationDistrictId andWorkerTypeId:-1 andOrderCountId:-1];
            }
            else
            {
                [self getWorkerListWithAreaId:-1 andWorkerTypeId:-1 andOrderCountId:-1];
            }

        });
    }];
    

        [weakself.showWorkerListTableView addInfiniteScrollingWithActionHandler:^{
            int64_t delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [weakself.showWorkerListTableView.infiniteScrollingView stopAnimating];
                [self.workerListManage getNextPageWorerListSuccBlock:^(HbhData *aData) {
                    NSMutableArray *insertIndexPaths = [NSMutableArray new];
                    for (unsigned long i=self.workersArray.count; i<self.workersArray.count+aData.workers.count; i++) {
                        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                        [insertIndexPaths addObject:indexpath];
                    }
                    [self.workersArray addObjectsFromArray:aData.workers];
                    [self.showWorkerListTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//                    [self.showWorkerListTableView reloadData];
                } andFailBlock:^{
                    
                }];
            });
        }];
}


#pragma mark 刷新btn
- (void)updateBtn
{
    UILabel *label0 = (UILabel *)[self.view viewWithTag:100];
    UILabel *label1 = (UILabel *)[self.view viewWithTag:101];
    UILabel *label2 = (UILabel *)[self.view viewWithTag:102];
    if (_isLocationed) {
        if ([HbuAreaLocationManager sharedManager].currentDistrict) {
            HbuAreaListModelAreas *area = [HbuAreaLocationManager sharedManager].currentDistrict;
            label0.text = area.name;
        }
        else
        {
            HbuAreaListModelAreas *model = [self.locationArray objectAtIndex:0];
            label0.text = model.name;
        }
    }
    else{
    for (int i=0; i<self.areasArray.count; i++) {
        HbhAreas *model = [self.areasArray objectAtIndex:i];
        if (model.selected==true) {
            label0.text = model.name;
            break;
        }
    }
    }
    for (int i=0; i<self.workerTypeArray.count; i++) {
        HbhWorkerTypes *model = [self.workerTypeArray objectAtIndex:i];
        if (model.selected==true) {
            label1.text = model.name;
            break;
        }
    }
    for (int i=0; i<self.orderCountArray.count; i++) {
        HbhOrderCounts *model = [self.orderCountArray objectAtIndex:i];
        if (model.selected==true) {
            label2.text = model.name;
            break;
        }
    }
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
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [array objectAtIndex:i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = kFont15;
            titleLabel.tag = i+100;
            [btnView addSubview:titleLabel];
            if (i!=0)
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, 5, 0.5, 30)];
                lineView.backgroundColor = kLineColor;
                [_btnBackView addSubview:lineView];
            }
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = kLineColor;
        [_btnBackView addSubview:lineView];
    }
    
    return _btnBackView;
}

- (void)settingLabel:(UILabel *)aLabel
{
    
}

#pragma mark 按钮事件
- (void)touchBtnView:(UITapGestureRecognizer *)aTapGesture
{
    [self.view addSubview:self.maskingView];
    if (aTapGesture.view.tag==btnViewTypeAreas)
    {
        if (_isLocationed) {
            [self showDropView:self.dropLocationView];
            [self.view bringSubviewToFront:self.dropLocationView];
        }
        else
        {
            [self showDropView:self.dropAreasView];
            [self.view bringSubviewToFront:self.dropAreasView];
        }
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
    if (self.dropLocationView != aViewBtn) {
        self.dropLocationView.hidden = YES;
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
- (AreasDBManager *)areasDBManage
{
    if (!_areasDBManage) {
        _areasDBManage = [[AreasDBManager alloc] init];
    }
    return _areasDBManage;
}

- (UIView *)failView
{
    if (!_failView) {
        _failView = [[UIView alloc] init];
        _failView.frame = self.showWorkerListTableView.frame;
        UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-100, kMainScreenHeight/2-100, 200, 50)];
        failLabel.text = @"暂时没有数据";
        failLabel.font = kFont14;
        failLabel.backgroundColor = [UIColor clearColor];
        failLabel.textAlignment = NSTextAlignmentCenter;
        failLabel.textColor = [UIColor lightGrayColor];
        [_failView addSubview:failLabel];
        _failView.backgroundColor = kViewBackgroundColor;
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
        _maskingView.userInteractionEnabled = YES;
        [_maskingView addGestureRecognizer:self.maskingViewTapGestureRecognizer];
    }
    return _maskingView;
}

- (UITapGestureRecognizer *)maskingViewTapGestureRecognizer
{
    if (!_maskingViewTapGestureRecognizer) {
        _maskingViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMaskingView)];
    }
    return _maskingViewTapGestureRecognizer;
}

- (void)removeMaskingView
{
    [self.maskingView removeFromSuperview];
    self.dropAreasView.hidden = YES;
    self.dropLocationView.hidden = YES;
    self.dropOrderCountView.hidden = YES;
    self.dropWorkerTypesView.hidden = YES;
}

- (HbhDropDownView *)dropLocationView
{
    if (!_dropLocationView) {
        if (_isLocationed) {
            _dropLocationView = [[HbhDropDownView alloc] initWithArray:self.locationArray andButton:[self.view viewWithTag:btnViewTypeAreas]];
        }
        else
        {
            _dropLocationView = [[HbhDropDownView alloc] initWithArray:self.areasArray andButton:[self.view viewWithTag:btnViewTypeAreas]];
        }
        [_dropLocationView useBlock:^(int row) {
            NSLog(@"%d", row);
            _dropLocationView.hidden = YES;
            [self.maskingView removeFromSuperview];
            [self.activityView startAnimating];
            HbuAreaListModelAreas *model = [self.locationArray objectAtIndex:row];
            [self getWorkerListWithAreaId:model.areaId andWorkerTypeId:-1 andOrderCountId:-1];
            UILabel *temLabel = (UILabel *)[self.view viewWithTag:100];
            temLabel.text = model.name;
        }];

    }
    return _dropLocationView;
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
            [self.activityView startAnimating];
            HbhAreas *model = [self.areasArray objectAtIndex:row];
            [self getWorkerListWithAreaId:model.areasIdentifier andWorkerTypeId:-1 andOrderCountId:-1];
            UILabel *temLabel = (UILabel *)[self.view viewWithTag:100];
            temLabel.text = model.name;
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
            [self.activityView startAnimating];
            HbhWorkerTypes *model = [self.workerTypeArray objectAtIndex:row];
            [self getWorkerListWithAreaId:-1 andWorkerTypeId:model.workerTypesIdentifier andOrderCountId:-1];
            UILabel *temLabel = (UILabel *)[self.view viewWithTag:101];
            temLabel.text = model.name;
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
            [self.activityView startAnimating];
            HbhOrderCounts *model = [self.orderCountArray objectAtIndex:row];
            [self getWorkerListWithAreaId:-1 andWorkerTypeId:-1 andOrderCountId:model.orderCountsIdentifier];
            UILabel *temLabel = (UILabel *)[self.view viewWithTag:102];
            temLabel.text = model.name;
        }];
    }
    return _dropOrderCountView;
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.workersArray.count>0) {
        return self.workersArray.count;
    }
    else
    {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.workersArray.count>0) {
        static NSString *CellIdentifier = @"CustomCellIdentifier";
        HbhWorkerTableViewCell *cell = (HbhWorkerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhWorkerTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = kLineColor;
        HbhWorkers *model = [self.workersArray objectAtIndex:indexPath.row];
        [cell.workerIcon sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto"]];
        cell.workerNameLabel.text = model.name;
        cell.workerMountLabel.text = [NSString stringWithFormat:@"%d", (int)model.orderCount];
        cell.workYearLabel.text = model.workingAge;
        if ([model.workTypeName isEqualToString:@""]||model.workTypeName==nil) {
            cell.workerTypeLabel.text = @"";
        }
        else
        {
            cell.workerTypeLabel.text = [NSString stringWithFormat:@"[%@]", model.workTypeName];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:lineView];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.userInteractionEnabled=NO;
        if (indexPath.row==3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-50, 20, 100, 20)];
            label.text = @"暂时没有数据";
            label.font = kFont14;
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:label];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
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
        HbhWorkerDetailViewController *workDetailVC = [[HbhWorkerDetailViewController alloc] initWithWorkerModel:model];
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
