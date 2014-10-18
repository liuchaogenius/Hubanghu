//
//  HbhWorkerSecondTopTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerSecondTopTableViewCell.h"

@implementation HbhWorkerSecondTopTableViewCell

- (instancetype)init
{
    self = [super init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhWorkerSecondTopTableViewCell" owner:self options:nil];
    self = [array objectAtIndex:0];
    
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-50, 8, 30, 15)];
    self.moreBtn.backgroundColor = RGBCOLOR(183, 183, 183);
    self.moreBtn.titleLabel.font = kFont10;
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self addSubview:self.moreBtn];
    
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
