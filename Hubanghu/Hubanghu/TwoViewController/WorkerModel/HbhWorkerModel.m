//
//  HbhWorkerModel.m
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerModel.h"
#import "HbhWorkerData.h"


NSString *const kHbhWorkerModelData = @"data";
NSString *const kHbhWorkerModelCode = @"code";


@interface HbhWorkerModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerModel

@synthesize data = _data;
@synthesize code = _code;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.data = [HbhWorkerData modelObjectWithDictionary:[dict objectForKey:kHbhWorkerModelData]];
            self.code = [self objectOrNilForKey:kHbhWorkerModelCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHbhWorkerModelData];
    [mutableDict setValue:self.code forKey:kHbhWorkerModelCode];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.data = [aDecoder decodeObjectForKey:kHbhWorkerModelData];
    self.code = [aDecoder decodeObjectForKey:kHbhWorkerModelCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kHbhWorkerModelData];
    [aCoder encodeObject:_code forKey:kHbhWorkerModelCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerModel *copy = [[HbhWorkerModel alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
        copy.code = [self.code copyWithZone:zone];
    }
    
    return copy;
}


@end
