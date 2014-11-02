//
//  HubControlPriceView.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HubControlPriceView.h"
#define kTitleFont 13

#define kCateTitleFont  15
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
    NSString *strRemark;
    
}

@end

@implementation HubControlPriceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        categoryTitlearry = @[@"纯装",@"纯拆",@"拆装",@"勘察"];
        countArry = @[@"数量:",@"面积:",@"长度:"];
        unitArry = @[@"(个)",@"(㎡)",@"(米)"];
        
        cateButtonType = 0;
        countType = 1;
        uragent = NO;
        
        offsetY = 15;
        
        //input
    }
    return self;
}

- (void)setCountType:(int)aType
{
    countType = aType;
}

- (void)setCateButtonType:(int)aType
{
    cateButtonType = aType;
}

- (void)createCategoryButton:(int)aMountType
{
    UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    categoryTitle.backgroundColor = kClearColor;
    categoryTitle.textAlignment = NSTextAlignmentCenter;
    categoryTitle.text = @"类型:";
    categoryTitle.textColor = [UIColor blackColor];
    [self addSubview:categoryTitle];
    for(int i=0; i<4; i++)
    {
        
        UIButton *cateButton = [[UIButton alloc] initWithFrame:CGRectMake(categoryTitle.right+10+(i*50+(i)*3), categoryTitle.top, 50, kCateTitleFont+3)];
        cateButton.layer.borderWidth = 1;
        cateButton.layer.cornerRadius = 2;
        cateButton.tag = i;
        if (cateButtonType == i)
        {
            cateButton.layer.borderColor = KColor.CGColor;
            [cateButton setTitleColor:KColor forState:UIControlStateNormal];
        }
        else
        {
            cateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [cateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        [cateButton setTitle:[categoryTitlearry objectAtIndex:i] forState:UIControlStateNormal];
        [cateButton addTarget:self action:@selector(cateButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cateButton];
    }
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, categoryTitle.bottom+10, kMainScreenWidth, 1)];
    lineview.backgroundColor = [UIColor grayColor];
    [self addSubview:lineview];
    
    offsetY = lineview.bottom+10;
}

- (void)cateButtonItem:(UIButton *)aBut
{
    cateButtonType = aBut.tag;
}

- (void)createCountview
{
    UILabel *countTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    countTitleLabel.backgroundColor = kClearColor;
    countTitleLabel.textAlignment = NSTextAlignmentCenter;
    if((countType-1) < [countArry count])
    {
        countTitleLabel.text = [countArry objectAtIndex:(countType-1)];
    }
    countTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:countTitleLabel];
    
    if(!countTextField)
    {
        countTextField = [[UITextField alloc] initWithFrame:CGRectMake(countTitleLabel.right+10, countTitleLabel.top, 80, 30)];
        [self addSubview:countTextField];
    }
    
    countTextField.tag	= 0;
    countTextField.delegate = self;
    countTextField.placeholder = @"请输入..";
    countTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    countTextField.returnKeyType = UIReturnKeyDone;
    countTextField.font = kFont13;
    countTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    countTextField.textAlignment = NSTextAlignmentCenter;
    countTextField.layer.borderWidth = 1;
    countTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    countTextField.layer.cornerRadius = 2;
    
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(countTextField.right+3, countTextField.bottom-13, 28, 10)];
    unitLabel.backgroundColor = kClearColor;
    unitLabel.textAlignment = NSTextAlignmentCenter;
    if((countType-1) < [unitArry count])
    {
        unitLabel.text = [unitArry objectAtIndex:(countType-1)];
    }
    unitLabel.textColor = [UIColor blackColor];
    [self addSubview:unitLabel];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, countTitleLabel.bottom+10, kMainScreenWidth, 1)];
    lineview.backgroundColor = [UIColor grayColor];
    [self addSubview:lineview];
    
    offsetY = lineview.bottom+10;
}

- (void)createExpeditedView
{
    UILabel *expeditedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 35, kTitleFont+3)];
    expeditedTitleLabel.backgroundColor = kClearColor;
    expeditedTitleLabel.textAlignment = NSTextAlignmentCenter;
    expeditedTitleLabel.text = @"加急:";
    expeditedTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:expeditedTitleLabel];
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(expeditedTitleLabel.right+10, expeditedTitleLabel.top, 18, 18)];
    [bt setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(selectUrgent:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:bt];
    
    UILabel *uragentDesc = [[UILabel alloc] initWithFrame:CGRectMake(bt.right+8, bt.top, kMainScreenWidth-(bt.right+8), 12)];
    uragentDesc.backgroundColor = kClearColor;
    uragentDesc.textColor = [UIColor grayColor];
    uragentDesc.text = @"12小时内上门安装";
    [self addSubview:uragentDesc];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, expeditedTitleLabel.bottom+10, kMainScreenWidth, 1)];
    lineview.backgroundColor = [UIColor grayColor];
    [self addSubview:lineview];
    
    offsetY = lineview.bottom+10;
}

- (void)createRemarkview
{
    UIView *remarkView = [[UIView alloc] initWithFrame:CGRectMake(10, offsetY, kMainScreenWidth-20, 50)];
}

- (void)selectUrgent:(UIButton*)aBut
{
    if (uragent) {
        [aBut setImage:[UIImage imageNamed:@"rectangleUp"] forState:UIControlStateNormal];
    }else{
        [aBut setImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    }
    uragent = !uragent;
#warning 获取价格
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
#warning 获取价格
    return YES;
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
