//
//  HbhWorkerImgTableViewCell.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerImgTableViewCell.h"
#import "HbhWorkerCaseClass.h"
#import "UIButton+WebCache.h"

@implementation HbhWorkerImgTableViewCell

- (instancetype)initWithImgArray:(NSArray *)aArray
{
    self = [super init];
    CGRect temFrame = self.frame;
    temFrame.size.width = kMainScreenWidth;
    self.frame = temFrame;
    
    int btnWidth = 60;
    CGFloat interval = (kMainScreenWidth-btnWidth*4)/5;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 85)];
    for (int i=0; i<aArray.count; i++)
    {
        HbhWorkerCaseClass *model = [aArray objectAtIndex:i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(interval+(btnWidth+interval)*i, 0, btnWidth, btnWidth)];
        btn.layer.borderColor = [[UIColor grayColor] CGColor];
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 5;
        [btn sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.left, btn.bottom, btn.right-btn.left, 20)];
        label.text = model.title;
        label.font = kFont12;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(129, 129, 129);
        [scrollView addSubview:label];
        [scrollView addSubview:btn];
    }
    scrollView.contentSize = CGSizeMake(aArray.count*(btnWidth+interval)+interval, 60);
    [self addSubview:scrollView];
    
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
