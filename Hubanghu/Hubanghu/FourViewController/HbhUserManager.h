//
//  HbhUserManager.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HbhUserManager : NSObject

//用户登陆网络请求
+ (void)loginWithPhone:(NSString *)phone andPassWord:(NSString *)password withSuccess:(void(^)())sBlock failure:(void(^)())fBlock;

//用户退出网络请求
//+ (void)logoutWithSuccess:(void(^)())sBlock failure:(void(^)())fBlock;

//我的页面透出
+ (void)profileRevalWithSuccess:(void(^)(int notDone,int notComment))sBlock failure:(void(^)())fBlock;


@end
