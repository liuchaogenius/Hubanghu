//
//  HbhTopTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhTopTableViewCell.h"

@implementation HbhTopTableViewCell

- (instancetype)init
{
    self = [super init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhTopTableViewCell" owner:self options:nil];
    self = [array objectAtIndex:0];
    
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
    UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-90, 30, 70, 35)];
    appointmentBtn.backgroundColor = KColor;
    [appointmentBtn setTitle:@"预 约" forState:UIControlStateNormal];
    appointmentBtn.titleLabel.font = kFont20;
    [self addSubview:appointmentBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
    self.personLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, kMainScreenWidth-20, 32)];
    self.personLabel.numberOfLines = 2;
    self.personLabel.text = @"  蝴蝶结客服哈的看法哈利地方哈劳动法哈德了看法哈德了罚款还地方了宽宏大量付款哈的老客户";
    self.personLabel.font = kFont12;
    self.personLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.personLabel];
    
    self.successLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 167, kMainScreenWidth-80, 15)];
    self.successLabel.font = kFont12;
    self.successLabel.textColor = [UIColor lightGrayColor];
    self.successLabel.text = @"嘎哈交电话费的缴费和大厦开机连符合大家看法哈德两极分化多了几分哈地方就火大付款就很大房间卡号";
    [self addSubview:self.successLabel];
    
    self.honorLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 183, kMainScreenWidth-80, 15)];
    self.honorLabel.font = kFont12;
    self.honorLabel.textColor = [UIColor lightGrayColor];
    self.honorLabel.text = @"嘎哈交电话费的缴费和大厦开机连符合大家看法哈德两极分化多了几分哈地方就火大付款就很大房间卡号";
    [self addSubview:self.honorLabel];

    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
