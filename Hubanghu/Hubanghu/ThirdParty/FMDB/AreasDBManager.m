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
#import "HubAreasModel.h"
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
        if ([manager fileExistsAtPath:dbQueuePath] == NO)
        {
            [dataQueue inDatabase:^(FMDatabase *db) {
                if([db open])
                {
                    [db close];
                    MLOG(@"table create success");
                }
                
            }];
        }
        
        [dataQueue close];
    }
    return self;
}

- (void)createAreasTable
{
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlCreateAreasTable = [NSString stringWithFormat:@"create table areas_table('areaId','name','level','parent','TypeName')"];
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
            if(aFirstchar)
            {
                NSString *sel = @"select * from areas_table where areaId=?";
                FMResultSet *cityResultset = [db executeQuery:sel,aAreaId];
                if(!cityResultset)
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
                NSString *sqlSELcity = @"select 市 from areas_table where firstchar=?";
                NSMutableArray *mutArry = [[NSMutableArray alloc] init];
                FMResultSet *cityResultset = [db executeQuery:sqlSELcity,indexchar];
                if(!cityResultset)
                {
                    aCityBlock(nil);
                    break;
                }
                while([cityResultset next])
                {
                    HubAreasModel *model = [weakself parseFMResultToHubAreasModel:cityResultset];
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
            NSString *sqlSELcity = @"select 省 from areas_table";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity];
            while([cityResultset next])
            {
                HubAreasModel *model = [weakself parseFMResultToHubAreasModel:cityResultset];
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
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from areas_table where parent=?";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity,aParent];
            while([cityResultset next])
            {
                HubAreasModel *model = [weakself parseFMResultToHubAreasModel:cityResultset];
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
    __weak AreasDBManager *weakself = self;
    [dataQueue inDatabase:^(FMDatabase *db) {
        if([db open])
        {
            NSString *sqlSELcity = @"select * from areas_table where parent=?";
            NSMutableArray *mutArry = [[NSMutableArray alloc] init];
            FMResultSet *cityResultset = [db executeQuery:sqlSELcity,aParent];
            while([cityResultset next])
            {
                HubAreasModel *model = [weakself parseFMResultToHubAreasModel:cityResultset];
                if(model)
                {
                    [mutArry addObject:model];
                }
            }
            aDistrictBlock(mutArry);
        }
    }];
}

- (HubAreasModel *)parseFMResultToHubAreasModel:(FMResultSet *)aResultSet
{
    if(aResultSet)
    {
        HubAreasModel *model = [[HubAreasModel alloc] init];
        model.strAreaid = [aResultSet stringForColumn:@"areaId"];
        model.strName= [aResultSet stringForColumn:@"name"];;
        model.iLevel= [aResultSet intForColumn:@"level"];;
        model.strParent= [aResultSet stringForColumn:@"parent"];;
        model.strTypeName= [aResultSet stringForColumn:@"TypeName"];;
        model.strFirstchar= [aResultSet stringForColumn:@"firstchar"];
        return model;
    }
    return nil;
}
@end
