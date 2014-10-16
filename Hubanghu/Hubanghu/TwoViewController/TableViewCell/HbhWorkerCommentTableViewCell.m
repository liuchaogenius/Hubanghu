//
//  HbhWorkerCommentTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerCommentTableViewCell.h"

@implementation HbhWorkerCommentTableViewCell

- (instancetype)init
{
    self = [super init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HbhWorkerCommentTableViewCell" owner:self options:nil];
    self = [array objectAtIndex:0];
    
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 60, kMainScreenWidth-24, 1)];
    lineView.backgroundColor = RGBCOLOR(217, 217, 217);
    [self addSubview:lineView];
    
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
