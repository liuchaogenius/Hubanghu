//
//  HbhUser.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HbuAreaListModelAreas.h"

@interface HbhUser : NSObject

@property (nonatomic,readonly) BOOL isLogin;//是否登录
@property (strong, nonatomic) NSString *userID; //id
@property (strong, nonatomic) NSString *nickName; //昵称
@property (strong, nonatomic) NSString *photoUrl; //头像
@property (strong, nonatomic) NSString *QRCodeUrl; //二维码
@property (strong, nonatomic) NSString *phone; //手机
@property (nonatomic) NSInteger point; //积分
@property (strong, nonatomic) NSString *encodedToken; //token
@property (strong, nonatomic) HbuAreaListModelAreas *currentArea; //用户所在地
@property (assign, nonatomic) double time; //获取地区信息的版本 时间号

@property (nonatomic) BOOL statusIsChanged; //用户状态是否发生了变化

+ (HbhUser *)sharedHbhUser;

/**
 *  登陆用户，并储存用户信息至沙箱
 *
 *  @param userDic 用户信息数组
 */
- (void)loginUserWithUserDictionnary:(NSDictionary *)userDic;

//退出登陆
- (void)logoutUser;
//保存文件至沙箱
- (void)writeUserInfoToFile;

@end
