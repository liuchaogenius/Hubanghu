//
//  MessageDefine.h
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#ifndef Hubanghu_MessageDefine_h
#define Hubanghu_MessageDefine_h

#define kLeftViewPushMessage @"leftviewpushmessage"
#define kLeftViewPopMessage @"leftviewpopmessage"
#define kLoginForUserMessage @"loginforuser"
#define kLoginSuccessMessae @"loginsuccess" //登陆成功发送消息
#define kLoginFailMessage @"loginFail"
#define kChanageCurrentCity @"chanageCurrentCity"
#define kSelCityMessage @"selCitymessage" //show selcityVC

#define kPaySuccess @"paySuccess"
#define kPayFail @"payFail"

#define KHotlineTel  @"400-663-8585"
#define kAlipayPartnerId @"2088311602278363"
#define kAlipaySellerAcount @"hu8hu888@sina.com"
#define kAlipayOrderResultMessage @"payorderResult" 
#define kUMENG_APPKEY  @"5455121dfd98c55f55004fa9"
#define kShareWEIXINAPPID @"wxe6b503e2e0a525bb"
#define kShareWEIXINAPPSECRET  @"184bdda809f433132d978ca25ddce157"
typedef NS_ENUM(int, NS_LeftButtonName)
{
    E_USERINTRODUCE,//用户须知
    E_SERVICECOMMIT,//服务承诺
    E_SERVICESTANDARD,//服务标准
    E_FEEDBACK,//投诉反馈
    E_ABOUTUS,//关于户帮户
    E_SHAREHBH,//分享
    E_HOTILINE,//客服
    E_GOMYTAB//进入我的页面
    
};

enum CateId_Type
{
    CateId_floor = 1,//地板
    CateId_bathroom,//卫浴
    CateId_light,//灯饰
    CateId_wallpaper,//墙纸
    CateId_renovate,//二次翻新
    CateId_niceWorker//优秀工人
};
#endif
