//
//  HbhCategoryCell.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhCategoryCell.h"

@implementation HbhCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //背景按钮
        UIButton *leftImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftImageButton.frame = CGRectMake(0, kBlankWidth, (kMainScreenWidth -kBlankWidth)/2.0, kImageButtonHeight);
        self.leftImageButton = leftImageButton;
        
        //下方透明黑色试图
        UIView *leftBlackView = [self blackLucencyViewWithFrame:CGRectMake(0, kImageButtonHeight-kBlackLabelHeight, (kMainScreenWidth -kBlankWidth)/2.0, kBlackLabelHeight)];
        [self.leftImageButton addSubview:leftBlackView];
        
        //黑色试图上标题lable
        self.leftTitleLable = [self customLabelWithFrame:CGRectMake(0, 0, (kMainScreenWidth -kBlankWidth)/2.0, kBlackLabelHeight)];
        _leftTitleLable.tag = kTitleLabelTag;
        [leftBlackView addSubview:_leftTitleLable];
        
        [self.contentView addSubview:leftImageButton];
        
        UIButton *rightImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightImageButton.frame = CGRectMake((kMainScreenWidth -kBlankWidth)/2.0+kBlankWidth, kBlankWidth, (kMainScreenWidth -kBlankWidth)/2.0, kImageButtonHeight);
        self.rightImageButton = rightImageButton;
        
        UIView *rightBlackView = [self blackLucencyViewWithFrame:CGRectMake(0, kImageButtonHeight-kBlackLabelHeight, (kMainScreenWidth -kBlankWidth)/2.0, kBlackLabelHeight)];
        [self.rightImageButton addSubview:rightBlackView];
        
        self.rightTitleLabel = [self customLabelWithFrame:CGRectMake(0, 0, (kMainScreenWidth -kBlankWidth)/2.0, kBlackLabelHeight)];
        _rightTitleLabel.tag = kTitleLabelTag;
        [rightBlackView addSubview:self.rightTitleLabel];
        
        [self.contentView addSubview:rightImageButton];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)blackLucencyViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    return view;
}

- (UILabel *)customLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (kSystemVersion < 7) {
        label.backgroundColor =[UIColor clearColor];//RGBACOLOR(0.2, 0.2, 0.2, 0.5);
    }
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = [UIColor whiteColor];
    label.font = kFont14;
    return label;
}
@end
