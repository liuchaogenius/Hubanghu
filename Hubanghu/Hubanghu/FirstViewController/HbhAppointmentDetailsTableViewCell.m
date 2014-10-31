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
#import "HbuAreaLocationManager.h"
#import "STAlerView.h"
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
@property (nonatomic,strong) HbuAreaLocationManager *areaLocationManager;
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

- (HbuAreaLocationManager *)areaLocationManager{
	if (!_areaLocationManager) {
		_areaLocationManager = [HbuAreaLocationManager sharedManager];
	}
	return _areaLocationManager;
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
	}
	if([_areaPicker superview]){
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
	[self.activityView startAnimating];
	
	[self.areaManager selProvinceOfCity:area district:^(NSMutableArray *cityArry) {
		_cityArr = cityArry;
	}];
	if (!_cityArr) {
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"地区信息获取失败" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			
		} cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alert show];
	}
	[self.activityView stopAnimating];
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
	if (!_districtArr) {
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"地区信息获取失败" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			
		} cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alert show];
	}
	if ([_areaPicker superview]) {
		[_areaPicker reloadComponent:2];
	}
}

- (void)showAreaPickView{
	//获取省份信息
	[self.areaManager selProvince:^(NSMutableArray *cityArry) {
		_provinceArr = cityArry;
	}];
	
	//地区信息错误时 弹出警告
	if (!_provinceArr || _provinceArr.count == 0) {
		STAlertView *alert = [[STAlertView alloc] initWithTitle:@"抱歉" message:@"地区信息获取失败" clickedBlock:^(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
			
		} cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alert show];
		return;
	}
	
	MLOG(@"%@",self.areaLocationManager.currentAreas);
	
	if (self.areaLocationManager.currentAreas && (int)self.areaLocationManager.currentAreas.areaId != 0) {
		//当定位成功时 将省市区设置为对应地区
		for (int i = 0; i < _provinceArr.count; i++) {
			HbuAreaListModelAreas *area = _provinceArr[i];
			if (area.areaId == _areaLocationManager.currentAreas.parent) {
				_province = area;
				[_areaPicker selectRow:i inComponent:0 animated:YES];
				break;
			}
		}
		_city = self.areaLocationManager.currentAreas;
		[self setCityArrWithAreaId:_city.parent];
		for (int i = 0; i < _cityArr.count; i++) {
			HbuAreaListModelAreas *area = _cityArr[i];
			if (area.areaId == _city.areaId) {
				[_areaPicker selectRow:i inComponent:1 animated:YES];
				break;
			}
		}
		[self setDistrictArrWithAreaId:_city.areaId];
		if (_districtArr && _districtArr.count > 0) {
			_district = _districtArr[0];
		}
	}else{	//用户没有定位成功时  显示数据中对应第一项
		if (_provinceArr.count != 0) {
			_province = _provinceArr[0];
		}
		[self setCityArrWithAreaId:_province.areaId];
		if (_cityArr) {
			_city = _cityArr[0];
		}
		[self setDistrictArrWithAreaId:_city.areaId];
		if (_districtArr) {
			_district = _districtArr[0];
		}
	}
	
	if (![self.areaPicker superview]) {
		[_delegate didDatePickerAppear];
		[self.window addSubview:_areaPicker];
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
			if ([_areaPicker superview]) {
				[self datePickerPickEnd:_tool];
			}
			[self showDatePickView];
		}else if (CGRectContainsPoint(_areaTF.frame, touchPoint)){
			if ([_datePicker superview]) {
				[self datePickerPickEnd:_tool];
			}
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
