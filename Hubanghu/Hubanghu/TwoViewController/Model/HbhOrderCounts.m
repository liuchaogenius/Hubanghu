//
//  HbhOrderCounts.m
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhOrderCounts.h"


NSString *const kHbhOrderCountsName = @"name";
NSString *const kHbhOrderCountsId = @"id";
NSString *const kHbhOrderCountsSelected = @"selected";


@interface HbhOrderCounts ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhOrderCounts

@synthesize name = _name;
@synthesize orderCountsIdentifier = _orderCountsIdentifier;
@synthesize selected = _selected;


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
            self.name = [self objectOrNilForKey:kHbhOrderCountsName fromDictionary:dict];
            self.orderCountsIdentifier = [[self objectOrNilForKey:kHbhOrderCountsId fromDictionary:dict] doubleValue];
            self.selected = [[self objectOrNilForKey:kHbhOrderCountsSelected fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kHbhOrderCountsName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderCountsIdentifier] forKey:kHbhOrderCountsId];
    [mutableDict setValue:[NSNumber numberWithBool:self.selected] forKey:kHbhOrderCountsSelected];

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

    self.name = [aDecoder decodeObjectForKey:kHbhOrderCountsName];
    self.orderCountsIdentifier = [aDecoder decodeDoubleForKey:kHbhOrderCountsId];
    self.selected = [aDecoder decodeBoolForKey:kHbhOrderCountsSelected];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kHbhOrderCountsName];
    [aCoder encodeDouble:_orderCountsIdentifier forKey:kHbhOrderCountsId];
    [aCoder encodeBool:_selected forKey:kHbhOrderCountsSelected];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhOrderCounts *copy = [[HbhOrderCounts alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.orderCountsIdentifier = self.orderCountsIdentifier;
        copy.selected = self.selected;
    }
    
    return copy;
}


@end
