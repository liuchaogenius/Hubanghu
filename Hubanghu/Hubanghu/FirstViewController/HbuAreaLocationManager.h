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
@property (assign, nonatomic) BOOL isHaveData;
@property (nonatomic, strong) HbuAreaListModelAreas* currentAreas;
- (void)getAreaListInfoWithsucc:(void(^)(HbuAreaListModelBaseClass* areaListModel))succ failure:(void(^)())failure;

@end
