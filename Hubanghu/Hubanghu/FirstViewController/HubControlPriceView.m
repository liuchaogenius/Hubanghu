//
//  HubControlPriceView.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HubControlPriceView.h"
#import "HbhAppointmentNetManager.h"
#import "SVProgressHUD.h"
#define kTitleFont 15
#define kCateTitleFont  15
#define kBorderColor kLineColor//RGBCOLOR(207, 207, 207)
#define kCateViewHeight (kCateTitleFont+10)*4
@interface HubControlPriceView()
{
    NSArray *categoryTitlearry;
    NSArray *countArry;
    NSArray *unitArry;
    int cateButtonType;
    int countType;
    BOOL uragent;
    NSString *strCountValue;
    
    UITextField *countTextField;
    int offsetY;
    //NSString *strRemark;
    UITextField *remarkTextField;
    
    UILabel *_countTitleLabel; //数量title
    UILabel *_unitLabel; //单位label
    
    NSString *_cateId;
    UIView *_cateView;
    UILabel *_cateTitleLabel;
    
}
@property (strong, nonatomic) HbhAppointmentNetManager *netManager;
@property (strong, nonatomic) NSMutableArray *cateButtonArray;
@property (strong, nonatomic) UIView *cateListView;
@property (strong, nonatomic) UIView *clearBackView;
@end

@implementation HubControlPriceView

#pragma mark - getter and setter

- (UIView *)clearBackView
{
    if (!_clearBackView) {
        _clearBackView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _clearBackView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCateListView)];
        [_clearBackView addGestureRecognizer:tapGR];
    }
    return _clearBackView;
}

- (UIView *)cateListView
{
    if (!_cateListView) {
        _cateListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, (kCateTitleFont+10)*4)];
        _cateListView.backgroundColor = [UIColor whiteColor];
        _cateListView.clipsToBounds = YES;
        _cateListView.layer.borderWidth = 1.0f;
        _cateListView.layer.cornerRadius = 2.0f;
        _cateListView.layer.borderColor = [kLineColor CGColor];
        _cateButtonArray = [NSMutableArray arrayWithCapacity:categoryTitlearry.count];
        for(int i=0; i<4; i++)
        {
            
            UIButton *cateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (kCateTitleFont+10)*i, 80, kCateTitleFont+10)];
            [cateButton.titleLabel setFont:[UIFont systemFontOfSize:kCateTitleFont]];
            cateButton.layer.borderWidth = 0.5;
            //cateButton.layer.cornerRadius = 2;
            cateButton.tag = i;
            if (cateButtonType == i)
            {
                //cateButton.selected = YES;
                cateButton.layer.borderColor = KColor.CGColor;
                [cateButton setTitleColor:KColor forState:UIControlStateNormal];
            }
            else
            {
                cateButton.layer.borderColor = kBorderColor.CGColor;
                [cateButton setTitleColor:kBorderColor forState:UIControlStateNormal];
            }
            [cateButton setTitle:[categoryTitlearry objectAtIndex:i] forState:UIControlStateNormal];
            [cateButton addTarget:self action:@selector(cateButtonItem:) forControlEvents:UIControlEventTouchUpInside];
            [_cateListView addSubview:cateButton];
            [self.cateButtonArray insertObject:cateButton atIndex:i];
        }
        _cateListView.tag = 0;
    }
    return _cateListView;
}

- (NSString *)getCateButtonType
{
    return [NSString stringWithFormat:@"%d",cateButtonType];
}
- (NSString *)getUrgent
{
    return [NSString stringWithFormat:@"%d",uragent];
}
- (NSString *)getMountType//种类
{
    return [NSString stringWithFormat:@"%d",countType];
}
- (NSString *)getAmount//数量
{
    if (countTextField.text && countTextField.text.length) {
        return countTextField.text;
    }
    return @" ";
}
- (NSString *)getComment//备注
{
    return  (remarkTextField.text.length ? remarkTextField.text : @"");
}

- (HbhAppointmentNetManager *)netManager
{
    if (!_netManager) {
        _netManager = [[HbhAppointmentNetManager alloc] init];
    }
    return _netManager;
}

- (void)setCountType:(int)aType
{
    countType = aType;
    if (_countTitleLabel && _unitLabel) {
        _countTitleLabel.text = countArry[countType];
        _unitLabel.text = unitArry[countType];
    }
}

- (void)setCateButtonType:(int)aType
{
    cateButtonType = aType;
}

- (void)setCateId:(NSString *)cateId
{
    _cateId = cateId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        categoryTitlearry = @[@"纯装",@"纯拆",@"拆装",@"勘察"];
        countArry = @[@"数量:",@"面积:",@"长度:"];
        unitArry = @[@"(个)",@"(㎡)",@"(米)"];
        
        cateButtonType = 0; //0起步 0，1，2，3
        countType = 0;
        uragent = NO;
        
        offsetY = 20;
        
        //input
        //UI
        self.backgroundColor = [UIColor whiteColor];
        [self createCategoryButton:countType];
        [self createCountview];
        [self createExpeditedView];
        [self createRemarkview];
    }
    return self;
}



- (void)createCategoryButton:(int)aMountType
{
    UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    categoryTitle.backgroundColor = kClearColor;
    categoryTitle.textAlignment = NSTextAlignmentCenter;
    categoryTitle.text = @"类型:";
    [categoryTitle setFont:[UIFont systemFontOfSize:kTitleFont]];
    categoryTitle.textColor = [UIColor blackColor];
    [self addSubview:categoryTitle];
    
    _cateButtonArray = [NSMutableArray arrayWithCapacity:categoryTitlearry.count];
    for(int i=0; i<4; i++)
    {
        
        UIButton *cateButton = [[UIButton alloc] initWithFrame:CGRectMake(categoryTitle.right+10+(i*50+(i)*15), categoryTitle.top, 60, kCateTitleFont+6)];
        [cateButton.titleLabel setFont:[UIFont systemFontOfSize:kCateTitleFont]];
        cateButton.layer.borderWidth = 1;
        cateButton.layer.cornerRadius = 2;
        cateButton.tag = i;
        if (cateButtonType == i)
        {
            //cateButton.selected = YES;
            cateButton.layer.borderColor = KColor.CGColor;
            [cateButton setTitleColor:KColor forState:UIControlStateNormal];
        }
        else
        {
            cateButton.layer.borderColor = kBorderColor.CGColor;
            [cateButton setTitleColor:kBorderColor forState:UIControlStateNormal];
        }
        [cateButton setTitle:[categoryTitlearry objectAtIndex:i] forState:UIControlStateNormal];
        [cateButton addTarget:self action:@selector(cateButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cateButton];
        [self.cateButtonArray insertObject:cateButton atIndex:i];
    }
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, categoryTitle.bottom+20, kMainScreenWidth, 1)];
    lineview.backgroundColor = RGBCOLOR(232, 232, 232);
    [self addSubview:lineview];
    //_cateView = cateView;
    offsetY = lineview.bottom+20;
}



- (void)createCountview
{
    UILabel *countTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    countTitleLabel.font = [UIFont systemFontOfSize:kTitleFont];
    countTitleLabel.backgroundColor = kClearColor;
    countTitleLabel.textAlignment = NSTextAlignmentCenter;
    _countTitleLabel = countTitleLabel;
    if(countType < [countArry count])
    {
        countTitleLabel.text = [countArry objectAtIndex:(countType)];
    }
    countTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:countTitleLabel];
    
    if(!countTextField)
    {
        countTextField = [[UITextField alloc] initWithFrame:CGRectMake(countTitleLabel.right+10, countTitleLabel.top, 80, 30)];
    
        countTextField.centerY = countTitleLabel.centerY;
        [self addSubview:countTextField];
    }
    
    countTextField.tag	= 0;
    countTextField.delegate = self;
    countTextField.placeholder = @"请输入..";
    countTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    countTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    countTextField.returnKeyType = UIReturnKeyDone;
    countTextField.font = kFont13;
    countTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    countTextField.textAlignment = NSTextAlignmentLeft;
    countTextField.layer.borderWidth = 1;
    countTextField.layer.borderColor = kBorderColor.CGColor;
    countTextField.layer.cornerRadius = 2;
    countTextField.delegate = self;
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(countTextField.right+3, countTextField.bottom-13, 28, 15)];
    unitLabel.bottom = countTextField.bottom;
    unitLabel.font = [UIFont systemFontOfSize:kTitleFont - 2];
    unitLabel.backgroundColor = kClearColor;
    unitLabel.textAlignment = NSTextAlignmentCenter;
    _unitLabel = unitLabel;

    if((countType) < [unitArry count])
    {
        unitLabel.text = [unitArry objectAtIndex:(countType)];
    }
    unitLabel.textColor = kBorderColor;
    [self addSubview:unitLabel];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, countTitleLabel.bottom+20, kMainScreenWidth, 1)];
    lineview.backgroundColor = RGBCOLOR(232, 232, 232);
    [self addSubview:lineview];
    
    offsetY = lineview.bottom+20;
}

- (void)createExpeditedView
{
    UILabel *expeditedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    expeditedTitleLabel.backgroundColor = kClearColor;
    expeditedTitleLabel.textAlignment = NSTextAlignmentCenter;
    expeditedTitleLabel.text = @"加急:";
    expeditedTitleLabel.font = [UIFont systemFontOfSize:kTitleFont];
    expeditedTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:expeditedTitleLabel];
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(expeditedTitleLabel.right+10, expeditedTitleLabel.top, 18, 18)];
    bt.selected = uragent;
    [bt setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"rectangleUp"] forState:UIControlStateSelected];
    [bt addTarget:self action:@selector(selectUrgent:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:bt];
    
    UILabel *uragentDesc = [[UILabel alloc] initWithFrame:CGRectMake(bt.right+8, bt.top, 110, 12)];
    uragentDesc.backgroundColor = kClearColor;
    uragentDesc.centerY = bt.centerY;
    uragentDesc.font = [UIFont systemFontOfSize:kTitleFont-2];
    uragentDesc.textColor = [UIColor grayColor];
    uragentDesc.text = @"12小时内上门安装";
    [self addSubview:uragentDesc];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(uragentDesc.right, uragentDesc.top, 50, 12)];
    //MLOG(@"%d %d %d %d",addLabel.frame.origin.x,addLabel.frame.origin.y,addLabel.frame.size.width,addLabel.frame.size.height);
    addLabel.backgroundColor = [UIColor clearColor];
    addLabel.font = [UIFont systemFontOfSize:kTitleFont-2];
    addLabel.textColor = KColor;
    addLabel.text = @"+ ¥ 100";
    [self addSubview:addLabel];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, expeditedTitleLabel.bottom+20, kMainScreenWidth, 1)];
    lineview.backgroundColor = RGBCOLOR(232, 232, 232);
    [self addSubview:lineview];
    
    offsetY = lineview.bottom+20;
}

- (void)createRemarkview
{
    //UIView *remarkView = [[UIView alloc] initWithFrame:CGRectMake(10, offsetY, kMainScreenWidth-20, 50)];
    UILabel *remarkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    remarkTitleLabel.text = @"备注:";
    remarkTitleLabel.font = [UIFont systemFontOfSize:kTitleFont];
    remarkTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remarkTitleLabel];
    
    if (!remarkTextField) {
        remarkTextField = [[UITextField alloc] initWithFrame:CGRectMake(remarkTitleLabel.right+10, remarkTitleLabel.top,kMainScreenWidth - remarkTitleLabel.right-10-20,30)];
        remarkTextField.centerY = remarkTitleLabel.centerY;
        remarkTextField.delegate = self;
        remarkTextField.tag = 0;
        remarkTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        remarkTextField.placeholder = @"请输入备注信息";
        remarkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        remarkTextField.returnKeyType = UIReturnKeyDone;
        remarkTextField.font = kFont13;
        remarkTextField.textAlignment = NSTextAlignmentLeft;
        remarkTextField.layer.borderWidth = 1;
        remarkTextField.layer.borderColor = kBorderColor.CGColor;
        remarkTextField.layer.cornerRadius = 2.0;
        [self addSubview:remarkTextField];
    }
    
}

#pragma mark - Action

- (BOOL)infoCheck
{
    if (countTextField.text && countTextField.text.length) {
        //价格相关页面只需检查数量，其他均有初值
        return YES;
    }else{
        return NO;
    }
}

- (void)getPrice
{
    if (countTextField && countTextField.text.length && _cateId) {
        [self.netManager getAppointmentPriceWithCateId:_cateId type:cateButtonType amountType:countType amount:countTextField.text urgent:uragent succ:^(NSString *price) {
            //通知vc修改价格
            [self.delegate priceChangedWithPrice:price];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"网络请求失败，请检查网络!" cover:YES offsetY:kMainScreenHeight/2.0];
        }];
    }
}

- (void)selectUrgent:(UIButton*)aBut
{
    aBut.selected = !aBut.selected;
    uragent = aBut.selected;
//    if (uragent) {
//        [aBut setImage:[UIImage imageNamed:@"rectangleUp"] forState:UIControlStateNormal];
//    }else{
//        [aBut setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
//    }
//    uragent = !uragent;
    if (countTextField && countTextField.text.length) {
        [self getPrice];
    }
    MLOG(@"%d",uragent);
    
}

- (void)cateButtonItem:(UIButton *)aBut
{
    
    if (aBut.tag != cateButtonType) {
        UIButton *button = self.cateButtonArray[cateButtonType];
        if (button) {
            button.layer.borderColor = kBorderColor.CGColor;
            [button setTitleColor:kBorderColor forState:UIControlStateNormal];
        }
        cateButtonType = (int)aBut.tag;
        
        aBut.layer.borderColor = KColor.CGColor;
        [aBut setTitleColor:KColor forState:UIControlStateNormal];
        
        [self getPrice];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self allTextFieldsResignFirstRespond];
    
    if (textField == countTextField) {
        [self getPrice];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == countTextField) {
        [self getPrice];
    }
}

- (void)allTextFieldsResignFirstRespond
{
    if (countTextField && countTextField.isFirstResponder) {
        [countTextField resignFirstResponder];
    }
    if (remarkTextField && remarkTextField.isFirstResponder) {
        [remarkTextField resignFirstResponder];
    }
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
