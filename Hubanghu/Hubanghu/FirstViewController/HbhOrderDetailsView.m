//
//  HbhOrderDetailsView.m
//  Hubanghu
//
//  Created by qf on 14/10/22.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderDetailsView.h"
#import "HubOrder.h"
@interface HbhOrderDetailsView ()
@property (nonatomic,strong) UITextField *nameTf;
@property (nonatomic,strong) UITextField *usernameTf;
@property (nonatomic,strong) UITextField *phoneNumTf;
@property (nonatomic,strong) UITextField *amountTf;
@property (nonatomic,strong) UITextField *timeTf;
@property (nonatomic,strong) UITextField *areaTf;
@property (nonatomic,strong) UITextField *workerNameTf;
@property (nonatomic,strong) UITextField *commentTf;
@end

@implementation HbhOrderDetailsView

- (instancetype)init{
	if (self = [super init]) {
		[self setUI];
        self.backgroundColor = kViewBackgroundColor;
	}
	return self;
}

- (instancetype)initWithOrder:(HubOrder *)order{
	if (self = [super init]) {
		[self setUI];
		_nameTf.text = order.name;
		_usernameTf.text = order.username;
		_phoneNumTf.text = [NSString stringWithFormat:@"%.0lf",order.phone];
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.time];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"GMT+8"];
		_timeTf.text = [dateFormatter stringFromDate:date];
		_areaTf.text = [NSString stringWithFormat:@"%.0lf",order.areaId];
		_workerNameTf.text = order.workerName;
		_workerNameTf.text = order.comment;
		switch ((int)order.mountType) {
			case 0:
				_amountTf.text = [NSString stringWithFormat:@"%.0lf(个)",order.amount];
				break;
			case 1:
				_amountTf.text = [NSString stringWithFormat:@"%.2lf(㎡)",order.amount];
				break;
			case 2:
				_amountTf.text = [NSString stringWithFormat:@"%.2lf(米)",order.amount];
				break;
			default:
				break;
		}
	}
	return self;
}

- (void)setUI{
	UITextField *view = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    view.backgroundColor = kClearColor;
	_nameTf = view,
	_usernameTf = view,
	_phoneNumTf = view,
	_amountTf = view,
	_timeTf = view,
	_areaTf = view,
	_workerNameTf = view,
	_commentTf = view;
	
	NSArray *tfArr = @[_nameTf,_usernameTf,_phoneNumTf,_amountTf,_timeTf,_areaTf,_workerNameTf,_commentTf];
	
	NSArray *array = @[@"名称:",@"姓名:",@"手机号",@"数量",@"时间",@"地址",@"安装师傅",@"备注"];
	for (int i = 0; i < tfArr.count; i++) {
		UITextField *tf = [tfArr objectAtIndex:i];
		tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 50*i, self.width, 50)];
		tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
		tf.layer.borderWidth = 0.2;
        tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tf.backgroundColor = [UIColor clearColor];
		tf.enabled = NO; // 设置为不可编辑
		tf.font = kFont13;
		tf.textColor = [UIColor lightGrayColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		label.text = array[i];
		label.font = kFont13;
		label.backgroundColor = kClearColor;
		tf.leftViewMode = UITextFieldViewModeAlways;
		tf.leftView = label;
		[self addSubview:tf];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 self.frame = CGRectMake(50, 50, kMainScreenWidth - 100, 400);
	self.centerX = kMainScreenWidth/2;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.layer.borderWidth = 0.2;
	self.layer.cornerRadius = 5;
	self.backgroundColor = [UIColor whiteColor];

}*/

@end
