//
//  HbhAppointmentViewController.m
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhAppointmentViewController.h"
#import "HbhAppointmentNetManager.h"
#import "HbhAppointmentConfirmeView.h"
#import "HbhConfirmOrderViewController.h"
#import "FBKVOController.h"
#import "STAlerView.h"
#import "SecondViewController.h"
#import "HbhWorkers.h"
#import "HubOrder.h"
#import "STAlerView.h"
#define kDescLabelHeight 80
#define kCountTextFieldTag 991
@interface HbhAppointmentViewController ()
//data
@property (nonatomic,strong) NSString *hbhTitle;
@property (nonatomic,strong) NSString *cateId;
@property (nonatomic,strong) NSString *describe;
@property (nonatomic,assign) NSInteger amountType;
@property (nonatomic,strong) HbhAppointmentNetManager *netManager;
@property (nonatomic,strong) HbhWorkers *worker;
@property (nonatomic,assign) BOOL urgent;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *price;
//UI
@property (nonatomic,strong) TouchTableView *tableView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) HbhAppointmentConfirmeView *footView;
@property (nonatomic,strong) UITextField *countTextField;
@property (nonatomic,strong) UITextField *remarkTf;
@property (nonatomic,strong) HbhAppointmentDetailsTableViewCell *details;

@end

@implementation HbhAppointmentViewController

- (instancetype)initWithTitle:(NSString *)title cateId:(NSString *)cateId andWork:(HbhWorkers *)worker{
	if (self = [super init]) {
		_hbhTitle = title;
		_cateId = cateId;
		_worker = worker;
		_urgent = NO;
		_type = 0;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}
#pragma mark - lazy init

- (UITextField *)countTextField{
	if (!_countTextField) {
		_countTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, 80, kDescLabelHeight - 40)];
		_countTextField.tag	= kCountTextFieldTag;
		_countTextField.delegate = self;
		_countTextField.placeholder = @"请输入..";
		_countTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		_countTextField.font = kFont13;
		_countTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		_countTextField.textAlignment = NSTextAlignmentCenter;
		_countTextField.layer.borderWidth = 1;
		_countTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_countTextField.layer.cornerRadius = 2;
		[_countTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	}
	return _countTextField;
}

#pragma mark -
- (void)getPrice{ //获取价格
	if (![_countTextField.text isEqualToString:@""]) {
		NSDictionary *dic = @{@"type":@(_type),
							  @"amountType":@(_amountType),
							  @"amount":_countTextField.text,
							  @"urgent":@(_urgent)};
		[_netManager getAPpointmentPriceWith:dic succ:^(NSString *price) {
			_footView.price = [price doubleValue];
			_price = price;
		}];
	}
}

//检查内容的完整性和正确性
- (BOOL)checkContent{
	STAlertView *alert = [[STAlertView alloc] initWithTitle:@"!" message:@"" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
		
	} cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	if ([_countTextField.text isEqualToString:@""]) {
		alert.message = @"请输入数量";
		[_countTextField becomeFirstResponder];
	}else if ([_details.timeTF.text isEqualToString:@""]) {
		alert.message = @"请输入时间";
	}else if ([_details.phoneNumberTF.text isEqualToString:@""]){
		alert.message = @"请输入手机号";
		[_details.phoneNumberTF becomeFirstResponder];
	}else if ([_details.userNameTF.text isEqualToString:@""]){
		alert.message = @"请输入姓名";
		[_details.userNameTF becomeFirstResponder];
	}else if ([_details.areaTF.text isEqualToString:@""]){
		alert.message = @"请输入地址";
	}else if ([_details.detailAreaTF.text isEqualToString:@""]){
		alert.message = @"请输入详细地址";
		[_details.detailAreaTF becomeFirstResponder];
	}else if (!_worker){
		alert.message = @"请选择工人";
	}else if (![self phoneNumIsRight]){
		alert.message = @"请输入正确的电话号码";
	}
	
	if (![alert.message isEqualToString:@""]) {
		[alert show];
		return NO;
	}
	
	return YES;
}

//判断电话号码是否正确
- (BOOL)phoneNumIsRight{
#warning 正则表达式判断电话号码是否正确
	return YES;
}

#pragma mark - button event
//跳转到选择工人列表
- (void)pickWorker{
	SecondViewController *vc = [[SecondViewController alloc] initAndUseWorkerDetailBlock:^(HbhWorkers *aWorkerModel) {
		_worker = aWorkerModel;
		[_footView.pickWorkerBt setTitle:_worker.name forState:UIControlStateNormal];
	}];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmOrder{
	if ([self checkContent]) {
		NSDictionary *orderDic = @{@"cateId":_cateId,
								@"username":@"小明",
								@"time":@(_details.time),
								@"amount":_countTextField.text,
								@"workerId":@(_worker.workersIdentifier),
								@"mountType":@(_amountType),
								@"comment":_remarkTf.text,
								@"phone":_details.phoneNumberTF.text,
								@"areaId":_details.selectAreaId,
								@"location":_details.detailAreaTF.text,
								@"price":_price,
								@"workerName":_worker.name,
								@"urgent":@(_urgent),
								@"name":_hbhTitle};
		HubOrder *order = [[HubOrder alloc] initWithDictionary:orderDic];
		HbhConfirmOrderViewController * covc = [[HbhConfirmOrderViewController alloc] initWithOrder:order];
		[self.navigationController pushViewController:covc animated:YES];
	}
}

- (void)selectType:(UIButton *)sender{
	for (UIView *button in [sender.superview subviews]) {
		if ([button isKindOfClass:[UIButton class]] && button.tag == _type ) {
			[(UIButton *)button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
			button.layer.borderColor = [UIColor lightGrayColor].CGColor;
		}
	}
	_type = sender.tag;
	[sender setTitleColor:KColor forState:UIControlStateNormal];
	sender.layer.borderColor = KColor.CGColor;
	[self getPrice];
}

- (void)selectUrgent:(UIButton *)sender{
	_urgent = _urgent ? NO:YES;
	if (_urgent) {
		[sender setImage:[UIImage imageNamed:@"rectangleUp"] forState:UIControlStateNormal];
	}else{
		[sender setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
	}
	[self getPrice];
}

#pragma mark - delegate
- (void)didDatePickerAppear{
#warning ----
	_tableView.height = self.view.height -  230;
	[UIView animateWithDuration:0.5 animations:^{
		[_tableView setContentOffset:CGPointMake(0, 260)];
	}];
}

- (void)didDatePickerDisappear{
	_tableView.height = self.view.height;
}
#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification{
	NSDictionary *info = [notification userInfo];
	//获取高度
	NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
	CGSize hightSize = [value CGRectValue].size;
	_tableView.height = self.view.height -  hightSize.height;
	
	//避免切换输入法时的抖动
	if (_tableView.contentOffset.y <= hightSize.height + 30 ||
		_tableView.contentOffset.y >= hightSize.height - 30) {
		return;
	}
	[UIView animateWithDuration:0.5 animations:^{
		[_tableView setContentOffset:CGPointMake(0, hightSize.height)];
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification{
	NSDictionary *info = [notification userInfo];
	//获取高度
	NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
	CGSize hightSize = [value CGRectValue].size;
	_tableView.height += hightSize.height;
}

#pragma mark - textField delegate

//监听textfield的值变化
- (BOOL)textFieldDidChange:(UITextField *)textField{
	if (textField.tag == kCountTextFieldTag) {
		[self getPrice];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField.tag == kCountTextFieldTag) {
		[self getPrice];
	}
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - tableview datasource and delegete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	switch (section) {
		case 1:
			return 4;
		case 0:
		case 2:
			return 1;
	}
	return 0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		UITableViewCell *cell = [[UITableViewCell alloc] init];
		UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, kDescLabelHeight)];
		[descLabel setNumberOfLines:2];
		descLabel.text = _describe;
		[cell.contentView addSubview:descLabel];
		return cell;
	}else if(indexPath.section == 1){
		UITableViewCell *cell = [[UITableViewCell alloc] init];
		UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 50, 20)];
		if (indexPath.row == 0) {
			headline.text = @"类型:";
			NSArray *typeButtonTitles = @[@"纯装",@"纯拆",@"拆装",@"勘察"];
			NSInteger width = (kMainScreenWidth - headline.right - 40) / 4;
			NSInteger offsetX = headline.right;
			for (int i = 0; i < typeButtonTitles.count; i++) {
				UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(offsetX + 10, 0, width, kDescLabelHeight/2)];
				typeButton.centerY = headline.centerY;
				typeButton.layer.borderWidth = 1;
				typeButton.layer.cornerRadius = 2;
				typeButton.tag = i;
				if (_type == i) {
					typeButton.layer.borderColor = KColor.CGColor;
					[typeButton setTitleColor:KColor forState:UIControlStateNormal];
				}else{
					typeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
					[typeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
				}
				[typeButton setTitle:[typeButtonTitles objectAtIndex:i] forState:UIControlStateNormal];
				[typeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchDown];
				[cell.contentView addSubview:typeButton];
				
				offsetX += width + 5;
			}
		}else if(indexPath.row == 1){
			headline.text = @"数量:";
			self.countTextField.left = headline.right + 10;
			self.countTextField.centerY = headline.centerY;
			[cell.contentView addSubview:self.countTextField];
			
			UILabel *unitLb = [[UILabel alloc] initWithFrame:CGRectMake(_countTextField.right+2, 0, 25, 25)];
			unitLb.bottom = _countTextField.bottom;
			unitLb.textColor = [UIColor lightGrayColor];
			unitLb.font = kFont10;
			switch (_amountType) {
				case 0:
					unitLb.text = @"(个)";
					break;
				case 1: unitLb.text = @"(㎡)"; break;
				case 2:unitLb.text = @"(米)"; break;
				default:
					break;
			}
			[cell.contentView addSubview:unitLb];
		}else if(indexPath.row == 2){
			headline.text = @"加急:";
			UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(headline.right+10, 0, 18, 18)];
			bt.centerY = headline.centerY;
			[bt setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
			[bt addTarget:self action:@selector(selectUrgent:) forControlEvents:UIControlEventTouchDown];
			[cell addSubview:bt];
			
			UILabel *introLB = [[UILabel alloc] initWithFrame:CGRectMake(bt.right+10, 0, 110, 18)];
			introLB.centerY = bt.centerY;
			introLB.font = kFont13;
			introLB.textColor = [UIColor lightGrayColor];
			introLB.text = @"12小时内上门安装";
			[cell addSubview:introLB];
			
			UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(introLB.right + 5, 0, 50, 18)];
			addLabel.centerY = bt.centerY;
			addLabel.font = kFont13;
			addLabel.textColor = KColor;
			addLabel.text = @"+ ¥ 100";
			[cell addSubview:addLabel];
		}else if(indexPath.row == 3){
			headline.text = @"  备注:";
			headline.width = 65;
			_remarkTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, kMainScreenWidth - 20, kDescLabelHeight - 40)];
			_remarkTf.centerY = kDescLabelHeight/2 - 5;
			_remarkTf.delegate = self;
			_remarkTf.placeholder = @"请输入..";
			_remarkTf.clearButtonMode = UITextFieldViewModeWhileEditing;
			_remarkTf.font = kFont13;
			_remarkTf.layer.borderWidth = 0.2;
			_remarkTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
			_remarkTf.layer.cornerRadius = 2;
			_remarkTf.leftViewMode = UITextFieldViewModeAlways;
			_remarkTf.leftView = headline;
			[cell.contentView addSubview:_remarkTf];
			return cell;
		}
		[cell.contentView addSubview:headline];
		return cell;
	}else if (indexPath.section == 2){
		_details = [[HbhAppointmentDetailsTableViewCell alloc] init];
		_details.delegate = self;
		return _details;
	}
	return nil;
}

#pragma mark - talbeview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:return kDescLabelHeight;
		case 1:return 70;
		case 2:return 260;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 10;
}

#pragma mark -
//tableview 响应touch事件
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	if ([_remarkTf isFirstResponder]) {
//		[_remarkTf resignFirstResponder];
//	}
//	if ([_countTextField isFirstResponder]) {
//		[_countTextField resignFirstResponder];
//	}

	UIView *view = [self.view.window performSelector:@selector(firstResponder) withObject:nil];
	[view resignFirstResponder];
}

#pragma mark - view lift loop
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.navigationItem.title = _hbhTitle;
	
	_tableView = [[TouchTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.touchDelegate = self;
	_tableView.allowsSelection = NO;
	[self.view addSubview:_tableView];
	
	_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_activityView.frame = CGRectMake(0, 0, 20, 20);
	_activityView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2 - 100);
	[self.view addSubview:_activityView];

	[_activityView startAnimating];
	_netManager = [[HbhAppointmentNetManager alloc] init];
	[_netManager getAppointmentInfoWith:_cateId succ:^(NSDictionary *succDic) {
		_describe = [succDic objectForKey:@"desc"];
		_amountType = [[succDic objectForKey:@"amountType"] integerValue];
		[_activityView stopAnimating];
		[_tableView reloadData];
	} failure:^{
		[_activityView stopAnimating];
//		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"服务器异常或网络错误" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//			if (cancelled) {
//				[self.navigationController popViewControllerAnimated:YES];
//			}
//		} cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
//		[alert show];
	}];
	
	
	
	_footView = [[HbhAppointmentConfirmeView alloc] initWithType:_worker?1:0];
	[_footView.pickWorkerBt addTarget:self action:@selector(pickWorker) forControlEvents:UIControlEventTouchDown];
	[_footView.confirmeButton addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchDown];
	_footView.frame = CGRectMake(0, 0, kMainScreenWidth, 90);
	_tableView.tableFooterView = _footView;
	//初始化键盘通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[_details superViewWillDisappear:_details.tool];
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
