//
//  FMDBManager.h
//  Hubanghu
//
//  Created by  striveliu on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class FMDatabaseQueue;
@class HbuAreaListModelAreas;
@interface AreasDBManager : NSObject
{
    FMDatabaseQueue *dataQueue;
    NSString *dbQueuePath;
}


//+ (AreasDBManager *)shareFMDBManager;
///将数据存入数据库
- (void)insertAreaToTable:(NSString *)aAreaId
                     name:(NSString*)aName
                    level:(int)aLevel
                   parent:(NSString *)aParent
                 typeName:(NSString *)aTypeName
                firstchar:(NSString *)aFirstchar;
///获取根据字母分组城市
- (void)selGroupAreaCity:(void(^)(NSMutableDictionary *cityDict))aCityBlock;

- (void)selHbuArealistModel:(NSString *)aCityName resultBlock:(void(^)(HbuAreaListModelAreas*model))aResultBlock __attribute__((nonnull(1)));
- (void)selHbuArealistModelOfCity:(NSString *)aCityName district:(NSString *)aDistrictName resultBlock:(void(^)(HbuAreaListModelAreas *city,HbuAreaListModelAreas *district))aResultBlock;

////获取所有省份
- (void)selProvince:(void(^)(NSMutableArray *cityArry))aProvinceBlock;

///获取省份下面对应的城市
- (void)selProvinceOfCity:(NSString *)aParent district:(void(^)(NSMutableArray *cityArry))acityBlock __attribute__((nonnull(1)));

///获取市对应的区
- (void)selCityOfDistrict:(NSString *)aParent district:(void(^)(NSMutableArray *districtArry))aDistrictBlock __attribute__((nonnull(1)));
///根据areaid 获取当前的数据model  如果要是获取当前areaid对应的parentid的mode  这里的areadid传parentid就是返回parentid对应的数据model
- (void)selParentModel:(NSString *)aAreadid resultBlock:(void(^)(HbuAreaListModelAreas*model))aResultBlock __attribute__((nonnull(1)));
//获取第一个省下的第一个city
- (void)firstCityOfFirstProvinceResultBlock:(void(^)(HbuAreaListModelAreas*model))aCityBlock;

//向热门城市表插入数据
- (void)insertAreaToHotCityTable:(NSString *)aAreaId
                            name:(NSString*)aName
                           level:(int)aLevel
                          parent:(NSString *)aParent
                        typeName:(NSString *)aTypeName
                       firstchar:(NSString *)aFirstchar
                       ishotcity:(int)aIshotcity;
//获取热门城市数组
- (void)selHotCityResultBlock:(void(^)(NSMutableArray *cityArray))acityBlock;

//清空用户城市数据库数据
- (void)clearAreasData;
//清空用户hotcity数据库数据
- (void)clearHotCitiesData;
@end
