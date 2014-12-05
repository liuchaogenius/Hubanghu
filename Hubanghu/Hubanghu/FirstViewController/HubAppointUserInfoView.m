//
//  HubAppointUserInfoView.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HubAppointUserInfoView.h"
#import "HbhUser.h"
#import "AreasDBManager.h"
#import "HbuAreaLocationManager.h"
#import "SVProgressHUD.h"

#define kBorderColor kLineColor//RGBCOLOR(232, 232, 232)
#define kPerTimes 30 //时间间隔 以分钟表示- 不可等于0
#define kButtonTag_Cancel 10
enum TextFieldType
{
    TextField_time = 0,
    TextField_phone,
    TextField_name,
    TextField_location,
    TextField_detailLoc
};
enum PickerType
{
    Picker_date = 1,
    Piker_area
};
@interface HubAppointUserInfoView()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    HbuAreaListModelAreas *_province;
    HbuAreaListModelAreas *_city;
    HbuAreaListModelAreas *_district;
    NSString *_selectAreaId;
    NSTimeInterval _time;
    
    NSString *strCurrentProvice;
    NSString *strCurrentCity;
    NSString *strCurrentDistrict;
    UITextField *currentTextField;
    
    NSMutableArray *_timesArray;
    NSInteger _dateSelectNum;
    NSInteger _timeSelectNum;
    
    UIButton *_cancelBtn;
}

@property (strong, nonatomic) NSArray *placehodeArray;
@property (strong, nonatomic) NSMutableArray *textFiledArray;
//@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *areaPicker;
@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) UIButton *tool;
@property (strong, nonatomic) AreasDBManager *areaManager;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong ,nonatomic) NSMutableArray *districtArray;//区数组
@property (strong, nonatomic) HbuAreaLocationManager *areaLocationManger;
@property (strong, nonatomic) UIView *clearView;
@property (strong, nonatomic) NSDateFormatter *dateFormat;//日期format 不包括时间
@property (strong, nonatomic) NSMutableArray *normalTimesArray;
@property (strong, nonatomic) NSMutableArray *nextSevenDaysDateArray;
@property (strong, nonatomic) NSMutableArray *todayTimesArray;

@end
@implementation HubAppointUserInfoView
#pragma mark - getter and setter
- (NSString *)getUserName
{
    UITextField *tf = self.textFiledArray[TextField_name];
    if (tf && tf.text.length) {
        return tf.text;
    }
    return @"";
}
- (NSString *)getTime
{
    UITextField *tf = self.textFiledArray[TextField_time];
    if (tf && tf.text.length && _time) {
        return [NSString stringWithFormat:@"%lf",_time];
    }
    return @"";
}
- (NSString *)getPhone
{
    UITextField *tf = self.textFiledArray[TextField_phone];
    if (tf && tf.text.length) {
        return tf.text;
    }
    return @"";
}
- (NSString *)getAreaId
{
    UITextField *tf = self.textFiledArray[TextField_location];
    if (tf && tf.text.length && _selectAreaId.length) {
        return _selectAreaId;
    }
    return @"";
}
- (NSString *)getLocation
{
    UITextField *tf = self.textFiledArray[TextField_detailLoc];
    if (tf && tf.text.length) {
        return tf.text;
    }
    return @"";
}

- (UIView *)clearView
{
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight)];
        _clearView.backgroundColor = [UIColor clearColor];
    }
    return _clearView;
}

- (void)setDistrictArrayWithParentId : (double)areaId WithSuccessBlock:(void(^)())success
{
    [self.areaManager selCityOfDistrict:[NSString stringWithFormat:@"%d",(int)areaId] district:^(NSMutableArray *districtArry) {
        _districtArray = districtArry;
        success();
        if (_districtArray && [_areaPicker superview]) {
            [_areaPicker reloadComponent:2];
        }else{
//#warning 为获取到district数据处理
            //[SVProgressHUD showErrorWithStatus:@"获取区数据失败，请检查网络稍后重试" cover:YES offsetY:kMainScreenHeight/2.0f];
        }
        
    }];
    
}

- (void)setCityArrayWithParentId:(double)areaId WithSuccessBlock:(void(^)())success
{
    [self.areaManager selProvinceOfCity:[NSString stringWithFormat:@"%d",(int)areaId] district:^(NSMutableArray *cityArry) {
        _cityArray = cityArry;
        success();
        if (_cityArray && [_areaPicker superview]) {
            [_areaPicker reloadComponent:1];
        }else{
//#warning 为获取到city数据处理
            //[SVProgressHUD showErrorWithStatus:@"获取城市数据失败，请检查网络稍后重试" cover:YES offsetY:kMainScreenHeight/2.0f];
        }
    }];
}

- (HbuAreaLocationManager *)areaLocationManger
{
    if (!_areaLocationManger) {
        _areaLocationManger = [HbuAreaLocationManager sharedManager];
    }
    return _areaLocationManger;
}

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        [self.areaManager selProvince:^(NSMutableArray *cityArry) {
            _provinceArray = cityArry;
            //刷新
            if ([_areaPicker superview] && _provinceArray) {
                [_areaPicker reloadComponent:0];
            }
        }];
    }
    return _provinceArray;
}

- (void)getProvinceArrayWithSuccessBlock:(void(^)())suss
{
    if (!_provinceArray) {
        [self.areaManager selProvince:^(NSMutableArray *cityArry) {
            if (cityArry && cityArry.count) {
                _provinceArray = cityArry;
                suss();
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有地区信息" message:@"请进入首页->右上城市->下拉刷新 获取最新城市信息" delegate:self.delegate cancelButtonTitle:@"确定" otherButtonTitles:@"现在就去", nil];
                [alertView show];
            }
            
        }];
    }
}

- (AreasDBManager *)areaManager
{
    if (!_areaManager) {
        _areaManager = [[AreasDBManager alloc] init];
    }
    return _areaManager;
}

- (UIPickerView *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 200)];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.dataSource =self;
        _datePicker.delegate = self;
        _datePicker.tag = Picker_date;
    }
    return _datePicker;
}

- (UITextField *)getCurrentTextField
{
    if(currentTextField)
    {
        return currentTextField;
    }
    return nil;
}

- (void)setCurrentTextFieldNil
{
    currentTextField = nil;
}

- (UIPickerView *)areaPicker
{
    if (!_areaPicker) {
        _areaPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 200)];
        _areaPicker.backgroundColor = [UIColor whiteColor];
        _areaPicker.dataSource =self;
        _areaPicker.delegate = self;
        _areaPicker.tag = Piker_area;
        _areaPicker.showsSelectionIndicator = YES;
    }
    return _areaPicker;
}

- (NSArray *)placehodeArray
{
    if (!_placehodeArray) {
        _placehodeArray = @[@"选择预约时间",@"输入业主电话",@"输入业主姓名",@"选择省、市、区",@"输入详细地址"];
    }
    return _placehodeArray;
}

- (NSMutableArray *)textFiledArray
{
    if (!_textFiledArray) {
        _textFiledArray = [NSMutableArray arrayWithCapacity:self.placehodeArray.count];
    }
    return _textFiledArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        //UI
        for (int i = 0; i < self.placehodeArray.count; i++) {
            UITextField *textField = [self customTextFieldWithFrame:CGRectMake(10, 10+50*i, kMainScreenWidth-20, 40) andTag:i];
            [self addSubview:textField];
        }
        //载入地址信息以及picker
        [self initLocationInfo];
       
        //用户信息
        if([HbhUser sharedHbhUser].isLogin)
        {
            ((UITextField *)self.textFiledArray[TextField_phone]).text = [HbhUser sharedHbhUser].phone;
            ((UITextField *)self.textFiledArray[TextField_name]).text = [HbhUser sharedHbhUser].nickName;
        }
    }
    return self;
}

- (void)initLocationInfo
{
    __weak HubAppointUserInfoView *weakSelf = self;
    
    if (self.areaLocationManger.currentAreas && self.areaLocationManger.currentAreas.name.length) {
        _city = self.areaLocationManger.currentAreas;
    }else{
        [self.areaManager firstCityOfFirstProvinceResultBlock:^(HbuAreaListModelAreas *model) {
            _city = model;
        }];
    }
    
    [self getProvinceArrayWithSuccessBlock:^{
        //赋初值
        HbuAreaListModelAreas *area = weakSelf.provinceArray[0];
        _province = area;
        
        if (weakSelf.areaLocationManger.currentAreas && weakSelf.areaLocationManger.currentAreas.name.length) {
            //有定位信息，选中定位城市
            for (int i = 0; i < weakSelf.provinceArray.count; i++) {
                HbuAreaListModelAreas *area = weakSelf.provinceArray[i];
                if ((int)area.areaId == (int)weakSelf.areaLocationManger.currentAreas.parent) {
                    _province = area;
                    [self.areaPicker selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }
    }];
    //读取城市
    [weakSelf setCityArrayWithParentId:_city.parent WithSuccessBlock:^{
        for (int i = 0; i < self.cityArray.count; i++) {
            HbuAreaListModelAreas *area = self.cityArray[i];
            if ((int)area.areaId == (int)_city.areaId) {
                [self.areaPicker selectRow:i inComponent:1 animated:YES];
                break;
            }
        }
    }];
    //读取区
    [weakSelf setDistrictArrayWithParentId:_city.areaId WithSuccessBlock:^{
        if (self.areaLocationManger.currentDistrict && self.areaLocationManger.currentDistrict.name.length) {
            _district = self.areaLocationManger.currentDistrict;
            for (int i = 0; i < self.districtArray.count; i++) {
                HbuAreaListModelAreas *area = self.districtArray[i];
                if ((int)area.areaId == (int)_district.areaId) {
                    [self.areaPicker selectRow:i inComponent:2 animated:YES];
                    break;
                }
            }
        }else{
            if(weakSelf.districtArray.count>0)
            {
                _district = weakSelf.districtArray[0];
            }
        }
        
        //地址textField文字
        if (weakSelf.textFiledArray && weakSelf.textFiledArray.count >= TextField_location && _province && _city) {
            ((UITextField *)weakSelf.textFiledArray[TextField_location]).text = [NSString stringWithFormat:@"%@ %@ %@",_province.name,_city.name,_district.name];
            _selectAreaId = [NSString stringWithFormat:@"%d", (int)_district.areaId];
        }
    }];
}


//customed textfield
- (UITextField *)customTextFieldWithFrame:(CGRect)frame andTag:(int)tag
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = self;
    textField.tag = tag;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.placeholder = self.placehodeArray[tag];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = kFont13;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = kBorderColor.CGColor;
    textField.returnKeyType = UIReturnKeyDone;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    imageView.backgroundColor = RGBCOLOR(226, 226, 226);
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"apoinIcon%d",tag+1]];
    [leftView addSubview:imageView];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    self.textFiledArray[tag] = textField;
    
    if (tag == TextField_phone) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return textField;
}

#pragma mark - action

- (void)showDatePickView{
    if (![self.datePicker superview]) {
        
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.top-40, kMainScreenWidth, 40)];
        self.nextSevenDaysDateArray = [self getNextSevenDaysDateArray];
        self.todayTimesArray = [self getTodayTimesArray];
        if(self.todayTimesArray.count == 0)
        {
            _timesArray = [self normalTimesArray];
        }
        else
        {
            _timesArray = self.todayTimesArray;
        }
        _dateSelectNum = 0;
        _timeSelectNum = 0;
        [self.datePicker selectRow:0 inComponent:0 animated:YES];
        [self.datePicker selectRow:0 inComponent:1 animated:YES];
        
        toolView.backgroundColor = [UIColor lightGrayColor];
        _tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60, 0, 60, 40)];
        [_tool setTitle:@"完成" forState:UIControlStateNormal];
        _tool.titleLabel.textAlignment = NSTextAlignmentCenter;
        _tool.titleLabel.font = kFont15;
        _tool.backgroundColor = [UIColor clearColor];
        [_tool addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
        [toolView addSubview:_tool];
        
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.tag = kButtonTag_Cancel;
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelBtn.titleLabel.font = kFont15;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
        [toolView addSubview:_cancelBtn];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.clearView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.datePicker];
        [[UIApplication sharedApplication].keyWindow addSubview:toolView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _datePicker.top = kMainScreenHeight - 180;
            toolView.top = _datePicker.top - 30;
        }];
    }
}

- (void)showAreaPickView
{
    if (self.provinceArray && self.provinceArray.count) {
        [self.areaPicker reloadAllComponents];
        if (![self.areaPicker superview]) {
            UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, _areaPicker.top-30, kMainScreenWidth, 40)];
            toolView.backgroundColor = [UIColor lightGrayColor];
            _tool = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60, 0, 60, 40)];
            [_tool setTitle:@"完成" forState:UIControlStateNormal];
            _tool.titleLabel.textAlignment = NSTextAlignmentCenter;
            _tool.titleLabel.font = kFont15;
            _tool.backgroundColor = [UIColor clearColor];
            [_tool addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
            [toolView addSubview:_tool];
            
            _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
            [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            _cancelBtn.tag = kButtonTag_Cancel;
            _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            _cancelBtn.titleLabel.font = kFont15;
            _cancelBtn.backgroundColor = [UIColor clearColor];
            [_cancelBtn addTarget:self action:@selector(pickerPickEnd:) forControlEvents:UIControlEventTouchDown];
            [toolView addSubview:_cancelBtn];
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.clearView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.areaPicker];
            [[UIApplication sharedApplication].keyWindow addSubview:toolView];
            
            [UIView animateWithDuration:0.2 animations:^{
                _areaPicker.top = kMainScreenHeight - 180;
                toolView.top = _areaPicker.top - 30;
            }];
        }
    }
}
#pragma mark - 用户信息检查
- (BOOL)infoCheck
{
    int i = 0;
    for (i = 0; i < self.textFiledArray.count; i ++) {
        UITextField *tf = self.textFiledArray[i];
        if (!tf.text || tf.text.length <=0) {
            return NO;
            break;
        }
    }
    if (i < self.textFiledArray.count) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark textField FisrtResp check
- (void)checkAlltextFieldFirstRespond
{
    //去除其他view的fisrtrespond
    [self.delegate shouldResignAllFirstResponds];
    
    for (int i = 0; i < self.placehodeArray.count; i++) {
        UITextField *tf = self.textFiledArray[i];
        if ([tf isKindOfClass:[UITextField class]] && tf.isFirstResponder) {
            [tf resignFirstResponder];
        }
    }
}

#pragma mark - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[self checkAlltextFieldFirstRespond];
    if ([self.delegate respondsToSelector:@selector(shouldScrolltoPointY:)]){
        [self.delegate shouldScrolltoPointY:textField.bottom+40];
    }
    currentTextField = textField;
    if (textField.tag == TextField_time) {
        [self checkAlltextFieldFirstRespond];
        [self showDatePickView];
        return NO;
    }else if (TextField_location == textField.tag){
        [self checkAlltextFieldFirstRespond];
        [self showAreaPickView];
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkAlltextFieldFirstRespond];
    if ([self.delegate respondsToSelector:@selector(shouldScrolltoPointY:)]){
        [self.delegate shouldScrolltoPointY:0];
    }
    return YES;
}

- (void)datePickerValueToTextFiled : (UIPickerView *)sender
{
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",self.nextSevenDaysDateArray[_dateSelectNum],_timesArray[_timeSelectNum]];
    UITextField *tf = self.textFiledArray[TextField_time];
    tf.text = dateStr;
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm"; // 设置时间和日期的格式
    selectDateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"GMT+8"];
    NSDate *date = [selectDateFormatter dateFromString:dateStr];
    _time = date.timeIntervalSince1970;
    
}

- (void)areaPikerValueToTextField
{
    _selectAreaId = [NSString stringWithFormat:@"%d",(int)_district.areaId];
    UITextField *tf = self.textFiledArray[TextField_location];
    tf.text = [NSString stringWithFormat:@"%@ %@ %@",_province.name,_city.name,_district.name];
    
}

#pragma mark - 实现DatePicker的监听方法
/*
- (void)datePickerValueChanged : (UIDatePicker *) sender {
    [self datePickerValueToTextFiled:sender];
}
*/
- (void)pickerPickEnd:(UIButton *)sender{
    
    //HbuAreaListModelAreas *area = self.cityArray[0];
    [self.clearView removeFromSuperview];
    [self.delegate shouldScrolltoPointY:0];
    if ([_datePicker superview]) {
        if (sender.tag != kButtonTag_Cancel) {
            [self datePickerValueToTextFiled:self.datePicker];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _datePicker.top = kMainScreenHeight;
            [_datePicker removeFromSuperview];
            [sender.superview removeFromSuperview];
        }];
    }
    if ([_areaPicker superview]) {
        if (sender.tag != kButtonTag_Cancel) {
            [self areaPikerValueToTextField];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _areaPicker.top = kMainScreenHeight;
            [_areaPicker removeFromSuperview];
            [sender.superview removeFromSuperview];
        }];
    }
}

#pragma mark - pickerView delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  pickerView.tag == Piker_area ? 3 : 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (Piker_area == pickerView.tag) {
        if (component == 0) {
            return self.provinceArray.count;
        }else if(component == 1){
            return self.cityArray.count;
        }else if(component == 2){
            return self.districtArray.count;
        }
    }
    else if (Picker_date == pickerView.tag){
        if(component == 0)
        {
            return self.nextSevenDaysDateArray.count; //7天
        }
        else if (component ==1) {
            return _timesArray.count;
            //return 24/0.5; //30分钟一个刻度
        }
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (pickerView.tag == Piker_area) {
        return 100;
    }else if(pickerView.tag == Picker_date) {
        return 140;
    }
    return 0;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == Piker_area) {
        if (component == 0) {
            HbuAreaListModelAreas *area = self.provinceArray[row];
            return area.name;
        }else if(component == 1){
            HbuAreaListModelAreas *area = self.cityArray[row];
            return area.name;
        }else if(component == 2){
            HbuAreaListModelAreas *area = self.districtArray[row];
            return area.name;
        }
    }else if(pickerView.tag == Picker_date){
        if (component == 0) {
            //return 今天  后面 （xxxx年）x月x日（周x）
            NSString *strData = nil;
            if(self.todayTimesArray.count > 0)
            {
                strData = row == 0 ? @"今天" : [self.nextSevenDaysDateArray objectAtIndex:row];
            }
            else
            {
                strData = [self.nextSevenDaysDateArray objectAtIndex:row];
            }
            return strData;
        }else if (component == 1){
            //return 0.30 1.00 1.30
            return _timesArray[row];
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == Piker_area) {
        if (component == 0) {
            _province = self.provinceArray[row];
            [self setCityArrayWithParentId:_province.areaId WithSuccessBlock:^{
                
            }];
            if (self.cityArray.count) {
                _city = self.cityArray[0];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [self setDistrictArrayWithParentId:_city.areaId WithSuccessBlock:^{
                    
                }];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                _district = self.districtArray[0];
            }
        }else if(component == 1){
            _city = self.cityArray[row];
            [self setDistrictArrayWithParentId:_city.areaId WithSuccessBlock:^{
                
            }];
            if (self.districtArray.count) {
                _district = self.districtArray[0];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
        }else if(component == 2){
            _district = self.districtArray[row];
        }
    }
    else if (pickerView.tag == Picker_date){
        //选中处理
        if (component == 0) {
            _dateSelectNum = row;
            if(self.todayTimesArray.count>0)
            {
                _timesArray = (row ? self.normalTimesArray : self.todayTimesArray);
            }
            else
            {
                _timesArray = self.normalTimesArray;
            }
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
        }else if (component == 1){
            _timeSelectNum = row;
        }
    }
}

#pragma mark customDate handle
- (NSDateFormatter *)dateFormat
{
    if (!_dateFormat) {
        _dateFormat = [[NSDateFormatter alloc] init];
        _dateFormat.timeZone = [[NSTimeZone alloc] initWithName:@"GMT+8"];
        [_dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormat;
}
//返回接下去七天的日期
- (NSMutableArray *)getNextSevenDaysDateArray
{
    NSDate *myDate = [NSDate date];
    NSTimeInterval secondsPerDay = 60 * 60 * 24;
    int count = 0;
    int i=0;
    if(self.todayTimesArray.count>0)
    {
        count = 7;
    }
    else
    {
        count = 8;
        i=1;
    }
    NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:0];
    
    for (; i < count; i++) {
        NSDate *date = [NSDate dateWithTimeInterval:secondsPerDay*i sinceDate:myDate];
        NSString *dateStr = [self.dateFormat stringFromDate:date];
        [dateArray addObject:dateStr];
    }
    //dateArray[0] = @"今天";
    return dateArray;
}
//非今天状态下 的时间 hh：mm
- (NSMutableArray *)normalTimesArray
{
    if (!_normalTimesArray) {
        _normalTimesArray = [NSMutableArray arrayWithCapacity:(24*30/kPerTimes)];
        int i,j;
        for (i = 8; i < 21; i++) {
            for (j = 0; j < 60; j+=kPerTimes) {
                [_normalTimesArray addObject:[NSString stringWithFormat:@"%02d:%02d",i,j]];
            }
        }
    }
    return _normalTimesArray;
}

- (NSMutableArray *)getTodayTimesArray
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    int number = (currentComps.hour-8) * (int)(60/kPerTimes) + (int)(currentComps.minute/kPerTimes);
    if(currentComps.hour<8)
    {
        number=-1;
    }
    //NSString *minStr = [];
    NSMutableArray *todayTimesArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = number + 1; i < self.normalTimesArray.count; i++) {
        [todayTimesArray addObject:self.normalTimesArray[i]];
    }
    return todayTimesArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
