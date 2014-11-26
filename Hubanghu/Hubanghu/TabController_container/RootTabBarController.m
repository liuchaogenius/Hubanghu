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
#import "IntroduceWebView.h"
#import "HbhSelCityViewController.h"
#import "LSNavigationController.h"

@interface RootTabBarController ()
{
//    UINavigationController *firstNav;
//    UINavigationController *secondNav;
//    UINavigationController *thirdNav;
//    UINavigationController *fourthNav;
    
    LSNavigationController *firstNav;
    LSNavigationController *secondNav;
    LSNavigationController *thirdNav;
    LSNavigationController *fourthNav;
    
    FirstViewController *firstVC;
    SecondViewController *secondVC;
    ThirdViewController *thirdVC;
    FourthViewController *fourthVC;
    
    LeftView *leftview;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLeftView) name:kLeftViewPopMessage object:nil];
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
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_sel"]]];
    //if(kSystemVersion<7.0)
    {
        UIImage *img = [[UIImage imageNamed:@"tabbarBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [[UITabBar appearance] setBackgroundImage:img];
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

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    tabBar.selectedItem.title = @" ";
//}

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
        [weakself showIntroduceView];
    }];
//    leftViewObserver = [FBKVOController lazyeObserValue:self byObserver:leftview keyPath:@"selectItem" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//#warning 这里解析selectitem的新值 调用dealLeftviewSlectitem 去处理页面切换
//        [weakself showIntroduceView];
//    }];
}

- (void)showIntroduceView
{
    IntroduceWebView *webview = [[IntroduceWebView alloc] initWithFrame:self.view.bounds];
    [ViewInteraction viewPresentAnimationFromRight:self.view toView:webview];
}

- (void)popLeftView
{
    
}

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
