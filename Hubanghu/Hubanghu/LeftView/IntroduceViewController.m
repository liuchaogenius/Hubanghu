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
#import "SVProgressHUD.h"
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
    [SVProgressHUD dismiss];
    if(self.isSysPush)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [ViewInteraction viewDissmissAnimationToRight:self.navigationController.view isRemove:NO completeBlock:^(BOOL isComplete) {
            
        }];
    }
}
- (void)setUrl:(NSString *)aLoadUrl title:(NSString *)aTitle
{
    if(aTitle)
    {
        [self addLeftbutton];
        self.navigationItem.title = aTitle;
    }
    if(!_webView)
    {
        _webView = [[IntroduceWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }

    [_webView loadUrl:aLoadUrl];
    
}

- (void)addLeftbutton
{
    if(_isSysPush)
    {

        CGRect viewFrame = CGRectMake(0, 0, 44, 44);//CGRectMake(0, 0, 88/2, 44);
        UIView *view = [[UIView alloc]initWithFrame:viewFrame];
        CGRect buttonFrame = CGRectMake(0, (44-30)/2.0, 34, 30);//CGRectMake(-5, 0, 88/2, 44);
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        button.backgroundColor = kClearColor;
        [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backItem) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *imgview = [[UIImageView alloc] initWithFrame:buttonFrame];
//        [imgview setImage:[UIImage imageNamed:@"back"]];
//        [view addSubview:imgview];
        
        
        [view addSubview:button];
        
        //if(self.navigationController && self.navigationItem)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
    }
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
