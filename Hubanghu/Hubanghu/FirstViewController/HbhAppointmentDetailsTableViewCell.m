//
//  HbhAppointmentDetailsTableViewCell.m
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhAppointmentDetailsTableViewCell.h"
#import "HbhUser.h"
#import "AreasDBManager.h"
#import "HbuAreaListModelAreas.h"
@interface HbhAppointmentDetailsTableViewCell (){
}
@property (nonatomic,strong) HbuAreaListModelAreas *province;
@property (nonatomic,strong) HbuAreaListModelAreas *city;
@property (nonatomic,strong) HbuAreaListModelAreas *district;
@property (nonatomic,strong) NSMutableArray *provinceArr;
@property (nonatomic,strong) NSMutableArray *cityArr;
@property (nonatomic,strong) NSMutableArray *districtArr;

@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,strong) AreasDBManager *areaManager;
@property (nonatomic,strong) HbhUser *user;
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
			UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
			imageView.backgroundColor = RGBCOLOR(226, 226, 226);
			imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"apoinIcon%d",i+1]];
			[leftView addSubview:imageView];
			tf.leftView = leftView;
			tf.leftViewMode = UITextFieldViewModeAlways;
		}
		_timeTF.enabled = NO; //时间和地区使用选择器
		_areaTF.enabled = NO;
		_userNameTF.keyboardType = UIKeyboardTypeDefault;
		_detailAreaTF.keyboardType = UIKeyboardTypeDefault;
		_phoneNumberTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 200)];
		_datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		_datePicker.date = [NSDate date];
		_datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT+8"];
		_datePicker.backgroundColor = [UIColor whiteColor];
		[_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
		
		_areaPicker = [[UIPickerView alloc] initWithFrame:_datePicker.frame];
		_areaPicker.backgroundColor = [UIColor whiteColor];
		_areaPicker.dataSource =self;
		_areaPicker.delegate = self;
	}
	return self;
}

- (void)superViewWillDisappear:(id)sender{
	[self datePickerPickEnd:sender];
}

#pragma mark - lazy init

- (UIActivityIndicatorView *)activityView{
	if (!_activityView) {
		_activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		_activityView.centerX = self.window.centerX;
		_activityView.centerY = self.window.centerY;
		[self addSubview:_activityView];
	}
	return _activityView;
}

- (HbhUser *)user{
	if (!_user) {
		_user = [HbhUser sharedHbhUser];
	}
	return _user;
}

- (AreasDBManager *)areaManager{
	if (!_areaManager) {
		_areaManager = [[AreasDBManager alloc] init];
	}
	return _areaManager;
}

#pragma mark - 实现DatePicker的监听方法
- (void)datePickerValueChanged:(UIDatePicker *) sender {
	NSDate *select = [sender date]; // 获取被选中的时间
	NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
	selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm"; // 设置时间和日期的格式
	NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
	_timeTF.text = dateAndTime;
	_time = select.timeIntervalSince1970;
}

- (void)datePickerPickEnd:(UIButton *)sender{
	if ([_datePicker superview]) {
		[UIView animateWithDuration:0.2 animations:^{
			_datePicker.top = kMainScreenHeight;
			[_datePicker removeFromSuperview];
			[_delegate didDatePickerDisappear];
			[sender.superview removeFromSuperview];
		}];
	}else if([_areaPicker superview]){
		[UIView animateWithDuration:0.2 animations:^{
			_areaPicker.top = kMainScreenHeight;
			[_areaPicker removeFromSuperview];
			[_delegate didDatePickerDisappear];
			[sender.superview removeFromSuperview];
		}];
		if (_district) {
			_selectAreaId = [NSString stringWithFormat:@"%.0lf",_district.areaId];
			_areaTF.text = [NSString stringWithFormat:@"%@ %@ %@",_province.name,_city.name,_district.name];
		}
	}
}
#pragma mark - pickerView delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if (component == 0) {
		return _provinceArr.count;
	}else if(component == 1){
		return _cityArr.count;
	}else if(component == 2){
		return _districtArr.count;
	}
	return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 20;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if (component == 0) {
		HbuAreaListModelAreas *area = _provinceArr[row];
		return area.name;
	}else if(component == 1){
		HbuAreaListModelAreas *area = _cityArr[row];
		return area.name;
	}else if(component == 2){
		HbuAreaListModelAreas *area = _districtArr[row];
		return area.name;
	}
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if (component == 0) {
		_province = _provinceArr[row];
		[self setCityArrWithAreaId:_province.areaId];
		if (_cityArr.count) {
			_city = _cityArr[0];
			[pickerView selectRow:0 inComponent:1 animated:YES];
			[self setDistrictArrWithAreaId:_city.areaId];
			[pickerView selectRow:0 inComponent:2 animated:YES];
			_district = _districtArr[0];
		}
	}else if(component == 1){
		_city = _cityArr[row];
		[self setDistrictArrWithAreaId:_city.areaId];
		if (_districtArr.count) {
			_district = _districtArr[0];
			[pickerView selectRow:0 inComponent:2 animated:YES];
		}
	}else if(component == 2){
		_district = _districtArr[row];
	}
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

#pragma mark -

- (void)setCityArrWithAreaId:(double)areaId{
	NSString *area;
	kIntToString(area,(int)areaId);
	[self.areaManager selProvinceOfCity:area district:^(NSMutableArray *cityArry) {
		_cityArr = cityArry;
	}];
	if ([_areaPicker superview]) {
		[_areaPicker reloadComponent:1];
	}
}

- (void)setDistrictArrWithAreaId:(double)areaId{
	NSString *area;
	kIntToString(area, (int)areaId);
	[self.areaManager selCityOfDistrict:area district:^(NSMutableArray *districtArry) {
		_districtArr = districtArry;
	}];
	if ([_areaPicker superview]) {
		[_areaPicker reloadComponent:2];
	}
}

- (void)showAreaPickView{
	[self.activityView startAnimating];
	[self.areaManager selProvince:^(NSMutableArray *cityArry) {
		_provinceArr = cityArry;
	}];
    /*
	if (self.user.currentArea) {
		for (int i = 0; i < _provinceArr.count; i++) {
			HbuAreaListModelAreas *area = _provinceArr[i];
			if (area.areaId == self.user.currentArea.parent) {
				_province = area;
				[_areaPicker selectRow:i inComponent:0 animated:YES];
				break;
			}
		}
	}else{*/
		_province = _provinceArr[0];
	//}
	
/*
	if (self.user.currentArea) {
		_city = self.user.currentArea;
		[self setCityArrWithAreaId:self.user.currentArea.parent];
		[self setDistrictArrWithAreaId:self.user.currentArea.areaId];
		_district = _districtArr[0];
	}else{ */
		[self setCityArrWithAreaId:_province.areaId];
		_city = _cityArr[0];
		[self setDistrictArrWithAreaId:_city.areaId];
		_district = _districtArr[0];
	//}
	[self.activityView stopAnimating];
	
	if (![self.areaPicker superview]) {
		[self.window addSubview:_areaPicker];
		[_delegate didDatePickerAppear];
		UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, _areaPicker.top-30, kMainScreenWidth, 30)];
		toolView.backgroundColor = [UIColor lightGrayColor];
		_tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 50, 0, 30, 30)];
		[_tool setTitle:@"完成" forState:UIControlStateNormal];
		_tool.titleLabel.textAlignment = NSTextAlignmentCenter;
		_tool.titleLabel.font = kFont13;
		_tool.backgroundColor = [UIColor clearColor];
		[_tool addTarget:self action:@selector(datePickerPickEnd:) forControlEvents:UIControlEventTouchDown];
		[toolView addSubview:_tool];
		[self.window addSubview:toolView];
		
		[UIView animateWithDuration:0.2 animations:^{
			_areaPicker.top = kMainScreenHeight - 200;
			toolView.top = _areaPicker.top - 30;
		}];
	}
	
}

- (void)showDatePickView{
	if (![_datePicker superview]) {
		[self.window addSubview:_datePicker];
		[_delegate didDatePickerAppear];
		UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.top-30, kMainScreenWidth, 30)];
		toolView.backgroundColor = [UIColor lightGrayColor];
		_tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 50, 0, 30, 30)];
		[_tool setTitle:@"完成" forState:UIControlStateNormal];
		_tool.titleLabel.textAlignment = NSTextAlignmentCenter;
		_tool.titleLabel.font = kFont13;
		_tool.backgroundColor = [UIColor clearColor];
		[_tool addTarget:self action:@selector(datePickerPickEnd:) forControlEvents:UIControlEventTouchDown];
		[toolView addSubview:_tool];
		[self.window addSubview:toolView];
		
		[UIView animateWithDuration:0.2 animations:^{
			_datePicker.top = kMainScreenHeight - 200;
			toolView.top = _datePicker.top - 30;
		}];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	for (UITouch *touch in touches) {
		if ([_userNameTF isFirstResponder]) {
			[_userNameTF resignFirstResponder];
		}else if([_phoneNumberTF isFirstResponder]){
			[_phoneNumberTF resignFirstResponder];
		}else if([_detailAreaTF isFirstResponder]){
			[_detailAreaTF resignFirstResponder];
		}
		
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
