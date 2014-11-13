//
//  HbhUser.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhUser.h"
#import "SynthesizeSingleton.h"
#import "HbuAreaLocationManager.h"
#import "NetManager.h"
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
        //MLOG(@"%@",_userFilePath);
    }
    return _userFilePath;
}

- (id)init
{
    MLOG(@"%@",self.userFilePath);
    self = [super init];
    _isLogin = NO;
    _nickName = nil;
    _userID = nil;
    _photoUrl = nil;
    _QRCodeUrl = nil;
    _phone = nil;
    _point = 0;
    _encodedToken = nil;
    _localPhoto = nil;
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
                [[NetManager shareInstance] setUserid:self.userID];
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
    int uid = [[userDic objectForKey:@"id"] intValue];
    self.userID = [NSString stringWithFormat:@"%d",uid];
//    if(self.userID)
//    {
//        [[NetManager shareInstance] setUserid:self.userID];
//    }
    self.photoUrl = userDic[@"photoUrl"];
    self.phone = userDic[@"phone"];
    self.point = [userDic[@"point"] integerValue];
    self.QRCodeUrl = userDic[@"QRCodeUrl"];
    self.encodedToken = userDic[@"encodedToken"];
    self.localPhoto = userDic[@"localPhoto"];
}

//保存用户信息文件至沙箱
- (void)writeUserInfoToFile
{
    self.nickName = self.nickName?:@"";
    self.userID = self.userID?:@"";
    self.photoUrl = self.photoUrl?:@"";
    self.phone = self.phone?:@"";
    self.QRCodeUrl = self.QRCodeUrl?:@"";
    self.encodedToken = self.encodedToken?:@"";
    self.localPhoto = self.localPhoto ? :@"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"nickName":self.nickName, @"id":self.userID, @"photoUrl":self.photoUrl, @"phone":self.phone, @"point":[NSNumber numberWithInteger:self.point],@"QRCodeUrl":self.QRCodeUrl,@"encodedToken":self.encodedToken,@"localPhoto":self.localPhoto}];
    [dic writeToFile:self.userFilePath atomically:YES];
    //MLOG(@"%@",self.userFilePath);
}
@end
