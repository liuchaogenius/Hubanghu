//
//  FWLocationObj.h
//  FW_Project
//
//  Created by  striveliu on 14-2-20.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef struct{
    float lon;
    float lat;
    int code;//1:定位成功 0:用户权限没有开 2:定位失败或者超时
}Location2d;

@interface SLocationManager : NSObject<CLLocationManagerDelegate>
{
    CLRegion *lregion;
    BOOL isLocationing;
}
//@property (nonatomic, strong) NSSet *runLoopModes;
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
//@property (nonatomic, assign) Location2d l2d;
@property (nonatomic, strong) NSDictionary *locationDict;
@property (nonatomic, copy) void(^addressBlock)(NSDictionary *aLocationDict,Location2d aL2d);
@property (nonatomic, copy) void(^locationDegree)(Location2d aL2d);
+ (SLocationManager *)getMyLocationInstance;
- (void)statUpdateLocation:(void(^)(Location2d al2d))aBlock;
- (void)getLocationAddress:(BOOL)isStartLocation resultBlock:(void(^)(NSDictionary *aLocationDict,Location2d aL2d))aBlock;
- (int)getLocationAuthorStatus;
@end
