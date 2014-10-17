//
//  HbhFirstVCCell.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhFirstVCCell.h"

@implementation HbhFirstVCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIButton *leftImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftImageButton.frame = CGRectMake(0, kBlankWidth, (kMainScreenWidth -kBlankWidth)/2.0, kImageButtonHeight);
    self.leftImageButton = leftImageButton;
    [self.contentView addSubview:leftImageButton];
    
    UIButton *rightImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightImageButton.frame = CGRectMake((kMainScreenWidth -kBlankWidth)/2.0+kBlankWidth, kBlankWidth, (kMainScreenWidth -kBlankWidth)/2.0, kImageButtonHeight);
    self.rightImageButton = rightImageButton;
    [self.contentView addSubview:rightImageButton];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
