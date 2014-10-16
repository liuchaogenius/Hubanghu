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
        _photoImageView.layer.cornerRadius = _photoImageView.frame.size.height/2.0f;
        _photoImageView.layer.masksToBounds = YES;
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImageView setClipsToBounds:YES];
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
