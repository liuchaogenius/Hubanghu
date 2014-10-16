//
//  HbhWorkerThirdTopTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerThirdTopTableViewCell.h"

@implementation HbhWorkerThirdTopTableViewCell

- (instancetype)init
{
    self = [super init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhWorkerThirdTopTableViewCell" owner:self options:nil];
    self = [array objectAtIndex:0];
    
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
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
