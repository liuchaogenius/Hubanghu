//
//  HubInstallDesView.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HubInstallDesView.h"

@interface HubInstallDesView()
{
    UILabel *contentLabel;
}
@end
@implementation HubInstallDesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self createLabel];
    }
    return self;
}

- (void)createLabel
{
    if(!contentLabel)
    {
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, self.height)];
        contentLabel.backgroundColor = kClearColor;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.textColor = [UIColor blackColor];
        [self addSubview:contentLabel];
    }
}
- (void)setContent:(NSString *)aContent
{
    if(contentLabel)
    {
        contentLabel.text = aContent;
    }
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
