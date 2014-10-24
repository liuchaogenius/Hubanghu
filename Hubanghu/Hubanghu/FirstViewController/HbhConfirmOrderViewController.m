//
//  HbhConfirmOrderViewController.m
//  Hubanghu
//
//  Created by qf on 14/10/21.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhConfirmOrderViewController.h"
#import "HubOrder.h"
#import "HbhAppointmentNetManager.h"
#import "STAlerView.h"
#import "AreasDBManager.h"
#import "HbuAreaListModelAreas.h"
#define kDoubleToString(a) [NSString stringWithFormat:@"%.0lf",a]
@interface HbhConfirmOrderViewController ()
//data
@property (nonatomic,strong) HubOrder *order;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) HbhAppointmentNetManager *netManager;
@property (nonatomic,strong) NSArray *payPathArr;
@property (nonatomic,strong) NSArray *detailsInfoTitle;
@property (nonatomic,strong) NSArray *detailsInfo;
//UI
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@end

@implementation HbhConfirmOrderViewController

- (void)initData{
	_netManager = [[HbhAppointmentNetManager alloc] init];
	_payPathArr = @[@"支付宝支付"];
	_detailsInfoTitle = @[@"名\t   称:",@"姓\t   名:",@"手  机  号:",@"数\t   量:",@"时\t   间:",@"地\t   址:",@"安装师傅:",@"备\t   注:",@"应付金额:"];
}

- (instancetype)initWithOrder:(HubOrder *)order{
	if (self = [super init]) {
		_order = order;
		_orderId = nil;
		[self initData];
	}
	return self;
}

- (instancetype)initWithOrderId:(NSString *)orderId
{
	self = [super init];
	if (self) {
		_order = nil;
		_orderId = orderId;
		[self initData];
	}
	return self;
}

#pragma mark -
//提交订单
- (void)commitOrder{
	_activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	_activityView.centerX = kMainScreenWidth/2;
	_activityView.centerY = kMainScreenHeight/2 - 100;
	_activityView.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:_activityView];

	[self.view bringSubviewToFront:_activityView];
	[_activityView startAnimating];
	__weak HbhConfirmOrderViewController *weakself = self;
	[_netManager commitOrderWith:_order succ:^(NSDictionary *succDic) {
		_orderId = [[succDic objectForKey:@"data"] objectForKey:@"orderId"];
		[weakself.activityView stopAnimating];
#warning 跳转到支付界面
	} failure:^{
		[self.activityView stopAnimating];
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"提交订单失败" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			if (buttonIndex == 0) {
				[weakself.navigationController popViewControllerAnimated:YES];
			}
			//未完成的重试代码
//			else if(buttonIndex == 1){
//				[weakself.view bringSubviewToFront:weakself.activityView];
//				[weakself.activityView startAnimating];
//				
//				[weakself performSelector:@selector(commitOrder) withObject:nil afterDelay:10];
//			}
		} cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
		[alert show];
	}];
}

- (void)getOrderUseOrderId{
	
	__weak HbhConfirmOrderViewController *weakself = self;
	[_netManager getOrderWith:_orderId succ:^(HubOrder *order) {
		_order = order;
		[weakself resetDetailsInfo];
		[self.activityView stopAnimating];
	} failure:^{
		[self.activityView stopAnimating];
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"获取订单信息出错" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			if (buttonIndex == 0) {
				[weakself.navigationController popViewControllerAnimated:YES];
			}
			//未完成的重试代码
//			else if(buttonIndex == 1){
//				[weakself.view bringSubviewToFront:weakself.activityView];
//				[weakself.activityView startAnimating];
//				
//				[weakself performSelector:@selector(getOrderUseOrderId) withObject:nil afterDelay:300];
//			}
		} cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
		[alert show];
	}];
}

- (NSString *)getAreaNameWith:(double)areaId{
	NSString *areaIdStr = kDoubleToString(areaId);
	AreasDBManager *areaManager = [[AreasDBManager alloc] init];
	__block HbuAreaListModelAreas *district;
	[areaManager selParentModel:areaIdStr resultBlock:^(HbuAreaListModelAreas *model) {
		district = model;
	}];
	__block HbuAreaListModelAreas *city;
	areaIdStr = kDoubleToString(district.parent);
	[areaManager selParentModel:areaIdStr resultBlock:^(HbuAreaListModelAreas *model) {
		city = model;
	}];
	__block HbuAreaListModelAreas *province;
	areaIdStr = kDoubleToString(city.parent);
	[areaManager selParentModel:areaIdStr resultBlock:^(HbuAreaListModelAreas *model) {
		province = model;
	}];
	
	return [NSString stringWithFormat:@"%@ %@ %@",province.name,city.name,district.name];
}

- (void)resetDetailsInfo{
//	_detailsInfoTitle = @[@"名称:",@"姓名:",@"手机号",@"数量",@"时间",@"地址",@"安装师傅",@"备注",@"应付金额"];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:_order.time];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"GMT+8"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	NSString *areaStr = [self getAreaNameWith:_order.areaId];
	NSString *comment = [_order.comment isEqualToString:@""]?@"无":_order.comment;
	NSString *amount;
	switch ((int)_order.mountType) {
		case 0:
			amount = [NSString stringWithFormat:@"%.0lf(个)",_order.amount];
			break;
		case 1:
			amount = [NSString stringWithFormat:@"%.2lf(㎡)",_order.amount];
			break;
		case 2:
			amount = [NSString stringWithFormat:@"%.2lf(米)",_order.amount];
			break;
		default:
			break;
	}
	NSString *price = [NSString stringWithFormat:@"¥%.2lf",_order.price];
	_detailsInfo = @[_order.name,
					 _order.username,
					 kDoubleToString(_order.phone),
					 amount,
					 dateString,
					 areaStr,
					 _order.workerName,
					 comment,
					 price];
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section == 0){
		return _detailsInfoTitle.count;
	}else if (section == 1){
		return _payPathArr.count;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		return 35;
	}else if(indexPath.section == 1){
		return 44;
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCell"];
	}
	if(indexPath.section == 0){
		NSInteger i = indexPath.row;
		UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, kMainScreenHeight - 40, 35)];
//		tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
//		tf.layer.borderWidth = 1;
		tf.enabled = NO; // 设置为不可编辑
		tf.font = kFont13;
		tf.textColor = [UIColor lightGrayColor];
		tf.text = _detailsInfo[indexPath.row];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
		label.text = _detailsInfoTitle[i	];
		label.font = kFont13;
		
		tf.leftViewMode = UITextFieldViewModeAlways;
		tf.leftView = label;
		[cell.contentView addSubview:tf];
	}else if(indexPath.section == 1){
		cell.textLabel.text = [_payPathArr objectAtIndex:indexPath.row];
	}
	return cell;
}

#pragma mark - viewController life loop
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"确认下单";
	self.view.backgroundColor = [UIColor whiteColor];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.allowsSelection = NO;
	[self.view addSubview:_tableView];
	
	UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 70)];
	UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, kMainScreenWidth - 20, 40)];
	[commit setTitle:@"确认下单" forState:UIControlStateNormal];
	footView.backgroundColor = [UIColor whiteColor];
	[commit setBackgroundColor:KColor];
	commit.layer.cornerRadius = 2;
	commit.titleLabel.font = kFontBold20;
	[commit addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchDown];
	[footView addSubview:commit];
	
	_tableView.tableFooterView = footView;
	if (!_orderId && _order) {
		[self resetDetailsInfo];
	}
	if (!_order && _orderId) {
		_activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		_activityView.centerX = kMainScreenWidth/2;
		_activityView.centerY = kMainScreenHeight/2 - 100;
		_activityView.backgroundColor = [UIColor lightGrayColor];
		[self.view addSubview:_activityView];

		[self getOrderUseOrderId];
		
		[self.view bringSubviewToFront:_activityView];
		[_activityView startAnimating];
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
