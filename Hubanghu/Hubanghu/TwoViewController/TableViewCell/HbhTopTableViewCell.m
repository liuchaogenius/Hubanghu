//
//  HbhTopTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhTopTableViewCell.h"
#import "YHBStarImageView.h"

@implementation HbhTopTableViewCell

- (instancetype)init
{
    self = [super init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhTopTableViewCell" owner:self options:nil];
    self = [array objectAtIndex:0];
    
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
    self.appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-90, 30, 70, 35)];
    self.appointmentBtn.backgroundColor = KColor;
    [self.appointmentBtn setTitle:@"预 约" forState:UIControlStateNormal];
    self.appointmentBtn.titleLabel.font = kFont20;
    [self addSubview:self.appointmentBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = RGBCOLOR(218, 218, 218);
    [self addSubview:lineView];
    
    self.personLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, kMainScreenWidth-20, 32)];
    self.personLabel.numberOfLines = 2;
//    self.personLabel.text = @"   我们的工人进入客户的家中，会认真的与我们的客户核对产品的数量和完整性，在客户确认无误后即会准备施工。";
    self.personLabel.font = kFont12;
    self.personLabel.backgroundColor = [UIColor clearColor];
    self.personLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.personLabel];
    
    self.successLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 175, kMainScreenWidth-80, 15)];
    self.successLabel.font = kFont12;
    self.successLabel.textColor = [UIColor lightGrayColor];
//    self.successLabel.text = @"我们会认真的与我们的客户核对产品的数量。";
    self.successLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.successLabel];
    
    self.honorLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 195, kMainScreenWidth-80, 15)];
    self.honorLabel.font = kFont12;
    self.honorLabel.textColor = [UIColor lightGrayColor];
//    self.honorLabel.text = @"2012年获得某某某装修奖";
    self.honorLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.honorLabel];
    
    UIView *otherlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 215, kMainScreenWidth, 1)];
    otherlineView.backgroundColor = RGBCOLOR(218, 218, 218);
    [self addSubview:otherlineView];

    self.skillStar = [[YHBStarImageView alloc] initWithFrame:CGRectMake(55, 89, 80, 12) canModify:NO];
    [self addSubview:self.skillStar];
    
    self.stasStar = [[YHBStarImageView alloc] initWithFrame:CGRectMake(205, 89, 80, 12) canModify:NO];
    [self addSubview:self.stasStar];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.workerIcon.layer.cornerRadius = 5;
    self.workerIcon.clipsToBounds = YES;
    self.workerIcon.layer.borderWidth = 0.5;
    self.workerIcon.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
