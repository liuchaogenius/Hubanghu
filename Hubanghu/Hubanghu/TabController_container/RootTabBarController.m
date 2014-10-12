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

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.delegate = self;
    [self initTabViewController];
    [self initTabBarItem];
    [self initNotifyRegister];
}

- (void)initNotifyRegister
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLeftView) name:kLeftViewPushMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLeftView) name:kLeftViewPopMessage object:nil];
}

- (void)initTabViewController
{
    firstVC = [[FirstViewController alloc] init];
    firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    secondVC = [[SecondViewController alloc] init];
    secondNav = [[UINavigationController alloc] initWithRootViewController:secondVC];
    
    thirdVC = [[ThirdViewController alloc] init];
    thirdNav = [[UINavigationController alloc] initWithRootViewController:thirdVC];
    
    fourthVC = [[FourthViewController alloc] init];
    fourthNav = [[UINavigationController alloc] initWithRootViewController:fourthVC];
    
    self.viewControllers = @[firstNav,secondNav,thirdNav,fourthNav];
}

- (void)initTabBarItem
{
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_sel"]]];
    for(int i=0; i<self.tabBar.items.count;i++)
    {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        UIImage *norimg = [UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_nor_%d",i+1]];
        //UIImage *selimg = [UIImage imageNamed:[NSString stringWithFormat:@"TabBarItem_sel_%d",i+1]];
        norimg = [norimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //selimg = [selimg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 4, 0);
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        tabBarItem.image = norimg;
        tabBarItem.tag = i;
#else
        [tabBarItem setFinishedSelectedImage:selimg withFinishedUnselectedImage:norimg];
#endif
        
    }
}

- (void)pushLeftView
{
    if(!leftview)
    {
        leftview = [[LeftView alloc] initWithFrame:self.view.bounds];
    }
    
    [ViewInteraction viewPresentAnimationFromBottom:self.view toView:leftview];
    __weak RootTabBarController *weakself = self;
    [FBKVOController lazyeObserValue:self byObserver:leftview keyPath:@"selectItem" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
#warning 这里解析selectitem的新值 调用dealLeftviewSlectitem 去处理页面切换
//        [weakself dealLeftviewSlectitem]
    }];
}

- (void)popLeftView
{
    
}

- (void)dealLeftviewSlectitem:(int)aSelectIndex
{
#warning 接收到新值，先把leftview dissmiss(不需要动画，直接removew 在把值设置为nil)了，然后用ViewInteraction  把新的页面new出来 显示出来
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
