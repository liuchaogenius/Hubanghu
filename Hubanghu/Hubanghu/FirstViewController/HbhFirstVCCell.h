//
//  HbhFirstVCCell.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kBlankWidth 3.0
#define kImageButtonHeight ((kMainScreenWidth - kBlankWidth)/2.0*368/532.0f)
#define kCellHeight kImageButtonHeight+kBlankWidth

@interface HbhFirstVCCell : UITableViewCell

@property (strong, nonatomic) UIButton *leftImageButton;
@property (strong, nonatomic) UIButton *rightImageButton;

@end
