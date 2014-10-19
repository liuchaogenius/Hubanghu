//
//  HbuAreaListModelBaseClass.m
//
//  Created by   on 14/10/19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbuAreaListModelBaseClass.h"
#import "HbuAreaListModelAreas.h"


NSString *const kHbuAreaListModelBaseClassAreas = @"areas";
NSString *const kHbuAreaListModelBaseClassTime = @"time";


@interface HbuAreaListModelBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbuAreaListModelBaseClass

@synthesize areas = _areas;
@synthesize time = _time;


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
    NSObject *receivedHbuAreaListModelAreas = [dict objectForKey:kHbuAreaListModelBaseClassAreas];
    NSMutableArray *parsedHbuAreaListModelAreas = [NSMutableArray array];
    if ([receivedHbuAreaListModelAreas isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbuAreaListModelAreas) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbuAreaListModelAreas addObject:[HbuAreaListModelAreas modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbuAreaListModelAreas isKindOfClass:[NSDictionary class]]) {
       [parsedHbuAreaListModelAreas addObject:[HbuAreaListModelAreas modelObjectWithDictionary:(NSDictionary *)receivedHbuAreaListModelAreas]];
    }

    self.areas = [NSArray arrayWithArray:parsedHbuAreaListModelAreas];
            self.time = [[self objectOrNilForKey:kHbuAreaListModelBaseClassTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAreas] forKey:kHbuAreaListModelBaseClassAreas];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kHbuAreaListModelBaseClassTime];

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

    self.areas = [aDecoder decodeObjectForKey:kHbuAreaListModelBaseClassAreas];
    self.time = [aDecoder decodeDoubleForKey:kHbuAreaListModelBaseClassTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_areas forKey:kHbuAreaListModelBaseClassAreas];
    [aCoder encodeDouble:_time forKey:kHbuAreaListModelBaseClassTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbuAreaListModelBaseClass *copy = [[HbuAreaListModelBaseClass alloc] init];
    
    if (copy) {

        copy.areas = [self.areas copyWithZone:zone];
        copy.time = self.time;
    }
    
    return copy;
}


@end
