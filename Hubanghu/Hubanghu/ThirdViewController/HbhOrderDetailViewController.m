//
//  HbhOrderDetailViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderDetailViewController.h"
#import "HbhOrderManage.h"
#import "STAlerView.h"
#import "HbhMakeAppointMentViewController.h"
#import "HbhConfirmOrderViewController.h"

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

@property(nonatomic, strong) HbhOrderModel *myModel;
@property(nonatomic, strong) HbhOrderManage *orderManage;
@end

@implementation HbhOrderDetailViewController

- (instancetype)initWithOrderStatus:(HbhOrderModel *)aModel
{
    self = [super init];
    self.myModel = aModel;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    self.title = @"订单详情";
    
    _orderStatus = self.myModel.status;
    [self setUIWithModel:self.myModel];
    [self.view addSubview:self.topView];
    
    self.movementBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-80, self.priceLabel.top-3, 60, 25)];
    self.movementBtn.backgroundColor = KColor;
    self.movementBtn.titleLabel.font = kFont15;
    self.movementBtn.layer.cornerRadius = 2.5;
    [self.view addSubview:self.movementBtn];
    
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.priceLabel.bottom+40, self.movementBtn.right-20, 40)];
    self.moreBtn.titleLabel.font = kFont20;
    self.moreBtn.layer.cornerRadius = 2.5;
    [self.view addSubview:self.moreBtn];
    
    if (self.orderStatus == orderStatusUndone) {
        self.showOrderStatusLabel.text = @"待付款";
        [self.movementBtn setTitle:@"支付" forState:UIControlStateNormal];
        [self.movementBtn addTarget:self action:@selector(pushToComfirmOrderVC) forControlEvents:UIControlEventTouchUpInside];
        self.moreBtn.backgroundColor = KColor;
        [self.moreBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(cancelOrderBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        self.showOrderStatusLabel.text = @"交易成功";
        [self.movementBtn setTitle:@"已付款" forState:UIControlStateNormal];
        self.movementBtn.backgroundColor = RGBCOLOR(201, 201, 201);
        [self.movementBtn setTitleColor:RGBCOLOR(115, 115, 115) forState:UIControlStateNormal];
        self.movementBtn.userInteractionEnabled = NO;
        self.moreBtn.backgroundColor = KColor;
        [self.moreBtn setTitle:@"再次预约" forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(orderAgian) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark 再次预约
- (void)orderAgian
{
    [self.navigationController pushViewController:[[HbhMakeAppointMentViewController alloc] init] animated:YES];
}

#pragma mark cancelOrder
- (void)cancelOrderBtn
{
    STAlertView *alertView = [[STAlertView alloc]
                              initWithTitle:@"确定要取消订单吗"
                              message:nil
                              clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex)
                              {
                                  if (buttonIndex==1) {
                                      [self cancelOrder];
                                  }
                              }
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)cancelOrder
{
    [self.orderManage cancelOrder:(int)self.myModel.orderId andSuccBlock:^{
        
    } and:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (HbhOrderManage *)orderManage
{
    if (!_orderManage) {
        _orderManage = [[HbhOrderManage alloc] init];
    }
    return _orderManage;
}

- (void)setUIWithModel:(HbhOrderModel *)aModel
{
    self.orderIdLabel.text = [NSString stringWithFormat:@"%.f", aModel.orderId];
    self.orderTimeLabel.text = [self transformTime:aModel.time];
    self.orderNameLabel.text = aModel.name;
    /*0纯装，1拆装，2纯拆，3勘察*/
    switch ((int)aModel.mountType) {
        case 0:
            self.orderTypeLabel.text = @"纯装";
            break;
        case 1:
            self.orderTypeLabel.text = @"拆装";
            break;
        case 2:
            self.orderTypeLabel.text = @"纯拆";
            break;
        case 3:
            self.orderTypeLabel.text = @"勘察";
            break;
        default:
            break;
    }
    if (!aModel.urgent) {
        self.urgentLabel.text = @"否";
    }
    else
    {
        self.urgentLabel.text = @"是";
    }
    self.workerNameLabel.text = aModel.workerName;
    self.remarkLabel.text = aModel.comment;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", aModel.price];
    
}

//确认支付
- (void)pushToComfirmOrderVC
{
    HbhConfirmOrderViewController *vc = [[HbhConfirmOrderViewController alloc] initWithOrderId:[NSString stringWithFormat:@"%d", (int)self.myModel.orderId]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessItem) name:kPaySuccess object:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)paySuccessItem
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaySuccess object:nil];
    //未支付设为支付完成
    self.showOrderStatusLabel.text = @"交易成功";
    [self.movementBtn setTitle:@"已付款" forState:UIControlStateNormal];
    self.movementBtn.backgroundColor = RGBCOLOR(201, 201, 201);
    [self.movementBtn setTitleColor:RGBCOLOR(115, 115, 115) forState:UIControlStateNormal];
    self.movementBtn.userInteractionEnabled = NO;
    self.moreBtn.backgroundColor = KColor;
    [self.moreBtn setTitle:@"再次预约" forState:UIControlStateNormal];
    [self.moreBtn removeTarget:self action:@selector(cancelOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn addTarget:self action:@selector(orderAgian) forControlEvents:UIControlEventTouchUpInside];
    if ([self.orderDelegaet respondsToSelector:@selector(anyPayedSuccess)]) {
        [self.orderDelegaet anyPayedSuccess];
    }
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _topView.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 20)];
        orderStatusLabel.backgroundColor = [UIColor clearColor];
        orderStatusLabel.text = @"订单状态";
        orderStatusLabel.font = kFont15;
        [_topView addSubview:orderStatusLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth, 1)];
        lineView.backgroundColor = kLineColor;
        [_topView addSubview:lineView];
        
        self.showOrderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-100, 10, 80, 20)];
        self.showOrderStatusLabel.textAlignment = NSTextAlignmentRight;
        self.showOrderStatusLabel.backgroundColor = [UIColor clearColor];
        self.showOrderStatusLabel.font = kFont15;
        self.showOrderStatusLabel.textColor = KColor;
        [_topView addSubview:self.showOrderStatusLabel];
    }
    return _topView;
}

- (NSString *)transformTime:(int)aTime
{
    NSDate *newDate  = [NSDate dateWithTimeIntervalSince1970:aTime];
    MLOG(@"%@", newDate);
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *showtimeNew = [formatter1 stringFromDate:newDate];
    return showtimeNew;
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
