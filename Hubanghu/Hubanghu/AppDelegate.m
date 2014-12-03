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
#import "MobClick.h"
#import "UMSocial.h"
#import "HbhUser.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    int Type;
}
@property (strong, nonatomic) NSString *updateUrl;
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
    [self umengregister];
    [self performSelector:@selector(registerRemoteToken) withObject:nil afterDelay:5];
    return YES;
}
///注册友盟
- (void)umengregister
{
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [bundleDic objectForKey:@"CFBundleShortVersionString"];
    [MobClick startWithAppkey:kUMENG_APPKEY reportPolicy:SENDWIFIONLY channelId:nil];
    [UMSocialData setAppKey:kUMENG_APPKEY];
    [UMSocialWechatHandler setWXAppId:kShareWEIXINAPPID appSecret:kShareWEIXINAPPSECRET url:@"http://app.hu8hu.com/"];
    [MobClick setAppVersion:appVersion];
}

- (void)checkVersion
{
    self.updateUrl = nil;
    NSString *url = nil;
    kHubRequestUrl(@"checkVersion.ashx", url);

    [NetManager requestWith:nil url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSDictionary *dataDict = [successDict objectForKey:@"data"];
        Type = [[dataDict objectForKey:@"type"] intValue];
        ////"type":0/*0不更新，1强制更新，2可选更新*/
        if (Type == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本，请您先更新版本" message:@"点击“确定”开始更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            self.updateUrl = dataDict[@"url"];
            [alertView show];
        }else if (Type == 2){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现有新的版本" message:@"有新的版本可以更新，将会提供更多功能" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
            self.updateUrl = dataDict[@"url"];
            [alertView show];
        }
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        MLOG(@"%@",self.updateUrl);
        
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 945963130];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        if(Type == 1)
        {
            NSMutableArray *ary = [NSMutableArray array];
            [ary addObject:nil];
        }
    }
}
#pragma mark 注册devicetoken
- (void)registerRemoteToken
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    MLOG(@"error");
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    MLOG(@"fasfas");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if(deviceToken)
    {
        NSString *strToken  = [NSString stringWithFormat:@"%@",deviceToken];
        MLOG(@"device_token = %@",strToken);
        NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        if(![oldToken isEqualToString:strToken])//如果不等就上报
        {
            NSString *struserid = [HbhUser sharedHbhUser].userID?[HbhUser sharedHbhUser].userID:@"0";
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strToken,@"DeviceNo",struserid,@"CustomerID", [NSString stringWithFormat:@"%.2f",kSystemVersion],@"OSVersion",@"iphone",@"DeviceName",nil];
            NSString *devurl = nil;
            kHubRequestUrl(@"SubmitPushDevice.ashx ", devurl);
            [NetManager requestWith:dict url:devurl method:@"POST" operationKey:[self description] parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
                [[NSUserDefaults standardUserDefaults] setObject:strToken forKey:@"DeviceToken"];
            } failure:^(NSDictionary *failDict, NSError *error) {
                
            }];
        }
        
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(url)
    {
        NSString *strQuery = url.query;
        [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayOrderResultMessage object:strQuery];
    }
    return YES;
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
