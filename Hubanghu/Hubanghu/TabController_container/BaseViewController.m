//
//  BaseViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewInteraction.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize g_OffsetY;
//@synthesize backgroundimg;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self setNavgtionBarBg];

    if(kSystemVersion >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    if(self.navigationController)
    {
        if(self.navigationController.navigationBarHidden == YES)
        {
            if(kSystemVersion >= 7.0)
            {
                g_OffsetY = 20;
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
            }
            else
            {
                g_OffsetY = 0;
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-20);
            }
        }
        else
        {
            if(kSystemVersion >= 7.0)
            {
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-self.navigationController.navigationBar.frame.size.height-20);
            }
            else
            {
                self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-self.navigationController.navigationBar.frame.size.height-20);
            }
        }
    }
    else
    {
        if(kSystemVersion >= 7.0)
        {
            g_OffsetY = 20;
            self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        }
        else
        {
            g_OffsetY = 0;
            self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-20);
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setBackgroundimg:(UIImage *)aBackgroundimg
{
    if(aBackgroundimg)
    {
        _backgroundimg = [aBackgroundimg resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        [imgview setImage:_backgroundimg];
        [self.view addSubview:imgview];
    }
}
- (void)setLeftButton:(UIImage *)aImg title:(NSString *)aTitle target:(id)aTarget action:(SEL)aSelector
{
    CGRect buttonFrame = CGRectMake(-5, 0, 88/2, 44);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    if(aImg)
    {
        [button setBackgroundImage:aImg forState:UIControlStateNormal];
    }
    if(aTitle)
    {
        [button setTitle:aTitle forState:UIControlStateNormal];
    }
    [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    CGRect viewFrame = CGRectMake(0, 0, 88/2, 44);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    [view addSubview:button];
    
    if(self.navigationController && self.navigationItem)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

- (void)setRightButton:(UIImage *)aImg title:(NSString *)aTitle target:(id)aTarget action:(SEL)aSelector
{
    CGRect buttonFrame = CGRectMake(5, 0, 59.0f, 44.0f);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if(aTitle)
    {
        [button setTitle:aTitle forState:UIControlStateNormal];
    }
    if(aImg)
    {
        [button setBackgroundImage:aImg forState:UIControlStateNormal];
    }
    CGRect viewFrame = CGRectMake(kMainScreenWidth-100/2, 0, 59, 44);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    [view addSubview:button];
    if(self.navigationController && self.navigationItem)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}

- (void)pushView:(UIView*)aView
{
    [ViewInteraction viewPresentAnimationFromRight:self.view toView:aView];
}

- (void)popView:(UIView*)aView completeBlock:(void(^)(BOOL isComplete))aCompleteblock
{
    [ViewInteraction viewDissmissAnimationToRight:aView isRemove:NO completeBlock:^(BOOL isComplete) {
        aCompleteblock(isComplete);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
