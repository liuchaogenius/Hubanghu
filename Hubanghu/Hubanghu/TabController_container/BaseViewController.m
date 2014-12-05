//
//  BaseViewController.m
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewInteraction.h"
#import "SImageUtil.h"
#import "UILabel+dynamicSizeMe.h"
@interface BaseViewController ()
{
//    UILabel *titleLabel;
}
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
    if(kSystemVersion>=7.0)
    {
        self.navigationController.navigationBar.barTintColor = KColor;
    }
    else
    {
        UIImage *backImg = [SImageUtil imageWithColor:KColor size:CGSizeMake(1, 44)];
        [[UINavigationBar appearance] setBackgroundImage:backImg forBarMetrics:UIBarMetricsDefault];
        //self.navigationController.navigationBar.tintColor = KColor;
    }
    self.navigationController.navigationBar.alpha = 1;
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    if (self != [self.navigationController.viewControllers objectAtIndex:0])
    {
        [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(back)];
    }

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
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if(kSystemVersion>6.99)
    {
        CGRect viewFrame = CGRectMake(0, 0, 44, 44);//CGRectMake(0, 0, 88/2, 44);
        UIView *view = [[UIView alloc]initWithFrame:viewFrame];
        CGRect buttonFrame = CGRectMake(-5, (44-30)/2.0, 34, 30);//CGRectMake(-5, 0, 88/2, 44);
        UIButton *button = [[UIButton alloc] initWithFrame:viewFrame];
        _leftButton = button;
        button.backgroundColor = kClearColor;
        if(aTitle)
        {
            [button setTitle:aTitle forState:UIControlStateNormal];
        }
        [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
        
        if(aImg)
        {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:buttonFrame];
            [imgview setImage:aImg];
            [view addSubview:imgview];
        }
        

        [view addSubview:button];
        
        if(self.navigationController && self.navigationItem)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
    }
    else
    {
        CGRect viewFrame = CGRectMake(0, 0, 44, 44);//CGRectMake(0, 0, 88/2, 44);
        UIView *view = [[UIView alloc]initWithFrame:viewFrame];
        CGRect buttonFrame = CGRectMake(5, (44-30)/2.0, 34, 30);//CGRectMake(-5, 0, 88/2, 44);
        UIButton *button = [[UIButton alloc] initWithFrame:viewFrame];
        _leftButton = button;
        button.backgroundColor = kClearColor;
        if(aTitle)
        {
            [button setTitle:aTitle forState:UIControlStateNormal];
        }
        [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
        
        if(aImg)
        {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:buttonFrame];
            [imgview setImage:aImg];
            [view addSubview:imgview];
        }
        [view addSubview:button];
        
        if(self.navigationController && self.navigationItem)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
    }
}

- (void)settitleLabel:(NSString*)aTitle
{
    self.navigationItem.title = aTitle;
    return;
//    CGSize size = [aTitle sizeWithFont:kFont18];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-size.width+3)/2, 0, size.width, 44)];
//    MLOG(@"%@",NSStringFromCGRect(self.navigationItem.titleView.frame));
//    titleLabel.backgroundColor = kClearColor;
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = kFont18;
//    titleLabel.text = aTitle;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
////    self.navigationController.navigationBar.tit
//    
//    self.navigationItem.titleView = titleLabel;
}

- (void)setRightButton:(UIImage *)aImg title:(NSString *)aTitle target:(id)aTarget action:(SEL)aSelector
{
    if(kSystemVersion>6.99)
    {
        //64 58
        CGRect buttonFrame = CGRectMake(15, (44-58/2.0)/2.0, 64/2.0, 58/2.0);//CGRectMake(5, 0, 59.0f, 44.0f);
        CGRect viewFrame = CGRectMake(kMainScreenWidth-44, 0, 44, 44);//CGRectMake(kMainScreenWidth-100/2, 0, 59, 44);
        UIView *view = [[UIView alloc]initWithFrame:viewFrame];
        
        UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
        [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = kClearColor;
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        if(aTitle)
        {
            [button setTitle:aTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if(aImg)
        {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:buttonFrame];
            [imgview setImage:aImg];
            [view addSubview:imgview];
        }

        [view addSubview:button];
        if(self.navigationController && self.navigationItem)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
        _rightButton = button;
    }
    else
    {
        //64 58
        CGRect buttonFrame = CGRectMake(5, (44-58/2.0)/2.0, 64/2.0, 58/2.0);//CGRectMake(5, 0, 59.0f, 44.0f);
        CGRect viewFrame = CGRectMake(kMainScreenWidth-64, 0, 44, 44);//CGRectMake(kMainScreenWidth-100/2, 0, 59, 44);
        UIView *view = [[UIView alloc]initWithFrame:viewFrame];
        
        UIButton *button = [[UIButton alloc] initWithFrame:view.bounds];
        [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = kClearColor;
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        if(aTitle)
        {
            [button setTitle:aTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if(aImg)
        {
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:buttonFrame];
            [imgview setImage:aImg];
            [view addSubview:imgview];
        }
        
        [view addSubview:button];
        if(self.navigationController && self.navigationItem)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        }
        _rightButton = button;
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
