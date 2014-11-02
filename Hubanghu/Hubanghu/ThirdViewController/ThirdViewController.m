//
//  ThirdViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "ThirdViewController.h"
#import "SVPullToRefresh.h"
#import "HbhOrderTableViewCell.h"
#import "HbhOrderDetailViewController.h"
#import "HbhOrderAppraiseViewController.h"
#import "HbhOrderManage.h"
#import "HbhOrderModel.h"
#import "HbhUser.h"

typedef enum : NSUInteger {
    currentTabOrderAll = 0,
    currentTabOrderUndone,
    currentTabOrderAppraise
} currentTabOrder;

@interface ThirdViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL firstInitview;
}
@property(nonatomic) int currentTab;//当前页面
@property(nonatomic) int paramCurrentTab;//传入的当前页面
@property(nonatomic, strong) UIView *selectedLineView;
@property(nonatomic, strong) UIView *btnBackView;
@property(nonatomic, strong) UITableView *showOrderTableView;
@property(nonatomic, strong) UIView *failView;

@property(nonatomic, strong) HbhOrderManage *orderManage;
@property(nonatomic, strong) NSMutableArray *allOrderArray;
@property(nonatomic, strong) NSMutableArray *appraiseArray;
@property(nonatomic, strong) NSMutableArray *unDoneArray;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation ThirdViewController

- (instancetype)initWithCurrentTab:(int)aCurrentTab
{
    self = [super init];
    self.paramCurrentTab = aCurrentTab;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![HbhUser sharedHbhUser].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginForUserMessage object:[NSNumber numberWithBool:YES]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessItem) name:kLoginSuccessMessae object:nil];
    }
    else
    {
        if(firstInitview == NO)
        {
            [self initView];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginSuccessItem
{
    if(firstInitview == NO)
    {
        [self initView];
    }
}

- (void)initView
{
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    [self settitleLabel:@"我的订单"];
    if (!self.paramCurrentTab)
    {
        _currentTab = currentTabOrderAll;
        self.showOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-66-40-49)];
    }
    else
    {
        _currentTab = self.paramCurrentTab;
        self.showOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-66-40)];
    }
    
    [self.view addSubview:self.btnBackView];
    
    self.showOrderTableView.delegate = self;
    self.showOrderTableView.dataSource = self;
    self.showOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showOrderTableView.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.view addSubview:self.showOrderTableView];
    firstInitview = YES;
    [self addTableViewTrag];
    [self getFisrtPage];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
}

-(HbhOrderManage *)orderManage
{
    if (!_orderManage) {
        _orderManage = [[HbhOrderManage alloc] init];
    }
    return _orderManage;
}

#pragma mark 网络请求
- (void)getFisrtPage
{
    [self.orderManage getOrderWithListFilterId:_currentTab andSuccBlock:^(NSArray *aArray) {
        [self.failView removeFromSuperview];
        if (aArray.count==0)
        {
            [self.view addSubview:self.failView];
        }
        switch (_currentTab) {
            case currentTabOrderAll:
                self.allOrderArray = [aArray mutableCopy];
                break;
            case currentTabOrderUndone:
                self.unDoneArray = [aArray mutableCopy];
                break;
            case currentTabOrderAppraise:
                self.appraiseArray = [aArray mutableCopy];
                break;
            default:
                break;
        }
        [self.activityIndicatorView stopAnimating];
        [self.showOrderTableView reloadData];
    } andFailBlock:^{
        [self.view addSubview:self.failView];
    }];
}

- (void)getNextPage
{
    [self.orderManage getNextOrderListSuccBlock:^(NSArray *aArray) {
        switch (_currentTab) {
            case currentTabOrderAll:
                [self.allOrderArray addObjectsFromArray:aArray];
                break;
            case currentTabOrderUndone:
                [self.unDoneArray addObjectsFromArray:aArray];
                break;
            case currentTabOrderAppraise:
                [self.appraiseArray addObjectsFromArray:aArray];
                break;
            default:
                break;
        }
        [self.showOrderTableView reloadData];
    } andFailBlock:^{
        
    }];
}

#pragma mark 上拉下拉
#pragma mark 增加上拉下拉
- (void)addTableViewTrag
{
    __weak ThirdViewController *weakself = self;
    [weakself.showOrderTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.showOrderTableView.pullToRefreshView stopAnimating];
            [self getFisrtPage];
        });
    }];
    

    [weakself.showOrderTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.showOrderTableView.infiniteScrollingView stopAnimating];
            [self getNextPage];
        });
    }];
}

#pragma mark getter
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-20, kMainScreenHeight/2-20, 40, 40)];
        _activityIndicatorView.color = [UIColor blackColor];
    }
    return _activityIndicatorView;
}

- (UIView *)selectedLineView
{
    if (!_selectedLineView)
    {
        _selectedLineView = [[UIView alloc] init];
        [_selectedLineView setFrame:CGRectMake(kMainScreenWidth/3*_currentTab+10, self.btnBackView.bottom-1, kMainScreenWidth/3-20, 1)];
        _selectedLineView.backgroundColor = KColor;
    }
    return _selectedLineView;
}

- (UIView *)btnBackView
{
    if (!_btnBackView)
    {
        _btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _btnBackView.backgroundColor = RGBCOLOR(242, 242, 242);
        NSArray *array = @[@"全部订单", @"未完成", @"待评价"];
        for (int i=0; i<3; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, 0, kMainScreenWidth/3, self.btnBackView.bottom)];
            btn.titleLabel.font = kFont15;
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+10;
            [_btnBackView addSubview:btn];
            if (i == _currentTab)
            {
                [btn setTitleColor:KColor forState:UIControlStateNormal];
            }
            
            if (i!=0)
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3*i, 15, 1.5, 15)];
                lineView.backgroundColor = RGBCOLOR(168, 168, 168);
                [_btnBackView addSubview:lineView];
            }
        }
        [_btnBackView addSubview:self.selectedLineView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_btnBackView addSubview:lineView];
    }

    return _btnBackView;
}

- (UIView *)failView
{
    if (!_failView) {
        _failView = [[UIView alloc] init];
        _failView.frame = self.showOrderTableView.frame;
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

#pragma mark 选中button
- (void)selectButton:(UIButton *)aBtn
{
    _currentTab = (int)aBtn.tag - 10;
    [self.showOrderTableView reloadData];
    [self.activityIndicatorView startAnimating];
    for (int i=0; i<3; i++)
    {
        UIButton *temBtn = (UIButton *)[self.view viewWithTag:i+10];
        [temBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [aBtn setTitleColor:KColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temFrame = self.selectedLineView.frame;
        temFrame.origin = CGPointMake(aBtn.left+10, aBtn.bottom-1);
        self.selectedLineView.frame = temFrame;
    }];
    if (_currentTab == currentTabOrderAll)
    {
        if (self.allOrderArray.count == 0) {
            [self getFisrtPage];
//            [self.view addSubview:self.failView];
        }
        else{
            [self.activityIndicatorView stopAnimating];
//            [self.failView removeFromSuperview];
        }
    }
    else if(_currentTab == currentTabOrderAppraise)
    {
        if (self.appraiseArray.count == 0) {
            [self getFisrtPage];
//            [self.view addSubview:self.failView];
        }
        else{
            [self.activityIndicatorView stopAnimating];
//            [self.failView removeFromSuperview];
        }
    }
    else if (_currentTab == currentTabOrderUndone)
    {
        if (self.unDoneArray.count == 0) {
            [self getFisrtPage];
//            [self.view addSubview:self.failView];
        }
        else
        {
            [self.activityIndicatorView stopAnimating];
//            [self.failView removeFromSuperview];;
        }
    }
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentTab == currentTabOrderAll)
    {
        return self.allOrderArray.count;
    }
    else if(_currentTab == currentTabOrderAppraise)
    {
        return self.appraiseArray.count;
    }
    else if (_currentTab == currentTabOrderUndone)
    {
        return self.unDoneArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HbhOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[HbhOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    HbhOrderModel *model;
    if (_currentTab == currentTabOrderAll)
    {
        model = [self.allOrderArray objectAtIndex:indexPath.row];
    }
    else if(_currentTab == currentTabOrderAppraise)
    {
        model = [self.appraiseArray objectAtIndex:indexPath.row];
    }
    else if (_currentTab == currentTabOrderUndone)
    {
        model = [self.unDoneArray objectAtIndex:indexPath.row];
    }
    cell.nameLabel.text = model.name;
    cell.workerNameLabel.text = model.workerName;
    if (!model.urgent) {
        cell.urgentLabel.text = @"";
    }
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.price];
    switch ((int)model.status) {
        case 0:
            cell.orderStateLabel.text = @"去付款";
            break;
        case 1:
            cell.orderStateLabel.text = @"已付款";
            break;
        case 2:
            cell.orderStateLabel.text = @"去评价";
            break;
        default:
            break;
    }
    /*0纯装，1拆装，2纯拆，3勘察*/
    switch ((int)model.mountType) {
        case 0:
            cell.typeLabel.text = @"[纯装]";
            break;
        case 1:
            cell.typeLabel.text = @"[拆装]";
            break;
        case 2:
            cell.typeLabel.text = @"[纯拆]";
            break;
        case 3:
            cell.typeLabel.text = @"[勘察]";
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    HbhOrderModel *model;//= [self.allOrderArray objectAtIndex:indexPath.row];
    if (_currentTab==currentTabOrderAll) {
        model = [self.allOrderArray objectAtIndex:indexPath.row];
    }
    else if(_currentTab==currentTabOrderUndone){
        model = [self.unDoneArray objectAtIndex:indexPath.row];
    }else if(_currentTab==currentTabOrderAppraise)
    {
        model = [self.appraiseArray objectAtIndex:indexPath.row];
    }
    HbhOrderDetailViewController *orderDetailVC = [[HbhOrderDetailViewController alloc] initWithOrderStatus:model];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    HbhOrderAppraiseViewController *orderAppraiseVC = [[HbhOrderAppraiseViewController alloc] initWithModel:model];
    orderAppraiseVC.hidesBottomBarWhenPushed = YES;
    switch ((int)model.status) {
            /*0未付款，1已付款，2待评价*/
        case 0:
        case 1:
            [self.navigationController pushViewController:orderDetailVC animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:orderAppraiseVC animated:YES];
            break;
        default:
            break;
    }
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
