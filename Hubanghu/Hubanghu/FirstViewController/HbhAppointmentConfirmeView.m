//
//  HbhAppointmentConfirmeView.m
//  Hubanghu
//
//  Created by qf on 14/10/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhAppointmentConfirmeView.h"

@interface HbhAppointmentConfirmeView ()
@property (nonatomic,strong) UILabel *priceLabel;

@end


@implementation HbhAppointmentConfirmeView

- (instancetype)initWithStyle:(NSInteger)style{
	if (self = [super init]) {
		self.backgroundColor = [UIColor whiteColor];
		_price = 0;
		UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 100, 5, 30, 20)];
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(tip.right, 5, kMainScreenWidth - tip.right - 20, 20)];
		_priceLabel.bottom = tip.bottom;
		tip.text = @"合计:";
		tip.font = kFont13;
		tip.textColor = KColor;
		[self addSubview:tip];
		_priceLabel.text = [NSString stringWithFormat:@"¥%.2lf",_price];
		_priceLabel.font = kFont17;
		_priceLabel.textColor = KColor;
		
		_confirmeButton = nil;
		if (style == 0) {
			_pickWorkerBt = [[UIButton alloc] initWithFrame:CGRectMake(10, _priceLabel.bottom+5, (kMainScreenWidth - 40) / 2, 40)];
			_pickWorkerBt.backgroundColor = KColor;
			_pickWorkerBt.layer.cornerRadius = 2;
			[_pickWorkerBt setTitle:@"选师傅" forState:UIControlStateNormal];
			_pickWorkerBt.titleLabel.font = kFontBold20;
			[self addSubview:_pickWorkerBt];

			_confirmeButton = [[UIButton alloc] initWithFrame:CGRectMake(_pickWorkerBt.right+20, _pickWorkerBt.top, _pickWorkerBt.width, _pickWorkerBt.height)];
			
		}else if (style == 1){
			_confirmeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _priceLabel.bottom+5, kMainScreenWidth - 20, 30)];
		}
		_confirmeButton.backgroundColor = KColor;
		_confirmeButton.layer.cornerRadius = 2;
		[_confirmeButton setTitle:@"预约" forState:UIControlStateNormal];
		_confirmeButton.titleLabel.font = kFontBold20;
		
		[self addSubview:_priceLabel];
		[self addSubview:_confirmeButton];
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
