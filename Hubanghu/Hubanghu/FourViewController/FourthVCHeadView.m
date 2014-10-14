//
//  FourthVCHeadView.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FourthVCHeadView.h"

@implementation FourthVCHeadView

- (id)initWithFrame:(CGRect)frame
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FourthVCHeadView" owner:self options:nil];
    self = nib[0];
    if (self) {
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
