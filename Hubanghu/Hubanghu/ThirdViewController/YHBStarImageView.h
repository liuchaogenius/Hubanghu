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

@property(nonatomic, assign) int count;
- (instancetype)initWithFrame:(CGRect)frame canModify:(BOOL)aBool;
- (void)changeStarCount:(CGFloat)aStarCount;
@end
