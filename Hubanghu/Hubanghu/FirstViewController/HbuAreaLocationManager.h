//
//  HbuAreaLocationManager.h
//  Hubanghu
//
//  Created by yato_kami on 14/10/19.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreasDBManager.h"
#import "HbuAreaListModelAreas.h"

enum error_Type
{
    errorType_locationFailed = 1, //定位失败
    errorType_matchCityFailed,//匹配城市失败
    errorType_notOpenService, //未开启定位服务
    
    //下面三个 与上面对应，但是检测到有上次 定位/用户选择 的城市
    errorType_hadData_locFail,
    errorType_hadData_matchCfail,
    errorType_hadData_notOpService
};

@class HbuAreaListModelBaseClass;
@interface HbuAreaLocationManager : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) AreasDBManager *areasDBManager;
@property (nonatomic, strong) HbuAreaListModelAreas *currentAreas; //当前城市
@property (nonatomic, strong) HbuAreaListModelAreas *currentDistrict;//当前区
@property (nonatomic, strong) HbuAreaListModelAreas *currentProvince;//当前省
@property (nonatomic, strong) NSString *localCirtyName;//定位结果城市名字

//单例方法
+ (instancetype)sharedManager;

//从网络获取地区信息，并存入数据库（如果数据库没有地区信息）
- (void)getAreasDataAndSaveToDBifNeeded;
//定位
- (void)getUserLocationWithSuccess : (void (^)())sBlock Fail : (void(^)(NSString *failString,int errorType))aFailBlock;
//从网络获取地区信息，并存入数据库（不管数据库有没有地区信息）
- (void)shouldGetAreasDataAndSaveToDBWithSuccess : (void (^)())sBlock Fail : (void(^)())fBlock;

@end
