//
//  AppDelegate.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "HbhUser.h"
#import "NetManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize rootvc;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    rootvc = [[RootTabBarController alloc] init];
    rootvc.view.frame = self.window.bounds;
	
    self.window.rootViewController = rootvc;
    [self.window makeKeyAndVisible];
    [self checkVersion];
    return YES;
}

- (void)checkVersion
{
    NSString *url = nil;
    kHubRequestUrl(@"checkVersion.ashx", url);
    [NetManager requestWith:nil url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSDictionary *dataDict = [successDict objectForKey:@"data"];
        int Type = [[dataDict objectForKey:@"type"] intValue];
        ////"type":0/*0不更新，1强制更新，2可选更新*/
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
        if ([HbhUser sharedHbhUser].isLogin) {
            [[HbhUser sharedHbhUser] writeUserInfoToFile];
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
