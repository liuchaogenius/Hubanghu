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
    
    [NetManager requestWith:postDic url:loginUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@",successDict);
        if ([successDict[@"code"] isEqualToString:@"SUCCESS"]) {
            NSDictionary *dataDic = successDict[@"data"];
            NSDictionary *userDic = dataDic[@"user"];
            [[HbhUser sharedHbhUser] loginUserWithUserDictionnary:userDic];
        }
        
        sBlock();
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"%@",error.localizedDescription);
        if (fBlock){
            fBlock();
        }
    }];
}

+ (void)changePassWordWithOldPwd:(NSString *)oldpwd andNewPwd:(NSString *)newpwd andComfirmPwd:(NSString *)comfirmpwd Success:(void(^)(NSInteger result))sBlock failure:(void(^)())fBlock
{
    NSString *url = nil;
    kHubRequestUrl(@"changePassword.ashx ", url);
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:oldpwd,@"oldpwd",newpwd,@"newpwd",comfirmpwd,@"comfirmpwd",nil];
    [NetManager requestWith:postDic url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSInteger result = [successDict[@"result"] integerValue];
        sBlock(result);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

+ (void)profileRevalWithSuccess:(void(^)(int notDone,int notComment))sBlock failure:(void(^)())fBlock;
{
    NSString *url = nil;
    kHubRequestUrl(@"profileReval.ashx", url);
    
    [NetManager requestWith:nil url:url method:@"GET" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSDictionary *dic = successDict[@"data"];
        int notDone = [dic[@"notDone"] intValue];
        int notComment = [dic[@"notComment"] intValue];
        sBlock(notDone,notComment);
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"%@",error.localizedDescription);
        if (fBlock){
            fBlock();
        }
    }];
}

@end
