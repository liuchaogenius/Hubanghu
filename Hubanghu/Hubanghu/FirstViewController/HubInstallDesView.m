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
    //UILabel *contentLabel;
    NSString *_descUrl;
    UITextView *textview;
}
@end
@implementation HubInstallDesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
       
        [self creatTextView];
        // [self createLabel];
        
        UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDescUrl)];
        [self addGestureRecognizer:tp];
    }
    return self;
}

//- (void)createLabel
//{
//    if(!contentLabel)
//    {
//        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, self.height)];
//        contentLabel.backgroundColor = kClearColor;
//        contentLabel.font = [UIFont systemFontOfSize:15];
//        contentLabel.textAlignment = NSTextAlignmentLeft;
//        contentLabel .numberOfLines = 0;
//        contentLabel.textColor = [UIColor blackColor];
//        [self addSubview:contentLabel];
//    }
//}
- (void)creatTextView
{
    if (!textview) {
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, self.height)];
        tv.backgroundColor = [UIColor clearColor];
        tv.font = [UIFont systemFontOfSize:15];
        //tv.textAlignment = NSTextAlignmentLeft;
        tv.textColor = [UIColor blackColor];
        tv.editable = NO;
        [self addSubview:tv];
        textview = tv;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, kMainScreenWidth, 0.7)];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
    }
}

- (void)setContent:(NSString *)aContent
{
    if(textview)
    {
        //contentLabel.text = aContent;
        textview.text = aContent;
        //contentLabel.text = @"11\r\n11";
    }
}


- (void)setdescUrl:(NSString *)aUrl
{
    _descUrl = aUrl;
}

- (void)touchDescUrl
{
    if ([self.delegate respondsToSelector:@selector(showDescUrl)]) {
        [self.delegate showDescUrl];
        
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
