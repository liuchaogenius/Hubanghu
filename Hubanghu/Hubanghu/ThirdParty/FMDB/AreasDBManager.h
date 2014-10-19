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

@interface AreasDBManager : NSObject
{
    FMDatabaseQueue *dataQueue;
    NSString *dbQueuePath;
}


+ (AreasDBManager *)shareFMDBManager;
///将数据存入数据库
- (void)insertAreaToTable:(NSString *)aAreaId
                     name:(NSString*)aName
                    level:(int)aLevel
                   parent:(NSString *)aParent
                 typeName:(NSString *)aTypeName
                firstchar:(NSString *)aFirstchar;
///获取根据字母分组城市
- (void)selGroupAreaCity:(void(^)(NSMutableDictionary *cityDict))aCityBlock;

////获取所有省份
- (void)selProvince:(void(^)(NSMutableArray *cityArry))aProvinceBlock;

///获取省份下面对应的城市
- (void)selProvinceOfCity:(NSString *)aParent district:(void(^)(NSMutableArray *cityArry))acityBlock __attribute__((nonnull(1)));

///获取市对应的区
- (void)selCityOfDistrict:(NSString *)aParent district:(void(^)(NSMutableArray *districtArry))aDistrictBlock __attribute__((nonnull(1)));

@end