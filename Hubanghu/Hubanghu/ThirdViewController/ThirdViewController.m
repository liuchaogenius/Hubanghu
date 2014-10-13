//
//  ThirdViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "ThirdViewController.h"
#import "SVPullToRefresh.h"
#import "OrderTableViewCell.h"

typedef enum : NSUInteger {
    currentTabOrderAll = 0,
    currentTabOrderAppraise,
    currentTabOrderUndone,
} currentTabOrder;

@interface ThirdViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic) int currentTab;//开始的时候是哪个按钮
@property(nonatomic, strong) UIView *selectedLineView;
@property(nonatomic, strong) UIView *btnBackView;
@property(nonatomic, strong) UITableView *showOrderTableView;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的订单";
    _currentTab = currentTabOrderAppraise;
    
    [self.view addSubview:self.btnBackView];
    
    self.showOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight-66-40-49)];
    self.showOrderTableView.tableFooterView = [UIView new];
    self.showOrderTableView.delegate = self;
    self.showOrderTableView.dataSource = self;
    self.showOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.showOrderTableView];
    
    [self addTableViewTrag];
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

        });
    }];
    
//    if (btnCount == 15)
//    {
//        [weakself.showOrderTableView addInfiniteScrollingWithActionHandler:^{
//            int64_t delayInSeconds = 2.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^{
//                [weakself.showOrderTableView.infiniteScrollingView stopAnimating];
//
//            });
//        }];
//    }
    
}

#pragma mark getter
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
        NSArray *array = @[@"全部订单", @"待评价", @"未完成"];
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
    }

    return _btnBackView;
}

#pragma mark 选中button
- (void)selectButton:(UIButton *)aBtn
{
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
    _currentTab = (int)aBtn.tag - 10;
    [self.showOrderTableView reloadData];
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (_currentTab == currentTabOrderUndone)
    {
        cell.orderStateLabel.text = @"去付款";
    }
    else if(_currentTab == currentTabOrderAppraise)
    {
        cell.orderStateLabel.text = @"去评价";
    }
    
    return cell;
}

#pragma mark tableView delegate
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
