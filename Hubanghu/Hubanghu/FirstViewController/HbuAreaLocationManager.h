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

@class HbuAreaListModelBaseClass;
@interface HbuAreaLocationManager : NSObject

@property (strong, nonatomic) AreasDBManager *areasDBManager;
@property (nonatomic, strong) HbuAreaListModelAreas* currentAreas;

//单例方法
+ (instancetype)sharedManager;

//从网络获取地区信息，并存入数据库（如果数据库没有地区信息）
- (void)getAreasDataAndSaveToDBifNeeded;
//定位
- (void)getUserLocationWithSuccess : (void (^)())sBlock Fail : (void(^)(NSString *failString))aFailBlock;
@end
