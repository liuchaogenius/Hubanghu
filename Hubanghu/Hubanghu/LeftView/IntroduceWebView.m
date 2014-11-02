//
//  IntroduceWebView.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "IntroduceWebView.h"
#import "ViewInteraction.h"
@implementation IntroduceWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addBackButton
{
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(self.right-54, 20, 44, 44)];
    [buton setTitle:@"返回" forState:UIControlStateNormal];
    [buton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
    buton.backgroundColor = [UIColor blackColor];
    [self addSubview:buton];
}

- (void)addRefreshButton
{
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(self.right-54-54, 20, 44, 44)];
    [buton setTitle:@"刷新" forState:UIControlStateNormal];
    [buton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(refreshItem) forControlEvents:UIControlEventTouchUpInside];
    buton.backgroundColor = [UIColor blackColor];
    [self addSubview:buton];
}

- (void)backItem
{
    [ViewInteraction viewDissmissAnimationToRight:self isRemove:YES completeBlock:^(BOOL isComplete) {
        
    }];
}

- (void)refreshItem
{
    [self reload];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
