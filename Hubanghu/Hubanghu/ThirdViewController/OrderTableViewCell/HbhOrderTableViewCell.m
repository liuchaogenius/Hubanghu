//
//  OrderTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderTableViewCell.h"

@implementation HbhOrderTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.workerLabel];
    [self addSubview:self.workerNameLabel];
    [self addSubview:self.urgentLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.orderStateLabel];
    [self addSubview:self.priceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];

    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    return self;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-70, 10, 60, 20)];
        _priceLabel.textColor = KColor;
        _priceLabel.font = kFont14;
        _priceLabel.text = @"￥110.00";
    }
    return _priceLabel;
}

- (UILabel *)orderStateLabel
{
    if (!_orderStateLabel) {
        _orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-55, 30, 40, 15)];
        _orderStateLabel.text = @"已付款";
        _orderStateLabel.font = kFont11;
        _orderStateLabel.textColor = KColor;
    }
    return _orderStateLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 160, 25)];
        _nameLabel.font = kFont14;
        _nameLabel.text = @"预约 卫浴安装坐便器安装";
    }
    return _nameLabel;
}

- (UILabel *)workerLabel
{
    if (!_workerLabel) {
        _workerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 50, 20)];
        _workerLabel.text = @"安装师傅 :";
        _workerLabel.font = kFont10;
        _workerLabel.textColor = [UIColor lightGrayColor];
    }
    return _workerLabel;
}

- (UILabel *)workerNameLabel
{
    if (!_workerNameLabel) {
        _workerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 40, 20)];
        _workerNameLabel.text = @"某某某";
        _workerNameLabel.font = kFont10;
        _workerNameLabel.textColor = [UIColor lightGrayColor];
    }
    return _workerNameLabel;
}

- (UILabel *)urgentLabel
{
    if (!_urgentLabel) {
        _urgentLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, 40, 20)];
        _urgentLabel.text = @"[加急]";
        _urgentLabel.textColor = KColor;
        _urgentLabel.font = kFont10;
    }
    return _urgentLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 5, 40, 25)];
        _typeLabel.text = @"[拆装]";
        _typeLabel.textColor = KColor;
        _typeLabel.font = kFont14;
    }
    return _typeLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
