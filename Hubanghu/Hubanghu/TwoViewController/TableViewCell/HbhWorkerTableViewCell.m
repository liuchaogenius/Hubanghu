//
//  HbhWorkerTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerTableViewCell.h"

@implementation HbhWorkerTableViewCell

- (instancetype)init
{
//    if (!self)
//    {
        self = [super init];
        CGRect temFrame = self.frame;
        temFrame.size.width = kMainScreenWidth;
        self.frame = temFrame;
//    }
    
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
