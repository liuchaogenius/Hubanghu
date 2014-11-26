//
//  IntroduceViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14/11/26.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "IntroduceViewController.h"
#import "IntroduceWebView.h"
#import "ViewInteraction.h"
@interface IntroduceViewController ()
@property (nonatomic, strong)IntroduceWebView *webView;
@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[IntroduceWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    self.view.backgroundColor = kViewBackgroundColor;
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(backItem)];
    [self setRightButton:[UIImage imageNamed:@"refresh"] title:nil target:self action:@selector(refeshWebview)];
}

- (void)refeshWebview
{
    if(_webView)
    {
        [_webView refreshItem];
    }
}
- (void)backItem
{
    [ViewInteraction viewDissmissAnimationToRight:self.navigationController.view isRemove:NO completeBlock:^(BOOL isComplete) {
        
    }];
}
- (void)setUrl:(NSString *)aLoadUrl title:(NSString *)aTitle
{
    if(aTitle)
    {
        [self settitleLabel:aTitle];
    }
    if(!_webView)
    {
        _webView = [[IntroduceWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }

    [_webView loadUrl:aLoadUrl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
