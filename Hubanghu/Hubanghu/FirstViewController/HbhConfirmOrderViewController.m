//
//  HbhConfirmOrderViewController.m
//  Hubanghu
//
//  Created by qf on 14/10/21.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhConfirmOrderViewController.h"
#import "HubOrder.h"
#import "HbhOrderDetailsView.h"
#import "HbhAppointmentNetManager.h"
#import "STAlerView.h"
@interface HbhConfirmOrderViewController ()
//data
@property (nonatomic,strong) HubOrder *order;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) HbhAppointmentNetManager *netManager;
@property (nonatomic,strong) NSArray *payPath;
//UI
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@end

@implementation HbhConfirmOrderViewController

- (instancetype)initWithOrder:(HubOrder *)order{
	if (self = [super init]) {
		_order = order;
		_orderId = nil;
		_netManager = [[HbhAppointmentNetManager alloc] init];
		_payPath = @[@"支付宝支付"];
	}
	return self;
}

- (instancetype)initWithOrderId:(NSString *)orderId
{
	self = [super init];
	if (self) {
		_orderId = orderId;
		_netManager = [[HbhAppointmentNetManager alloc] init];
	}
	return self;
}

#pragma mark -
//提交订单
- (void)commitOrder{
	__weak HbhConfirmOrderViewController *weakself = self;
	[_netManager commitOrderWith:_order succ:^(NSDictionary *succDic) {
		_orderId = [[succDic objectForKey:@"data"] objectForKey:@"orderId"];

		[self.activityView stopAnimating];
	} failure:^{
		[self.activityView stopAnimating];
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"提交订单失败" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			if (buttonIndex == 0) {
				[weakself.navigationController popViewControllerAnimated:YES];
			}else if(buttonIndex == 2){
				[weakself commitOrder];
			}
		} cancelButtonTitle:@"返回" otherButtonTitles:@"重试", nil];
		[alert show];
	}];
}

- (void)getOrderUseOrderId{
	
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _payPath.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCell"];
	}
	cell.textLabel.text = [_payPath objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark - viewController life loop
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"确认下单";
	self.view.backgroundColor = [UIColor whiteColor];
	_activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	_activityView.centerX = kMainScreenWidth/2;
	_activityView.centerY = kMainScreenHeight/2 - 100;
	_activityView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:_activityView];
	if (!_orderId && _order) {
		[self commitOrder];
	}
	if (!_order && _orderId) {
		[self getOrderUseOrderId];
	}
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.allowsSelection = NO;
	[self.view addSubview:_tableView];
	
	HbhOrderDetailsView *details = [[HbhOrderDetailsView alloc] initWithOrder:_order];
	details.frame = CGRectMake(50, 50, kMainScreenWidth - 100, 400);
	details.centerX = kMainScreenWidth/2;
	details.layer.borderColor = [UIColor lightGrayColor].CGColor;
	details.layer.borderWidth = 0.2;
	details.layer.cornerRadius = 5;
	details.backgroundColor = [UIColor whiteColor];

	_tableView.tableHeaderView = details;
	[self.view bringSubviewToFront:_activityView];
	[_activityView startAnimating];
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
