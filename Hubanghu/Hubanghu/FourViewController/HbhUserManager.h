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

//用户修改密码网络请求
+ (void)changePassWordWithOldPwd:(NSString *)oldpwd andNewPwd:(NSString *)newpwd andComfirmPwd:(NSString *)comfirmpwd Success:(void(^)())sBlock failure:(void(^)(NSInteger result,NSString *resultString))fBlock;

//我的页面透出
+ (void)profileRevalWithSuccess:(void(^)(int notDone,int notComment))sBlock failure:(void(^)())fBlock;

//注册获取验证码
+ (void)getCheckCodeWithPhone : (NSString *)phone Success:(void(^)())sBlock failure:(void(^)(int result,NSString *errorString))fBlock;

//注册账号
+ (void)registerWithPhone:(NSString *)phone checkCode:(NSString *)checkcode passWord:(NSString *)password withSuccess:(void(^)())sBlock failure:(void(^)(int result,NSString *errorString))fBlock;
@end
