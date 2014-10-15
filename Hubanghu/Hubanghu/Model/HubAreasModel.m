//
//  HubAreasModel.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HubAreasModel.h"

@implementation HubAreasModel

- (instancetype)init
{
    if(self=[super init])
    {
    }
    return self;
}

- (void)unPacketAreasData:(NSDictionary *)aDict
{
    AssignMentID(self.strAreaid, [aDict objectForKey:@"areaId"]);
    AssignMentID(self.strName, [aDict objectForKey:@"name"]);
    AssignMentID(self.strParent, [aDict objectForKey:@"parent"]);
    AssignMentID(self.strTypeName, [aDict objectForKey:@"TypeName"]);
    AssignMentNSNumber(self.iLevel, [aDict objectForKey:@"level"]);
    AssignMentID(self.strFirstchar, [aDict objectForKey:@"firstchar"]);
}
@end
