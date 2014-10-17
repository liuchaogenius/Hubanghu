//
//  HbhWorkerTypes.m
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerTypes.h"


NSString *const kHbhWorkerTypesName = @"name";
NSString *const kHbhWorkerTypesValue = @"value";


@interface HbhWorkerTypes ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerTypes

@synthesize name = _name;
@synthesize value = _value;


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
            self.name = [self objectOrNilForKey:kHbhWorkerTypesName fromDictionary:dict];
            self.value = [[self objectOrNilForKey:kHbhWorkerTypesValue fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kHbhWorkerTypesName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.value] forKey:kHbhWorkerTypesValue];

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

    self.name = [aDecoder decodeObjectForKey:kHbhWorkerTypesName];
    self.value = [aDecoder decodeDoubleForKey:kHbhWorkerTypesValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kHbhWorkerTypesName];
    [aCoder encodeDouble:_value forKey:kHbhWorkerTypesValue];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerTypes *copy = [[HbhWorkerTypes alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.value = self.value;
    }
    
    return copy;
}


@end
