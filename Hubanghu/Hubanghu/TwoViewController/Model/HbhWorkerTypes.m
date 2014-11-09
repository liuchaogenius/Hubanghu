//
//  HbhWorkerTypes.m
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerTypes.h"


NSString *const kHbhWorkerTypesName = @"name";
NSString *const kHbhWorkerTypesId = @"id";
NSString *const kHbhWorkerTypesSelected = @"selected";


@interface HbhWorkerTypes ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerTypes

@synthesize name = _name;
@synthesize workerTypesIdentifier = _workerTypesIdentifier;
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
            self.name = [self objectOrNilForKey:kHbhWorkerTypesName fromDictionary:dict];
            self.workerTypesIdentifier = [[self objectOrNilForKey:kHbhWorkerTypesId fromDictionary:dict] intValue];
            self.selected = [[self objectOrNilForKey:kHbhWorkerTypesSelected fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kHbhWorkerTypesName];
    [mutableDict setValue:[NSNumber numberWithInt:self.workerTypesIdentifier] forKey:kHbhWorkerTypesId];
    [mutableDict setValue:[NSNumber numberWithBool:self.selected] forKey:kHbhWorkerTypesSelected];

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
    self.workerTypesIdentifier = [aDecoder decodeIntForKey:kHbhWorkerTypesId];
    self.selected = [aDecoder decodeBoolForKey:kHbhWorkerTypesSelected];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kHbhWorkerTypesName];
    [aCoder encodeInt:_workerTypesIdentifier forKey:kHbhWorkerTypesId];
    [aCoder encodeBool:_selected forKey:kHbhWorkerTypesSelected];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerTypes *copy = [[HbhWorkerTypes alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.workerTypesIdentifier = self.workerTypesIdentifier;
        copy.selected = self.selected;
    }
    
    return copy;
}


@end
