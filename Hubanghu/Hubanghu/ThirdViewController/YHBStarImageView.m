//
//  YHBStarImageView.m
//  Hubanghu
//
//  Created by Johnny's on 14/12/7.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "YHBStarImageView.h"

@implementation YHBStarImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.count = 5;
        backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = KColor;
        backView.userInteractionEnabled = YES;
        [self addSubview:backView];
        UIImageView *starImg = [[UIImageView alloc] initWithFrame:self.bounds];
        starImg.image = [UIImage imageNamed:@"star"];
        starImg.userInteractionEnabled = YES;
        [self addSubview:starImg];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x<10.6)
    {
        [self setWidth:10.5];
        self.count=0.5;
    }
    else if(point.x<21)
    {
        [self setWidth:21];
        self.count=1;
    }
    else if(point.x<39)
    {
        [self setWidth:39];
        self.count=1.5;
    }
    else if(point.x<50)
    {
        [self setWidth:50];
        self.count=2;
    }
    else if(point.x<67.5)
    {
        [self setWidth:67.5];
        self.count=2.5;
    }
    else if(point.x<78)
    {
        [self setWidth:78];
        self.count=3;
    }
    else if(point.x<96)
    {
        [self setWidth:96];
        self.count=3.5;
    }
    else if(point.x<106)
    {
        [self setWidth:106];
        self.count=4;
    }
    else if(point.x<125)
    {
        [self setWidth:125];
        self.count=4.5;
    }
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
