//
//  HbuAreaLocationManager.m
//  Hubanghu
//
//  Created by yato_kami on 14/10/19.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbuAreaLocationManager.h"
#import "HbuAreaListModelBaseClass.h"
#import "NetManager.h"
#import "AreasDBManager.h"
#import "SLocationManager.h"
@implementation HbuAreaLocationManager
/*
- (BOOL)isHaveData
{
    [self.areasDBManager selGroupAreaCity:^(NSMutableDictionary *cityDict){
        if (cityDict) {
            return YES;
        }else{
            return NO;
        }
    }];
}*/

- (AreasDBManager *)areasDBManager
{
    if (!_areasDBManager) {
        _areasDBManager = [[AreasDBManager alloc] init];
    }
    return _areasDBManager;
}
#warning 调用这个接口之前要先判断本地是否存在数据，还有一个判断这个接口数据版本

- (void)getAreaListInfoWithsucc:(void(^)(HbuAreaListModelBaseClass* areaListModel))succ failure:(void(^)())failure
{
    NSString *getAreaListUrl = nil;
    NSInteger time = CFAbsoluteTimeGetCurrent()/1000;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:time] forKey:@"time"];
    kHubRequestUrl(@"getAreaList.ashx",getAreaListUrl);
    [NetManager requestWith:dic url:getAreaListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        
        NSDictionary *dataDic = successDict[@"data"];
        
        if (succ){
            succ([HbuAreaListModelBaseClass modelObjectWithDictionary:dataDic]);
        }
        
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"%@",error.localizedDescription);
    }];
}

- (void)getAreasDataAndSaveToDBifNeeded
{
    [self.areasDBManager selGroupAreaCity:^(NSMutableDictionary *cityDict){
        if (cityDict) {
            //不用获取
        }else{
            [self getAreaListInfoWithsucc:^(HbuAreaListModelBaseClass *areaListModel) {
                [self saveDataToDBWithAreasArray:areaListModel.areas];
            } failure:^{
            }];
        }
    }];
}

- (void)saveDataToDBWithAreasArray:(NSArray *)areas
{
    
    if (areas && areas.count > 0) {
        for (HbuAreaListModelAreas *area in areas) {
            [self.areasDBManager insertAreaToTable:[NSString stringWithFormat:@"%lf",area.areaId] name:area.name level:area.level parent:[NSString stringWithFormat:@"%lf",area.parent] typeName:area.typeName firstchar:area.firstchar];
        }
#warning 对应保存这份数据的time（版本号） nsuser
    }
}

#pragma mark - 获取位置
- (void)getUserLocation
{
    SLocationManager *locationManager = [SLocationManager getMyLocationInstance];
    if([locationManager getLocationAuthorStatus] == 0 || [locationManager getLocationAuthorStatus]>= 3)
    {
        [locationManager statUpdateLocation:^(Location2d al2d) {
#warning 需要把定位度添加http头里面
            if (al2d.code == 1) {
                [[NetManager shareInstance] setLat:al2d.lat];
                [[NetManager shareInstance] setLon:al2d.lon];
            }
            [locationManager getLocationAddress:NO resultBlock:^(NSDictionary *aLocationDict, Location2d aL2d) {
#warning 对比城市 创建currentAreas
                /*
                for () {
                    
                }
                 */
            }];
        }];
    }
    else
    {
#warning  return 一个值 让用户自己选择城市
    }
}

- (void)setCurrentAreas:(HbuAreaListModelAreas *)currentAreas
{
    _currentAreas = currentAreas;
#warning 设置http透明的areadid
}

@end
