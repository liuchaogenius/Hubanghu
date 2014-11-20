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
#import "SVProgressHUD.h"
#import "JSONKit.h"

#define kDoubleToString(a) [NSString stringWithFormat:@"%.0lf",a]
@interface HbhConfirmOrderViewController ()
{
    UIButton *commitButton;
}
//data
@property (nonatomic,strong) HubOrder *order;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) HbhAppointmentNetManager *netManager;
@property (nonatomic,strong) NSArray *payPathArr;
@property (nonatomic,strong) NSArray *detailsInfoTitle;
@property (nonatomic,strong) NSArray *detailsInfo;
//UI
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *alipayLogoImgview;
@end

@implementation HbhConfirmOrderViewController

- (void)initData{
	_netManager = [[HbhAppointmentNetManager alloc] init];
	_payPathArr = @[@"    支付宝支付"];
    if (kSystemVersion < 7.0) {
        _detailsInfoTitle = @[@"名        称:",@"姓        名:",@"手  机  号:",@"数        量:",@"时        间:",@"地        址:",@"安装师傅:",@"备        注:",@"应付金额:"];
    }else{
        _detailsInfoTitle = @[@"名\t   称:",@"姓\t   名:",@"手  机  号:",@"数\t   量:",@"时\t   间:",@"地\t   址:",@"安装师傅:",@"备\t   注:",@"应付金额:"];
    }
    [self registerPayorderResultNotify];
}

- (void)registerPayorderResultNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayresult:) name:kAlipayOrderResultMessage object:nil];
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
        int iOrderid = [orderId intValue];
		_orderId = [NSString stringWithFormat:@"%d",iOrderid];
        
		[self initData];
	}
	return self;
}

#pragma mark -
//提交订单
- (void)commitOrder{
    [SVProgressHUD showWithStatus:@"正在下单.." cover:YES offsetY:0];
	__weak HbhConfirmOrderViewController *weakself = self;
	[_netManager commitOrderWith:_order succ:^(NSDictionary *succDic) {
        NSDictionary *dataDict = [succDic objectForKey:@"data"];
        if(dataDict && [[dataDict objectForKey:@"result"] intValue] == 1)
        {
            int iOrderid = [[dataDict objectForKey:@"orderId"] intValue];
            _orderId = [NSString stringWithFormat:@"%d",iOrderid];
            if(_orderId && _orderId.length > 0)
            {
                [commitButton setTitle:@"支付" forState:UIControlStateNormal];
                [commitButton addTarget:self action:@selector(alipayServier) forControlEvents:UIControlEventTouchDown];
            }
            [SVProgressHUD dismiss];
        }

	} failure:^{
		[SVProgressHUD dismiss];
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"提交订单失败" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			if (buttonIndex == 0) {
				[weakself.navigationController popViewControllerAnimated:YES];
			}
		} cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
		[alert show];
	}];
}

- (void)getOrderUseOrderId{
	
	__weak HbhConfirmOrderViewController *weakself = self;
	[_netManager getOrderWith:_orderId succ:^(HubOrder *order) {
		_order = order;
		[weakself resetDetailsInfo];
		[weakself.tableView reloadData];
        [SVProgressHUD dismiss];
	} failure:^{
		[SVProgressHUD dismiss];
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"获取订单信息出错" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			if (buttonIndex == 0) {
				[weakself.navigationController popViewControllerAnimated:YES];
			}
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
    NSString *workName = (_order.workerName&&_order.workerName.length>0)?_order.workerName:@"客服安排";

    ;
	NSString *amount;
	switch ([_order.amountType intValue]) {
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
            amount = @"";
			break;
	}
	NSString *price = [NSString stringWithFormat:@"¥%.2lf",_order.price];
    MLOG(@"ordername:%@",_order.name);
    _order.name = _order.name?_order.name:@"";
    _order.username = _order.username?_order.username:@"";
    dateString = dateString?dateString:@"";
    areaStr = dateString?dateString:@"";
    workName = workName?workName:@"";
    comment = comment?comment:@"";
    price = price?price:@"";
	_detailsInfo = @[_order.name,
					 _order.username,
					 kDoubleToString(_order.phone),
					 amount,
					 dateString,
					 areaStr,
					 workName,
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
        tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		tf.enabled = NO; // 设置为不可编辑
		tf.font = kFont13;
		tf.textColor = [UIColor lightGrayColor];
		tf.text = _detailsInfo[indexPath.row];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.backgroundColor = [UIColor clearColor];
		label.text = _detailsInfoTitle[i	];
		label.font = kFont13;
		
		tf.leftViewMode = UITextFieldViewModeAlways;
		tf.leftView = label;
		[cell.contentView addSubview:tf];
	}else if(indexPath.section == 1){
		cell.textLabel.text = [_payPathArr objectAtIndex:indexPath.row];
        if(!self.alipayLogoImgview)
        {
            UIImage *img = [UIImage imageNamed:@"alipay_logo"];
            self.alipayLogoImgview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
            self.alipayLogoImgview.contentMode = UIViewContentModeScaleAspectFill;
            [self.alipayLogoImgview setImage:img];
            [cell addSubview:self.alipayLogoImgview];
        }
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
	commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, kMainScreenWidth - 20, 40)];
    if(_orderId)
    {
        [commitButton setTitle:@"支付" forState:UIControlStateNormal];
        [commitButton addTarget:self action:@selector(alipayServier) forControlEvents:UIControlEventTouchDown];
    }
    else
    {
	    [commitButton setTitle:@"确认下单" forState:UIControlStateNormal];
        [commitButton addTarget:self action:@selector(commitOrder) forControlEvents:UIControlEventTouchDown];
    }
	footView.backgroundColor = [UIColor whiteColor];
	[commitButton setBackgroundColor:KColor];
	commitButton.layer.cornerRadius = 2;
	commitButton.titleLabel.font = kFontBold20;

	[footView addSubview:commitButton];
	
	_tableView.tableFooterView = footView;
	if (!_orderId && _order) {
		[self resetDetailsInfo];
	}
	if (!_order && _orderId) {
        [SVProgressHUD showErrorWithStatus:@"获取订单信息..." cover:NO offsetY:0];
		[self getOrderUseOrderId];
	}
    self.tableView.backgroundView = nil;
    self.view.backgroundColor = kViewBackgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 支付订单
#warning 支付订单 liuchao
- (void)alipayServier
{
    NSString *strPric = [NSString stringWithFormat:@"%.2f", self.order.price];
    NSString *strDesc = nil;
    NSString *strTitle = nil;
    //[SVProgressHUD showErrorWithStatus:@"正在下单.." cover:NO offsetY:0];
    [SVProgressHUD showWithStatus:@"正在下单.." cover:YES offsetY:0];
    if(self.order.name && self.order.name.length > 0)
    {
        strTitle = self.order.name;
    }
    else
    {
        strTitle = @"户帮户安装";
    }
    if(self.order.comment && self.order.comment.length>0)
    {
        strDesc = self.order.comment;
    }
    else
    {
        strDesc = @"户帮户服务";
    }
    [self.netManager aliPaySigned:self.order orderId:self.orderId productDesx:strDesc title:strTitle price:strPric succ:^(NSString *sigAlipayInfo) {
        MLOG(@"sigalipay = %@",sigAlipayInfo);
        [SVProgressHUD dismissWithSuccess:@"下单成功,请现在支付,也可之后进入“我的订单”中进行支付"];
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithSuccess:@"下单成功,请现在支付,也可之后进入“我的订单”中进行支付"];
    }];
}

- (void)aliPayresult:(NSNotification *)aNotification
{
    MLOG(@"%@",aNotification);
    NSString *strNotification = [aNotification object];
    NSString *strEncode = [strNotification stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *notificationDict = [strEncode objectFromJSONString];
     MLOG(@"notificationDict = %@",notificationDict);
    NSDictionary *memoDict = [notificationDict objectForKey:@"memo"];
    int resultStatus = [[memoDict objectForKey:@"ResultStatus"] intValue];
    NSString *resultDesc = [memoDict objectForKey:@"memo"];
    if(resultStatus == 9000)///支付成功
    {
       //已支付 灰色-按钮 不可用  已支付。。---
        [SVProgressHUD showSuccessWithStatus:@"支付成功" cover:YES offsetY:kMainScreenHeight/2.0];
        commitButton.enabled = NO;
        [commitButton setBackgroundColor:[UIColor lightGrayColor]];
        [commitButton setTitle:@"已支付" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccess object:self];
        
    }
    else if(resultStatus == 8000)///正在处理也当支付成功
    {
        [SVProgressHUD showSuccessWithStatus:@"支付成功" cover:YES offsetY:kMainScreenHeight/2.0];
        commitButton.enabled = NO;
        [commitButton setBackgroundColor:[UIColor lightGrayColor]];
        [commitButton setTitle:@"已支付" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccess object:self];
    }
    else///支付失败
    {
        [SVProgressHUD showErrorWithStatus:@"支付失败，请重新尝试" cover:YES offsetY:kMainScreenHeight/2.0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPayFail object:self];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
