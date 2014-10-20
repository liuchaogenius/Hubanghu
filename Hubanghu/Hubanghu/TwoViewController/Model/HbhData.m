//
//  HbhData.m
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhData.h"
#import "HbhWorkerTypes.h"
#import "HbhWorkers.h"
#import "HbhAreas.h"
#import "HbhOrderCounts.h"


NSString *const kHbhDataWorkerTypes = @"workerTypes";
NSString *const kHbhDataWorkers = @"workers";
NSString *const kHbhDataAreas = @"areas";
NSString *const kHbhDataOrderCounts = @"orderCounts";


@interface HbhData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhData

@synthesize workerTypes = _workerTypes;
@synthesize workers = _workers;
@synthesize areas = _areas;
@synthesize orderCounts = _orderCounts;


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
    NSObject *receivedHbhWorkerTypes = [dict objectForKey:kHbhDataWorkerTypes];
    NSMutableArray *parsedHbhWorkerTypes = [NSMutableArray array];
    if ([receivedHbhWorkerTypes isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhWorkerTypes) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhWorkerTypes addObject:[HbhWorkerTypes modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhWorkerTypes isKindOfClass:[NSDictionary class]]) {
       [parsedHbhWorkerTypes addObject:[HbhWorkerTypes modelObjectWithDictionary:(NSDictionary *)receivedHbhWorkerTypes]];
    }

    self.workerTypes = [NSArray arrayWithArray:parsedHbhWorkerTypes];
    NSObject *receivedHbhWorkers = [dict objectForKey:kHbhDataWorkers];
    NSMutableArray *parsedHbhWorkers = [NSMutableArray array];
    if ([receivedHbhWorkers isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhWorkers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhWorkers addObject:[HbhWorkers modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhWorkers isKindOfClass:[NSDictionary class]]) {
       [parsedHbhWorkers addObject:[HbhWorkers modelObjectWithDictionary:(NSDictionary *)receivedHbhWorkers]];
    }

    self.workers = [NSArray arrayWithArray:parsedHbhWorkers];
    NSObject *receivedHbhAreas = [dict objectForKey:kHbhDataAreas];
    NSMutableArray *parsedHbhAreas = [NSMutableArray array];
    if ([receivedHbhAreas isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhAreas) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhAreas addObject:[HbhAreas modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhAreas isKindOfClass:[NSDictionary class]]) {
       [parsedHbhAreas addObject:[HbhAreas modelObjectWithDictionary:(NSDictionary *)receivedHbhAreas]];
    }

    self.areas = [NSArray arrayWithArray:parsedHbhAreas];
    NSObject *receivedHbhOrderCounts = [dict objectForKey:kHbhDataOrderCounts];
    NSMutableArray *parsedHbhOrderCounts = [NSMutableArray array];
    if ([receivedHbhOrderCounts isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhOrderCounts) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhOrderCounts addObject:[HbhOrderCounts modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhOrderCounts isKindOfClass:[NSDictionary class]]) {
       [parsedHbhOrderCounts addObject:[HbhOrderCounts modelObjectWithDictionary:(NSDictionary *)receivedHbhOrderCounts]];
    }

    self.orderCounts = [NSArray arrayWithArray:parsedHbhOrderCounts];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForWorkerTypes = [NSMutableArray array];
    for (NSObject *subArrayObject in self.workerTypes) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWorkerTypes addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWorkerTypes addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWorkerTypes] forKey:kHbhDataWorkerTypes];
    NSMutableArray *tempArrayForWorkers = [NSMutableArray array];
    for (NSObject *subArrayObject in self.workers) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWorkers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWorkers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWorkers] forKey:kHbhDataWorkers];
    NSMutableArray *tempArrayForAreas = [NSMutableArray array];
    for (NSObject *subArrayObject in self.areas) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAreas addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAreas addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAreas] forKey:kHbhDataAreas];
    NSMutableArray *tempArrayForOrderCounts = [NSMutableArray array];
    for (NSObject *subArrayObject in self.orderCounts) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForOrderCounts addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForOrderCounts addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOrderCounts] forKey:kHbhDataOrderCounts];

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

    self.workerTypes = [aDecoder decodeObjectForKey:kHbhDataWorkerTypes];
    self.workers = [aDecoder decodeObjectForKey:kHbhDataWorkers];
    self.areas = [aDecoder decodeObjectForKey:kHbhDataAreas];
    self.orderCounts = [aDecoder decodeObjectForKey:kHbhDataOrderCounts];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_workerTypes forKey:kHbhDataWorkerTypes];
    [aCoder encodeObject:_workers forKey:kHbhDataWorkers];
    [aCoder encodeObject:_areas forKey:kHbhDataAreas];
    [aCoder encodeObject:_orderCounts forKey:kHbhDataOrderCounts];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhData *copy = [[HbhData alloc] init];
    
    if (copy) {

        copy.workerTypes = [self.workerTypes copyWithZone:zone];
        copy.workers = [self.workers copyWithZone:zone];
        copy.areas = [self.areas copyWithZone:zone];
        copy.orderCounts = [self.orderCounts copyWithZone:zone];
    }
    
    return copy;
}


@end
