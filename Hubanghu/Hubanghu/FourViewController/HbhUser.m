//
//  HbhUser.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhUser.h"
#import "SynthesizeSingleton.h"

@interface HbhUser()
@property (strong, nonatomic) NSString *userFilePath; //用户文件路径
//@property (strong, nonatomic) NSMutableDictionary *userInfoDic;//用户信息字典
@end
@implementation HbhUser
SYNTHESIZE_SINGLETON_FOR_CLASS(HbhUser);

#pragma mark - getter and setter
- (NSString *)userFilePath
{
    if (!_userFilePath) {
        NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = storeFilePath[0];
        _userFilePath = [docPath stringByAppendingPathComponent:@"user.plist"];
    }
    return _userFilePath;
}

- (id)init
{
    self = [super init];
    _isLogin = NO;
    _nickName = nil;
    _userID = nil;
    _photoUrl = nil;
    _QRCodeUrl = nil;
    _phone = nil;
    _point = 0;
    _encodedToken = nil;
    _statusIsChanged = NO;
    [self loadLocalUserInfo]; //判断沙箱是否有数据，并修改数据
    return self;
}

//加载本地用户文件数据
- (void)loadLocalUserInfo
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.userFilePath]) {
        NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:self.userFilePath];
        if (userDic[@"encodedToken"]) {
            NSString *encodedToken = userDic[@"encodedToken"];
            
            if (encodedToken.length) {
                [self loadUserInfoWithDictionary:userDic];
            }
        }
    }
}
//登陆用户
- (void)loginUserWithUserDictionnary:(NSDictionary *)userDic
{
    [self loadUserInfoWithDictionary:userDic];
    [self writeUserInfoToFile];
}

//退出登录
- (void)logoutUser
{
    _isLogin = NO;
    _encodedToken = @"";
    [self writeUserInfoToFile];
    
}

//加载用户数据 - 通过dic
- (void)loadUserInfoWithDictionary:(NSDictionary *)userDic
{
    _isLogin = YES;
    self.nickName = userDic[@"nickName"];
    self.userID = userDic[@"id"];
    self.photoUrl = userDic[@"photoUrl"];
    self.phone = userDic[@"phone"];
    self.point = [userDic[@"point"] integerValue];
    self.QRCodeUrl = userDic[@"QRCodeUrl"];
    self.encodedToken = userDic[@"encodedToken"];
}

//保存用户信息文件至沙箱
- (void)writeUserInfoToFile
{
    NSDictionary *dic = @{@"nickName":self.nickName, @"id":self.userID, @"photoUrl":self.photoUrl, @"phone":self.phone, @"point":[NSNumber numberWithInteger:self.point], @"QRCodeUrl":self.QRCodeUrl,@"encodedToken":self.encodedToken};
    [dic writeToFile:self.userFilePath atomically:YES];
    //MLOG(@"%@",self.userFilePath);
}
@end