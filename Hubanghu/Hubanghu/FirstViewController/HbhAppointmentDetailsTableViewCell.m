//
//  HbhAppointmentDetailsTableViewCell.m
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhAppointmentDetailsTableViewCell.h"

@interface HbhAppointmentDetailsTableViewCell (){
	
}


@end

@implementation HbhAppointmentDetailsTableViewCell

- (instancetype)init
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppointmentDetailsCell" owner:self options:nil];
	self = nib[0];
	if (self) {
		NSArray *arr = @[_timeTF,_phoneNumberTF,_userNameTF,_areaTF,_detailAreaTF];
		for (int i = 0; i < arr.count; i++) {
			UITextField *tf = arr[i];
			tf.layer.borderWidth = 1;
			tf.layer.borderColor = RGBCOLOR(226, 226, 226).CGColor;
			tf.delegate = self;
			tf.clearButtonMode = UITextFieldViewModeWhileEditing;
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
			imageView.backgroundColor = RGBCOLOR(226, 226, 226);
			imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"apoinIcon%d",i+1]];
			tf.leftView = imageView;
			tf.leftViewMode = UITextFieldViewModeAlways;
		}
		_timeTF.enabled = NO;
		
		_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 200)];
		_datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		_datePicker.date = [NSDate date];
		_datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT+8"];
		_datePicker.backgroundColor = [UIColor whiteColor];
		[_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	}
	return self;
}

#pragma mark - 实现DatePicker的监听方法
- (void)datePickerValueChanged:(UIDatePicker *) sender {
	NSDate *select = [sender date]; // 获取被选中的时间
	NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
	selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm"; // 设置时间和日期的格式
	NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
	_timeTF.text = dateAndTime;
}

- (void)datePickerPickEnd:(UIButton *)sender{
	[UIView animateWithDuration:0.2 animations:^{
		_datePicker.top = kMainScreenHeight;
		[_datePicker removeFromSuperview];
		[_delegate didDatePickerDisappear];
		[sender.superview removeFromSuperview];
	}];
}
#pragma mark - pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return 1;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}
//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, 20, 0);
}

- (void)showDatePickView{
	if (![_datePicker superview]) {
		[self.window addSubview:_datePicker];
		[_delegate didDatePickerAppear];
		UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.top-30, kMainScreenWidth, 30)];
		toolView.backgroundColor = [UIColor lightGrayColor];
		UIButton *tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 50, 0, 30, 30)];
		[tool setTitle:@"完成" forState:UIControlStateNormal];
		tool.titleLabel.textAlignment = NSTextAlignmentCenter;
		tool.titleLabel.font = kFont13;
		tool.backgroundColor = [UIColor clearColor];
		[tool addTarget:self action:@selector(datePickerPickEnd:) forControlEvents:UIControlEventTouchDown];
		[toolView addSubview:tool];
		[self.window addSubview:toolView];

		[UIView animateWithDuration:0.2 animations:^{
			_datePicker.top = kMainScreenHeight - 200;
			toolView.top = _datePicker.top - 30;
		}];
	}
}

- (void)showAreaPickView{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	for (UITouch *touch in touches) {
		CGPoint touchPoint = [touch locationInView:self];
		if(CGRectContainsPoint(_timeTF.frame, touchPoint)){
			[self showDatePickView];
		}else if (CGRectContainsPoint(_areaTF.frame, touchPoint)){
			[self showAreaPickView];
		}else {
			
		}
	}
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
