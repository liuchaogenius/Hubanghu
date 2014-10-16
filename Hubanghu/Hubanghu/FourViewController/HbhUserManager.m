//
//  HbhUserManager.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhUserManager.h"
#import "NetManager.h"
#import "HbhUser.h"
@implementation HbhUserManager
//登陆
+ (void)loginWithPhone:(NSString *)phone andPassWord:(NSString *)password withSuccess:(void(^)())sBlock failure:(void(^)())fBlock
{
    NSString *loginUrl = nil;
    kHubRequestUrl(@"login.ashx", loginUrl);
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"password", nil];
    
    [NetManager requestWith:postDic url:loginUrl method:@"POST" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@",successDict);
        if ([successDict[@"code"] isEqualToString:@"SUCCESS"]) {
            NSDictionary *dataDic = successDict[@"data"];
            NSDictionary *userDic = dataDic[@"user"];
            [[HbhUser sharedHbhUser] loginUserWithUserDictionnary:userDic];
        }
        
        sBlock();
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"%@",error.localizedDescription);
        fBlock();
    }];
}

//退出,待完善
+ (void)logoutWithSuccess:(void(^)())sBlock failure:(void(^)())fBlock
{
    NSString *logoutUrl = nil;
    kHubRequestUrl(@"profileReval.ashx", logoutUrl);
    [NetManager requestWith:nil url:logoutUrl method:@"GET" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
        [[HbhUser sharedHbhUser] logoutUser];
        sBlock();
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"%@",error.localizedDescription);
    }];
}
@end
