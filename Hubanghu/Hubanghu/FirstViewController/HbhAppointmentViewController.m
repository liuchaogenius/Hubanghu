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
#import "FBKVOController.h"
#import "STAlerView.h"
#import "SecondViewController.h"
#import "HbhWorkers.h"
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
//UI
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) HbhAppointmentConfirmeView *footView;
@property (nonatomic,strong) UITextField *countTextField;

@end

@implementation HbhAppointmentViewController

- (instancetype)initWithTitle:(NSString *)title cateId:(NSString *)cateId andWork:(HbhWorkers *)worker{
	if (self = [super init]) {
		_hbhTitle = title;
		_cateId = cateId;
		_worker = worker;
		_urgent = NO;
		_type = 0;
	}
	return self;
}

- (void)getPirce{
	if (![_countTextField.text isEqualToString:@""]) {
		NSDictionary *dic = @{@"type":@(_type),
							  @"amountType":@(_amountType),
							  @"amount":_countTextField.text,
							  @"urgent":@(_urgent)};
		[_netManager getAPpointmentPriceWith:dic succ:^(NSString *price) {
			_footView.price = [price doubleValue];
		}];
	}
}

#pragma mark - button event

- (void)pickWorker{
	SecondViewController *vc = [[SecondViewController alloc] initAndUseWorkerDetailBlock:^(HbhWorkers *aWorkerModel) {
		_worker = aWorkerModel;
		[_footView.pickWorkerBt setTitle:_worker.name forState:UIControlStateNormal];
	}];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmeOrder{
	
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
	[self getPirce];
}

- (void)selectUrgent:(UIButton *)sender{
	_urgent = _urgent ? NO:YES;
	if (_urgent) {
		[sender setImage:[UIImage imageNamed:@"rectangleUp"] forState:UIControlStateNormal];
	}else{
		[sender setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
	}
	[self getPirce];
}

#pragma mark - delegate
- (void)didDatePickerAppear{
	_tableView.height -= 150;
	[UIView animateWithDuration:0.2 animations:^{
		[_tableView setContentOffset:CGPointMake(0, 150)];
	}];
}

- (void)didDatePickerDisappear{
	_tableView.height += 150;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField.tag == kCountTextFieldTag) {
		[self getPirce];
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
			_countTextField = [[UITextField alloc] initWithFrame:CGRectMake(headline.right + 10, 20, 80, kDescLabelHeight - 40)];
			_countTextField.centerY = headline.centerY;
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
			[cell.contentView addSubview:_countTextField];
			
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
			UITextField *remarkTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, kMainScreenWidth - 20, kDescLabelHeight - 40)];
			remarkTf.centerY = kDescLabelHeight/2 - 5;
			remarkTf.delegate = self;
			remarkTf.placeholder = @"请输入..";
			remarkTf.clearButtonMode = UITextFieldViewModeWhileEditing;
			remarkTf.font = kFont13;
			remarkTf.layer.borderWidth = 1;
			remarkTf.layer.borderColor = [UIColor lightGrayColor].CGColor;
			remarkTf.layer.cornerRadius = 2;
			remarkTf.leftViewMode = UITextFieldViewModeAlways;
			remarkTf.leftView = headline;
			[cell.contentView addSubview:remarkTf];
			return cell;
		}
		[cell.contentView addSubview:headline];
		return cell;
	}else if (indexPath.section == 2){
		HbhAppointmentDetailsTableViewCell *details = [[HbhAppointmentDetailsTableViewCell alloc] init];
		details.delegate = self;
		return details;
	}
	return nil;
}

#pragma mark - talbeview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section) {
		case 0:return kDescLabelHeight;
		case 1:return 70;
		case 2:return 235;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 10;
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//	return nil;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//	return nil;
//}
#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification{
	NSDictionary *info = [notification userInfo];
	//获取高度
	NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
	CGSize hightSize = [value CGRectValue].size;
	_tableView.height -= hightSize.height;
	[UIView animateWithDuration:0.2 animations:^{
		[_tableView setContentOffset:CGPointMake(0, hightSize.height)];
	}];

//	_tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - hightSize.height);
}

- (void)keyboardWillHide:(NSNotification *)notification{
	NSDictionary *info = [notification userInfo];
	//获取高度
	NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
	CGSize hightSize = [value CGRectValue].size;
	_tableView.height += hightSize.height;
}

#pragma mark - view lift loop
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.navigationItem.title = _hbhTitle;
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
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
	[_footView.confirmeButton addTarget:self action:@selector(confirmeOrder) forControlEvents:UIControlEventTouchDown];
	_footView.frame = CGRectMake(0, 0, kMainScreenWidth, 90);
	_tableView.tableFooterView = _footView;
	//初始化键盘通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
