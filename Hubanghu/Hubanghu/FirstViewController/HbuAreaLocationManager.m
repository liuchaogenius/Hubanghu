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
#import "HbhSelCityViewController.h"

@implementation HbuAreaLocationManager

@synthesize currentAreas = _currentAreas;


- (void)setCurrentAreas:(HbuAreaListModelAreas *)currentAreas
{
    _currentAreas = currentAreas;
// 设置http透明的areadid
    if (_currentAreas.areaId) {
        [[NetManager shareInstance] setAreaId:[NSString stringWithFormat:@"%f",_currentAreas.areaId]];
        //修改文件，记录地区
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSData *currentAreasData = [NSKeyedArchiver archivedDataWithRootObject:_currentAreas];
        [userDefault setObject:currentAreasData forKey:@"currentAreas"];
        
        [userDefault removeObjectForKey:@"currentDistrict"];
        [userDefault synchronize];
    }
}

- (void)setCurrentDistrict:(HbuAreaListModelAreas *)currentDistrict
{
    _currentDistrict = currentDistrict;
    if (_currentDistrict.areaId) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *currentAreasData = [NSKeyedArchiver archivedDataWithRootObject:_currentDistrict];
        [userDefault setObject:currentAreasData forKey:@"currentDistrict"];
        [userDefault synchronize];
    }
}

- (void)setCurrentProvince:(HbuAreaListModelAreas *)currentProvince
{
    _currentProvince = currentProvince;
    if (_currentProvince.areaId) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *currentAreasData = [NSKeyedArchiver archivedDataWithRootObject:_currentProvince];
        [userDefault setObject:currentAreasData forKey:@"currentProvince"];
        [userDefault synchronize];
    }
}

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

- (instancetype)init
{
    self = [super init];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSData *currentAreaDate = [userDefault objectForKey:@"currentAreas"];
    NSData *currentDistrictData = [userDefault objectForKey:@"currentDistrict"];
    NSData *currentProvinceData = [userDefault objectForKey:@"currentProvince"];
    if (currentAreaDate) {
        self.currentAreas = [NSKeyedUnarchiver unarchiveObjectWithData:currentAreaDate];
        if (currentDistrictData) {
            self.currentDistrict = [NSKeyedUnarchiver unarchiveObjectWithData:currentAreaDate];
        }
        if (currentProvinceData) {
            self.currentProvince = [NSKeyedUnarchiver unarchiveObjectWithData:currentProvinceData];
        }
    }
    return self;
}

//获取并保存地区数据 如果需要的话
- (void)getAreasDataAndSaveToDBifNeeded
{
    __weak HbuAreaLocationManager *weakSelf = self;
    [self.areasDBManager selGroupAreaCity:^(NSMutableDictionary *cityDict){
        if (!cityDict) {
            //不用获取
        }else{
            [weakSelf getAreaListInfoWithsucc:^(HbuAreaListModelBaseClass *areaListModel) {
                [weakSelf saveDataToDBWithAreasArray:(HbuAreaListModelBaseClass *)areaListModel];
            } failure:^{
            }];
        }
    }];
}

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
// 对应保存这份数据的time（版本号） nsuser
        double time = areaListModel.time;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setDouble:time forKey:@"time"];
    }
}

#pragma mark 无视是否有本地数据,进行地区模型的获取，并存入DB
- (void)shouldGetAreasDataAndSaveToDBWithSuccess : (void (^)())sBlock Fail : (void(^)())fBlock{
    __weak HbuAreaLocationManager *weakSelf = self;
    [self getAreaListInfoWithsucc:^(HbuAreaListModelBaseClass *areaListModel) {
        [weakSelf saveDataToDBWithAreasArray:areaListModel];
        if (sBlock) {
            sBlock();
        }
    } failure:^{
        if(fBlock){
            fBlock();
        }
    }];
}

#pragma mark - 获取位置
- (void)getUserLocationWithSuccess : (void (^)())sBlock Fail : (void(^)(NSString *failString,int errorType))aFailBlock
{
    
    SLocationManager *locationManager = [SLocationManager getMyLocationInstance];
    if([locationManager getLocationAuthorStatus] == 0 || [locationManager getLocationAuthorStatus]>= 3)
    {
        __weak HbuAreaLocationManager *weakSelf = self;
        [locationManager statUpdateLocation:^(Location2d al2d) {
// 需要把定位度添加http头里面
            if (al2d.code == 1) {
                if (al2d.lat) {
                    [[NetManager shareInstance] setLat:al2d.lat];
                }
                if (al2d.lon) {
                    [[NetManager shareInstance] setLon:al2d.lon];
                }
            }
            [locationManager getLocationAddress:NO resultBlock:^(NSDictionary *aLocationDict, Location2d aL2d) {
// 对比城市 创建currentAreas
                MLOG(@"%@",aLocationDict);
                NSDictionary *result = aLocationDict[@"result"];
                NSDictionary *addressDic = result[@"addressComponent"];
                MLOG(@"city:%@",addressDic[@"city"]);
                MLOG(@"district:%@",addressDic[@"district"]);
                MLOG(@"province:%@",addressDic[@"province"]);
                
                if (addressDic[@"city"]) {
                    [weakSelf.areasDBManager selHbuArealistModelOfCity:addressDic[@"city"] district:addressDic[@"district"] resultBlock:^(HbuAreaListModelAreas *city, HbuAreaListModelAreas *district) {
                        MLOG(@"%@   %@",city.name,district.name);
                        if (city) {
                            weakSelf.currentAreas = city;
                            if (district) {
                                weakSelf.currentDistrict = district;
                            }
                            sBlock();
                        }else{
                            weakSelf.currentAreas ? (aFailBlock(nil,errorType_hadData_matchCfail)):(aFailBlock(@"匹配用户城市失败，请手动选择",errorType_matchCityFailed));
                        }
                        
                    }];/*
                   
                }else{
                    weakSelf.currentAreas ? (aFailBlock(nil,errorType_hadData_locFail)) : (aFailBlock(@"定位用户城市失败，请手动选择",errorType_locationFailed));                }
            }];
        }];
    }
    else
    {
// return 一个值 让用户自己选择城市
        aFailBlock(@"未开启定位服务",errorType_notOpenService);
    }
}






@end
