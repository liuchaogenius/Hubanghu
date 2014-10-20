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

- (AreasDBManager *)areasDBManager
{
    if (!_areasDBManager) {
        _areasDBManager = [[AreasDBManager alloc] init];
    }
    return _areasDBManager;
}

+ (instancetype)sharedManager
{
    static HbuAreaLocationManager *areaMa;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaMa = [[HbuAreaLocationManager alloc] init];
    });
    return areaMa;
}


//获取并保存地区数据 如果需要的话
- (void)getAreasDataAndSaveToDBifNeeded
{
    __weak HbuAreaLocationManager *weakSelf = self;
    [self.areasDBManager selGroupAreaCity:^(NSMutableDictionary *cityDict){
//        [weakSelf.areasDBManager selProvince:^(NSMutableArray *cityArry) {
//            MLOG(@"%@",cityArry);
//        }];
        if (cityDict) {
            //不用获取
        }else{
            [weakSelf getAreaListInfoWithsucc:^(HbuAreaListModelBaseClass *areaListModel) {
                [weakSelf saveDataToDBWithAreasArray:(HbuAreaListModelBaseClass *)areaListModel];
            } failure:^{
            }];
        }
    }];
}

#warning 调用这个接口之前要先判断本地是否存在数据，还有一个判断这个接口数据版本
//网络请求 获取地区数据
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

//将地区数据保存到DB
- (void)saveDataToDBWithAreasArray:(HbuAreaListModelBaseClass *)areaListModel
{
    NSArray *areas = areaListModel.areas;
    if (areas && areas.count > 0) {
        for (HbuAreaListModelAreas *area in areas) {
            [self.areasDBManager insertAreaToTable:[NSString stringWithFormat:@"%d",(int)area.areaId] name:area.name level:(int)area.level parent:[NSString stringWithFormat:@"%d",(int)area.parent] typeName:area.typeName firstchar:area.firstchar];
        }
#warning 对应保存这份数据的time（版本号） nsuser
        double time = areaListModel.time;
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
                if (al2d.lat) {
                    [[NetManager shareInstance] setLat:al2d.lat];
                }
                if (al2d.lon) {
                    [[NetManager shareInstance] setLon:al2d.lon];
                }
            }
            [locationManager getLocationAddress:NO resultBlock:^(NSDictionary *aLocationDict, Location2d aL2d) {
#warning 对比城市 创建currentAreas
                //MLOG(@"%@",aLocationDict[@"City"]);
                [self.areasDBManager selGroupAreaCity:^(NSMutableDictionary *cityDict) {
                    MLOG(@"%@",cityDict);
                }];
                [self.areasDBManager selHbuArealistModel:aLocationDict[@"City"] resultBlock:^(HbuAreaListModelAreas *model) {
                    NSLog(@"model ---------- %@",model);
                }];
                
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
