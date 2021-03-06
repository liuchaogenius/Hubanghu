//
//  FMDBManager.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "AreasDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "HbuAreaListModelAreas.h"
#define DataBaseName @"AreasDatabase.sqlite"
#define kDataBaseQueueName @"DatabaseQueue.sqlite"

@implementation AreasDBManager

//+ (AreasDBManager *)shareFMDBManager
//{
//    static AreasDBManager *g_DBManager = nil;
//    if(!g_DBManager)
//    {
//        @synchronized(self)
//        {
//            if(!g_DBManager)
//            {
//                g_DBManager = [[AreasDBManager alloc] init];
//            }
//        }
//    }
//    
//    return g_DBManager;
//}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *strhotPath = [paths objectAtIndex:0];
        dbQueuePath = [strhotPath stringByAppendingPathComponent:kDataBaseQueueName];
        dataQueue = [FMDatabaseQueue databaseQueueWithPath:dbQueuePath];
        MLOG(@"dataQueuePath = %@", dbQueuePath);
        if ([manager fileExistsAtPath:dbQueuePath] == NO)
        {
            [manager createFileAtPath:dbQueuePath contents:nil attributes:nil];

        }
//        [dataQueue inDatabase:^(FMDatabase *db) {
//            if([db open])
//            {
//                [db close];
//                MLOG(@"table create success");
//            }
//            
//        }];
//        [dataQueue close];
        [self createAreasTable];
        [self creatHotCitysTable];
    }
    return self;
}

- (void)tableIsExit
{
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = 'sqlite_master'"]];
        
        [set next];
        
        NSInteger count = [set intForColumnIndex:0];
        
        BOOL existTable = !!count;
        
        if (!existTable) {
            [weakself createAreasTable];
        }
    }];

}

- (void)createAreasTable
{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlCreateAreasTable = [NSString stringWithFormat:@"create table areas_table('areaId','name','level','parent','TypeName','firstchar')"];
            BOOL res = [db executeUpdate:sqlCreateAreasTable];
            if(res)
            {
                MLOG(@"areas表创建成功");
            }
            else
            {
                MLOG(@"areas表创建失败或者表已经存在");
            }
        }
    }];
}



- (void)selHbuArealistModel:(NSString *)aCityName resultBlock:(void(^)(HbuAreaListModelAreas*model))aResultBlock
{
    __weak AreasDBManager *weakself = self;
    if(aCityName == nil)
    {
        aResultBlock(nil);
        return;
    }
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            BOOL isHave=NO;
            NSString *selCity=@"select * from areas_table where TypeName='市'";
            FMResultSet *resultset = [db executeQuery:selCity];
            if(resultset)
            {
                while ([resultset next]) {
                    NSString *name= [resultset stringForColumn:@"name"];
                    if([name hasPrefix:aCityName] || [aCityName hasPrefix:name])
                    {
                        HbuAreaListModelAreas *model = [weakself parseFMResultToHubAreasModel:resultset];
                        isHave = YES;
                        aResultBlock(model);
                    }
                }
                if(isHave == NO)
                {
                    aResultBlock(nil);
                }
            }
        }
        else
        {
            aResultBlock(nil);
        }
    }];
}

- (void)selHbuArealistModelOfCity:(NSString *)aCityName district:(NSString *)aDistrictName resultBlock:(void(^)(HbuAreaListModelAreas *city,HbuAreaListModelAreas *district))aResultBlock
{
    __weak AreasDBManager *weakself = self;
    if (aDistrictName == nil) {
        aResultBlock(nil,nil);
        return;
    }
    [dataQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *selCity=@"select * from areas_table where TypeName='市'";
            FMResultSet *resultset = [db executeQuery:selCity];
            if(resultset)
            {
                while ([resultset next]) {
                    NSString *name= [resultset stringForColumn:@"name"];
                    if([name hasPrefix:aCityName] || [aCityName hasPrefix:name])
                    {
                        HbuAreaListModelAreas *city = [weakself parseFMResultToHubAreasModel:resultset];
                        //检索区
                        NSString *selDistrict = @"select * from areas_table where TypeName = '区' and parent = ?";
                        NSString *aAreaId = [NSString stringWithFormat:@"%d",(int)city.areaId];
                        FMResultSet *aResult = [db executeQuery:selDistrict,aAreaId];
                        if (aResult) {
                            while ([aResult next]) {
                                NSString *aName = [aResult stringForColumn:@"name"];
                                if ([aName hasPrefix:aDistrictName] || [aDistrictName hasPrefix:aName]) {
                                    HbuAreaListModelAreas *district = [weakself parseFMResultToHubAreasModel:aResult];
                                    aResultBlock(city,district);
                                    return ;
                                }
                            }
                            aResultBlock(city,nil);
                            return;
                        }else{
                            aResultBlock(city,nil);
                            return;
                        }
                    }
                }
                aResultBlock(nil,nil);
            }
        }
        else
        {
            aResultBlock(nil,nil);
        }
    }];
}

- (void)insertAreaToTable:(NSString *)aAreaId
                     name:(NSString*)aName
                    level:(int)aLevel
                   parent:(NSString *)aParent
                 typeName:(NSString *)aTypeName
                firstchar:(NSString *)aFirstchar

{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            if(aFirstchar && aFirstchar.length>0)
            {
                NSString *sel = @"select * from areas_table where areaId=?";
                FMResultSet *cityResultset = [db executeQuery:sel,aAreaId];
                if(![cityResultset next])
                {
                    NSString *first = [aFirstchar substringToIndex:1];
                    NSString *sqlIntoArea = [NSString stringWithFormat:@"insert into areas_table('areaId','name','level','parent','TypeName','firstchar') values(?,?,?,?,?,?)"];
                    BOOL res = [db executeUpdate:sqlIntoArea,
                                aAreaId,aName,[NSNumber numberWithInt:aLevel],aParent,aTypeName,first];
                    MLOG(@"insertAreaRes=%d", res);
                }
            }
        }
    }];

}

- (void)selGroupAreaCity:(void(^)(NSMutableDictionary *cityDict))aCityBlock
{
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            for(int i=65; i<=90;i++)
            {
                unichar asi = i;
                NSString *indexchar = [NSString stringWithFormat:@"%c",asi];
                NSString *sqlSELcity = @"select * from areas_table where firstchar=? AND TypeName='市'";
                NSMutableArray *mutArry = [[NSMutableArray alloc] init];
                FMResultSet *cityResultset = [db executeQuery:sqlSELcity,indexchar];
                while([cityResultset next])
                {
                    HbuAreaListModelAreas *model = [weakself parseFMResultToHubAreasModel:cityResultset];
                    if(model)
                    {
                        [mutArry addObject:model];
                    }
                }
                if(mutArry.count>0)
                {
                    [mutDict setObject:mutArry forKey:indexchar];
                }
            }
            aCityBlock(mutDict);
        }
    }];
}

- (void)selProvince:(void(^)(NSMutableArray *cityArry))aProvinceBlock
{
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from areas_table where TypeName='省'";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity];
            while([cityResultset next])
            {
                HbuAreaListModelAreas *model = [weakself parseFMResultToHubAreasModel:cityResultset];
                if(model)
                {
                    [mutArry addObject:model];
                }
            }
            aProvinceBlock(mutArry);
        }
    }];
}


- (void)selProvinceOfCity:(NSString *)aParent district:(void(^)(NSMutableArray *cityArry))acityBlock
{
    if(aParent == nil)
    {
        acityBlock(nil);
        return;
    }
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from areas_table where parent=?";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity,aParent];
            while([cityResultset next])
            {
                HbuAreaListModelAreas *model = [weakself parseFMResultToHubAreasModel:cityResultset];
                if(model)
                {
                    [mutArry addObject:model];
                }
            }
            acityBlock(mutArry);
        }
    }];
}

- (void)selCityOfDistrict:(NSString *)aParent district:(void(^)(NSMutableArray *districtArry))aDistrictBlock
{
    if(aParent == nil)
    {
        aDistrictBlock(nil);
        return;
    }
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from areas_table where parent=?";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity,aParent];
            while([cityResultset next])
            {
                HbuAreaListModelAreas *model = [weakself parseFMResultToHubAreasModel:cityResultset];
                if(model)
                {
                    [mutArry addObject:model];
                }
            }
            aDistrictBlock(mutArry);
        }
    }];
}


- (void)selParentModel:(NSString *)aAreadid resultBlock:(void(^)(HbuAreaListModelAreas*model))aResultBlock __attribute__((nonnull(1)))
{
    if(aAreadid)
    {
        __weak AreasDBManager *weakself = self;
        [dataQueue inDatabase:^(FMDatabase *db) {
            NSString *selModel = @"select * from areas_table where areaId=?";
            FMResultSet *resultset = [db executeQuery:selModel,aAreadid];
            HbuAreaListModelAreas *model = nil;
            while([resultset next])
            {
                model = [weakself parseFMResultToHubAreasModel:resultset];
            }
            aResultBlock(model);
        }];
    }
    else
    {
        aResultBlock(nil);
    }
}

- (void)firstCityOfFirstProvinceResultBlock:(void(^)(HbuAreaListModelAreas*model))aCityBlock
{
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from areas_table where parent  = (SELECT areaId FROM areas_table  where TypeName like '省'  limit 1) and TypeName like '市' limit 1;";
            HbuAreaListModelAreas *model = nil;
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity];
            while([cityResultset next])
            {
                model = [weakself parseFMResultToHubAreasModel:cityResultset];
            }
            aCityBlock(model);
        }
    }];
}


- (HbuAreaListModelAreas *)parseFMResultToHubAreasModel:(FMResultSet *)aResultSet
{
    if(aResultSet)
    {
        HbuAreaListModelAreas *model = [[HbuAreaListModelAreas alloc] init];
        model.areaId = [aResultSet stringForColumn:@"areaId"].integerValue;
        model.name= [aResultSet stringForColumn:@"name"];
        model.level= [aResultSet intForColumn:@"level"];
        model.parent= [aResultSet stringForColumn:@"parent"].integerValue;
        model.typeName= [aResultSet stringForColumn:@"TypeName"];
        model.firstchar= [aResultSet stringForColumn:@"firstchar"];
        return model;
    }
    return nil;
}

#pragma markm - hotCity 

- (void)creatHotCitysTable
{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlCreateHotCitysTable = [NSString stringWithFormat:@"create table hotCitys_table('areaId','name','level','parent','TypeName','firstchar','ishotcity')"];
            BOOL res = [db executeUpdate:sqlCreateHotCitysTable];
            if(res)
            {
                MLOG(@"hotcity表创建成功");
            }
            else
            {
                MLOG(@"hotcity表创建失败或者表已经存在");
            }
        }
    }];
}



- (void)insertAreaToHotCityTable:(NSString *)aAreaId
                            name:(NSString*)aName
                           level:(int)aLevel
                          parent:(NSString *)aParent
                        typeName:(NSString *)aTypeName
                       firstchar:(NSString *)aFirstchar
                       ishotcity:(int)aIshotcity

{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            if(aFirstchar && aFirstchar.length>0)
            {
                NSString *sel = @"select * from hotCitys_table where areaId=?";
                FMResultSet *cityResultset = [db executeQuery:sel,aAreaId];
                if(![cityResultset next])
                {
                    NSString *first = [aFirstchar substringToIndex:1];
                    NSString *sqlIntoArea = [NSString stringWithFormat:@"insert into hotCitys_table('areaId','name','level','parent','TypeName','firstchar','ishotcity') values(?,?,?,?,?,?,?)"];
                    BOOL res = [db executeUpdate:sqlIntoArea,
                                aAreaId,aName,[NSNumber numberWithInt:aLevel],aParent,aTypeName,first,[NSNumber numberWithInt:aIshotcity]];
                    MLOG(@"insertHotCity=%d", res);
                }
            }
        }
    }];
    
}

- (void)selHotCityResultBlock:(void(^)(NSMutableArray *cityArray))acityBlock
{
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from hotCitys_table where TypeName like '市'";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity];
            while([cityResultset next])
            {
                HbuAreaListModelAreas *model = [weakself parseFMResultToHubAreasModel:cityResultset];
                if(model)
                {
                    [mutArry addObject:model];
                }
            }
            acityBlock(mutArry);
        }
    }];
}
- (void)clearAreasData
{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sql = @"delete from areas_table";
            [db executeUpdate:sql];
            //NSString *sql2 = @"update sqlite_sequence set seq=0 where name= ’areas_table‘";
            //[db executeUpdate:<#(NSString *), ...#>]
        }
    }];
}

- (void)clearHotCitiesData
{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sql = @"delete from hotCitys_table";
            [db executeUpdate:sql];
        }
    }];
}


@end
