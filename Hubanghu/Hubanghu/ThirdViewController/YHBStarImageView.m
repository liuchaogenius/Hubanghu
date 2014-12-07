//
//  YHBStarImageView.m
//  Hubanghu
//
//  Created by Johnny's on 14/12/7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//


#import "YHBStarImageView.h"

#define radius 0.5925
BOOL canModify;
@implementation YHBStarImageView

- (instancetype)initWithFrame:(CGRect)frame canModify:(BOOL)aBool
{
    if(self = [super initWithFrame:frame])
    {
        canModify = aBool;
        backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = KColor;
        backView.userInteractionEnabled = YES;
        [self addSubview:backView];
        UIImageView *starImg = [[UIImageView alloc] initWithFrame:self.bounds];
        if (canModify)
        {
            self.count = 5;
            starImg.image = [UIImage imageNamed:@"star"];
        }
        else
        {
            self.count = 0;
            starImg.image = [UIImage imageNamed:@"detailStar"];
            [self changeStarCount:0];
        }
        starImg.userInteractionEnabled = YES;
        [self addSubview:starImg];
    }
    return self;
}

- (void)changeStarCount:(CGFloat)aStarCount
{
    if (aStarCount==0)
    {
        [self setWidth:0];
    }
    else if (aStarCount<1)
    {
        [self setWidth:10.6*radius];
    }
    else if(aStarCount==1)
    {
        [self setWidth:21*radius];
    }
    else if(aStarCount<2)
    {
        [self setWidth:39*radius];
    }
    else if(aStarCount==2)
    {
        [self setWidth:50*radius];
    }else if(aStarCount<3)
    {
        [self setWidth:67.5*radius];
    }else if(aStarCount==3)
    {
        [self setWidth:78*radius];
    }else if(aStarCount<4)
    {
        [self setWidth:96*radius];
    }else if(aStarCount==4)
    {
        [self setWidth:106*radius];
    }else if(aStarCount<5)
    {
        [self setWidth:125*radius];
    }else
    {
        [self setWidth:80];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    if (point.x<10.6)
//    {
//        [self setWidth:10.6];
//        self.count=0.5;
//    }
//    else
    if(point.x<21)
    {
        [self setWidth:21];
        self.count=1;
    }
//    else if(point.x<39)
//    {
//        [self setWidth:39];
//        self.count=1.5;
//    }
    else if(point.x<50)
    {
        [self setWidth:50];
        self.count=2;
    }
//    else if(point.x<67.5)
//    {
//        [self setWidth:67.5];
//        self.count=2.5;
//    }
    else if(point.x<78)
    {
        [self setWidth:78];
        self.count=3;
    }
//    else if(point.x<96)
//    {
//        [self setWidth:96];
//        self.count=3.5;
//    }
    else if(point.x<106)
    {
        [self setWidth:106];
        self.count=4;
    }
//    else if(point.x<125)
//    {
//        [self setWidth:125];
//        self.count=4.5;
//    }
    else
    {
        [self setWidth:135];
        self.count=5;
    }
}

- (void)setWidth:(CGFloat)aWidth
{
    CGRect temFrame = backView.frame;
    temFrame.size.width = aWidth;
    backView.frame = temFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
