//
//  RootTabBarController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "RootTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "LeftView.h"
#import "FBKVOController.h"
#import "ViewInteraction.h"
#import "HbhLoginViewController.h"
#import "HbhUser.h"
#import "IntroduceViewController.h"
#import "HbhSelCityViewController.h"
#import "LSNavigationController.h"
#import "SImageUtil.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMFeedback.h"
@interface RootTabBarController ()
{
    LSNavigationController *firstNav;
    LSNavigationController *secondNav;
    LSNavigationController *thirdNav;
    LSNavigationController *fourthNav;
    
    FirstViewController *firstVC;
    SecondViewController *secondVC;
    ThirdViewController *thirdVC;
    FourthViewController *fourthVC;
    
    LeftView *leftview;
    IntroduceViewController *introduceVC;
    UINavigationController *introduceNaVC;
    
    NSInteger newSelectIndex;
    NSInteger oldSelectIndex;
    FBKVOController *loginObserver;
    FBKVOController *leftViewObserver;
    
    BOOL isGoBack;
}
@property (nonatomic, strong) HbhLoginViewController *loginVC;
@property (nonatomic, strong) UINavigationController *loginNav;
@property (nonatomic, strong) HbhSelCityViewController *selCityVC;
@property (nonatomic, strong) UINavigationController *selCityNav;
@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.delegate = self;
    isGoBack = NO;
    [self initTabViewController];
    [self initTabBarItem];
    [self initNotifyRegister];
}

- (void)initNotifyRegister
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLeftView) name:kLeftViewPushMessage object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLeftView) name:kLeftViewPopMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewController:) name:kLoginForUserMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelCityVC) name:kSelCityMessage object:nil];
}

- (void)initTabViewController
{
    firstVC = [[FirstViewController alloc] init];
    firstNav = [[LSNavigationController alloc] initWithRootViewController:firstVC];
    
    secondVC = [[SecondViewController alloc] init];
    secondNav = [[LSNavigationController alloc] initWithRootViewController:secondVC];
    
    thirdVC = [[ThirdViewController alloc] init];
    thirdNav = [[LSNavigationController alloc] initWithRootViewController:thirdVC];
    
    fourthVC = [[FourthViewController alloc] init];
    fourthNav = [[LSNavigationController alloc] initWithRootViewController:fourthVC];
    
    self.viewControllers = @[firstNav,secondNav,thirdNav,fourthNav];
}

- (void)initTabBarItem
{
    UIImage *img = [SImageUtil imageWithColor:RGBCOLOR(249, 249, 249) size:CGSizeMake(10, 10)];
    {
        UIImage *tabimg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [[UITabBar appearance] setBackgroundImage:tabimg];
    }
    for(int i=0; i<4;i++)
    {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        UIImage *norimg = [UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_nor_%d",i+1]];
        UIImage *selimg = [UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_sel_%d",i+1]];

        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        tabBarItem.title = @" ";
        if(kSystemVersion>=7.0)
        {
            norimg = [norimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            selimg = [selimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tabBarItem.image = norimg;
            tabBarItem.selectedImage = selimg;
        }
        else
        {
            [tabBarItem setFinishedSelectedImage:selimg withFinishedUnselectedImage:norimg];
        }
        tabBarItem.tag = i;
    }
    
    MLOG(@"tabbarHeight=%f",self.tabBar.frame.size.height);

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    MLOG(@"shouldtabsel = %ld", (unsigned long)tabBarController.selectedIndex);
    oldSelectIndex = tabBarController.selectedIndex;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    MLOG(@"tabsel = %ld", (unsigned long)tabBarController.selectedIndex);
    newSelectIndex = tabBarController.selectedIndex;
}

- (void)pushLeftView
{
    if(!leftview)
    {
        leftview = [[LeftView alloc] initWithFrame:self.view.bounds];
    }
    
    [ViewInteraction viewPresentAnimationFromLeft:self.view toView:leftview];
    if(!leftViewObserver)
    {
        leftViewObserver = [[FBKVOController alloc] initWithObserver:self];
    }
    __weak RootTabBarController *weakself = self;
    [leftViewObserver observe:leftview keyPath:@"selectItem" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        int index = [[change objectForKey:@"new"] intValue];
        [weakself showIntroduceView:index];
    }];
//    leftViewObserver = [FBKVOController lazyeObserValue:self byObserver:leftview keyPath:@"selectItem" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//#warning 这里解析selectitem的新值 调用dealLeftviewSlectitem 去处理页面切换
//        [weakself showIntroduceView];
//    }];
}

- (void)showIntroduceView:(int)aIndex
{
    if(introduceVC == nil)
    {
    //IntroduceViewController *
        introduceVC = [[IntroduceViewController alloc] initWithNibName:nil bundle:nil];
    }
    if(aIndex == E_SHAREHBH)///友盟分享微信
    {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUMENG_APPKEY
                                          shareText:@"户帮户APP叫安装师傅太方便了，服务好，价格公道。我在淘宝上淘的家具都已经安装好了，小伙伴们快来参观吧！http://app.hu8hu.com/"
                                         shareImage:[UIImage imageNamed:@"iconweixin"]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
                                           delegate:nil];
        return ;
    }
    if(aIndex == E_HOTILINE)//拨打客服电话
    {
        UIActionSheet *telSheet = [[UIActionSheet alloc] initWithTitle:@"咨询投诉、预约上门安装请拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:nil, nil];
        [telSheet showFromTabBar:self.tabBar];
        return;
    }
    if(aIndex == E_GOMYTAB)
    {
        self.selectedIndex=3;
        return;
    }
    if(aIndex == E_FEEDBACK)
    {
        [self presentModalViewController:[UMFeedback feedbackModalViewController]
                                animated:YES];
        return;
    }
    if(introduceNaVC == nil)
    {
        introduceNaVC = [[UINavigationController alloc] initWithRootViewController:introduceVC];
    }
    [ViewInteraction viewPresentAnimationFromRight:self.view toView:introduceNaVC.view];
    if(introduceVC && [introduceVC respondsToSelector:@selector(viewDidLoad)])
    {
        [introduceVC performSelector:@selector(viewDidLoad)];
    }
    NSString *title = nil;
    NSString *url = [LeftView getIntroduceUrl:aIndex title:&title];
    [introduceVC setUrl:url title:title];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLOG(@"%ld",(long)buttonIndex);
    if(buttonIndex == 0)//拨打电话
    {
         NSString *tel = [[NSString alloc] initWithFormat:@"tel://%@",@"4006638585"];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
}

//- (void)popLeftView
//{
//    
//}

#pragma mark show login
- (void)showLoginViewController:(NSNotification *)aNotification
{
    
    if(aNotification.object)
    {
        isGoBack = [[aNotification object] boolValue]; ///yes为goback  其他的不处理
    }
    __weak RootTabBarController *weakself = self;
    if (![HbhUser sharedHbhUser].isLogin)
    {
        if(!self.loginVC)
        {
            self.loginVC = [[HbhLoginViewController alloc] init];
        }
        if(!self.loginNav)
        {
            self.loginNav = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
            
        }

        [self presentViewController:self.loginNav animated:YES completion:^{
            
        }];
        if(!loginObserver)
        {
            loginObserver = [[FBKVOController alloc] initWithObserver:self];
        }
        [loginObserver observe:self.loginVC keyPath:@"type" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            int type = [[change objectForKey:@"new"] intValue];
            if(type == eLoginSucc)
            {

            }
            else if(type == eLoginBack)
            {
                if(isGoBack)
                {
                    weakself.selectedIndex = oldSelectIndex;
                    isGoBack = NO;
                }
            }
            [weakself.loginNav dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }
}

#pragma mark show selCityVc

- (HbhSelCityViewController *)selCityVC
{
    if (!_selCityVC) {
        _selCityVC = [[HbhSelCityViewController alloc] init];
        _selCityVC.isOnScreen = NO;
    }
    return _selCityVC;
}

- (UINavigationController *)selCityNav
{
    if (!_selCityNav) {
        _selCityNav = [[UINavigationController alloc] initWithRootViewController:self.selCityVC];
    }
    return _selCityNav;
}

- (void)showSelCityVC
{
    if (!self.selCityVC.isOnScreen) {
        self.selCityVC.isOnScreen = YES;
        [self presentViewController:self.selCityNav animated:YES completion:^{
        }];
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
