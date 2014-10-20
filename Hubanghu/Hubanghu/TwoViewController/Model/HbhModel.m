//
//  HbhModel.m
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhModel.h"
#import "HbhData.h"


NSString *const kHbhModelData = @"data";
NSString *const kHbhModelCode = @"code";


@interface HbhModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhModel

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
            self.data = [HbhData modelObjectWithDictionary:[dict objectForKey:kHbhModelData]];
            self.code = [self objectOrNilForKey:kHbhModelCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kHbhModelData];
    [mutableDict setValue:self.code forKey:kHbhModelCode];

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

    self.data = [aDecoder decodeObjectForKey:kHbhModelData];
    self.code = [aDecoder decodeObjectForKey:kHbhModelCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kHbhModelData];
    [aCoder encodeObject:_code forKey:kHbhModelCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhModel *copy = [[HbhModel alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
        copy.code = [self.code copyWithZone:zone];
    }
    
    return copy;
}


@end
