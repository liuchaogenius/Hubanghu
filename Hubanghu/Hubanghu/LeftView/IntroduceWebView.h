//
//  IntroduceWebView.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceWebView : UIWebView<UIWebViewDelegate>
- (void)loadUrl:(NSString *)aUrl;
- (void)refreshItem;
@end
