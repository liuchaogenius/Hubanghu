//
//  HbhOrderDetailViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderDetailViewController.h"

typedef enum : NSUInteger {
    orderStatusUndone = 0,
    orderStatusFinished
} orderStatus;

@interface HbhOrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *urgentLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic) int orderStatus;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UILabel *showOrderStatusLabel;
@property(nonatomic, strong) UIButton *movementBtn;
@property(nonatomic, strong) UIButton *moreBtn;
@end

@implementation HbhOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    self.title = @"订单详情";
    
    self.orderStatus = 1;
    
    [self.view addSubview:self.topView];
    
    self.movementBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-80, self.priceLabel.top-3, 60, 25)];
    self.movementBtn.backgroundColor = KColor;
    self.movementBtn.titleLabel.font = kFont15;
    self.movementBtn.layer.cornerRadius = 2.5;
    [self.view addSubview:self.movementBtn];
    
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.priceLabel.bottom+40, self.movementBtn.right-20, 40)];
    self.moreBtn.layer.cornerRadius = 2.5;
    [self.view addSubview:self.moreBtn];
    
    if (self.orderStatus == orderStatusUndone) {
        self.showOrderStatusLabel.text = @"代付款";
        [self.movementBtn setTitle:@"支付" forState:UIControlStateNormal];
        self.moreBtn.backgroundColor = RGBCOLOR(201, 201, 201);
        [self.moreBtn setTitleColor:RGBCOLOR(115, 115, 115) forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else{
        self.showOrderStatusLabel.text = @"交易成功";
        [self.movementBtn setTitle:@"已付款" forState:UIControlStateNormal];
        self.moreBtn.backgroundColor = KColor;
        [self.moreBtn setTitle:@"再次预约" forState:UIControlStateNormal];
    }
    
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _topView.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 20)];
        orderStatusLabel.text = @"订单状态";
        orderStatusLabel.font = kFont15;
        [_topView addSubview:orderStatusLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth, 1)];
        lineView.backgroundColor = RGBCOLOR(190, 190, 190);
        [_topView addSubview:lineView];
        
        self.showOrderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100, 10, 80, 20)];
        self.showOrderStatusLabel.textAlignment = NSTextAlignmentRight;
        self.showOrderStatusLabel.font = kFont15;
        self.showOrderStatusLabel.textColor = KColor;
        [_topView addSubview:self.showOrderStatusLabel];
    }
    return _topView;
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
