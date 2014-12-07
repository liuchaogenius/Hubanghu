//
//  YHBStarImageView.h
//  Hubanghu
//
//  Created by Johnny's on 14/12/7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHBStarImageView : UIImageView
{
    UIView *backView;
}

@property(nonatomic, assign) float count;
- (instancetype)initWithFrame:(CGRect)frame;
@end
