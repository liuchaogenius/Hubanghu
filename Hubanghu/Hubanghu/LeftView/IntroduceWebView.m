//
//  IntroduceWebView.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "IntroduceWebView.h"
#import "ViewInteraction.h"
#import "SVProgressHUD.h"

@implementation IntroduceWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self addBackButton];
        self.delegate = self;
    }
    return self;
}


- (void)loadUrl:(NSString *)aUrl
{
    if(aUrl)
    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:aUrl]];
        [self loadRequest:request];
        [SVProgressHUD showWithStatus:@"正在加载..." cover:NO offsetY:0];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
