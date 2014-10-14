//
//  User.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) BOOL isLogin;//是否登录
@property (strong, nonatomic) NSString *userID; //id
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *photoUrl;
@property (strong, nonatomic) NSString *QRCodeUrl;
@property (strong, nonatomic) NSString *phone;
@property (nonatomic) NSInteger point;
@property (strong, nonatomic) NSString *encodedToken;

+ (User *)sharedUser;

@end
