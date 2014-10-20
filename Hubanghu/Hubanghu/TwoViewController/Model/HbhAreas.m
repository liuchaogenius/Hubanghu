//
//  HbhAreas.m
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhAreas.h"


NSString *const kHbhAreasName = @"name";
NSString *const kHbhAreasId = @"id";
NSString *const kHbhAreasSelected = @"selected";


@interface HbhAreas ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhAreas

@synthesize name = _name;
@synthesize areasIdentifier = _areasIdentifier;
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
            self.name = [self objectOrNilForKey:kHbhAreasName fromDictionary:dict];
            self.areasIdentifier = [[self objectOrNilForKey:kHbhAreasId fromDictionary:dict] doubleValue];
            self.selected = [[self objectOrNilForKey:kHbhAreasSelected fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kHbhAreasName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areasIdentifier] forKey:kHbhAreasId];
    [mutableDict setValue:[NSNumber numberWithBool:self.selected] forKey:kHbhAreasSelected];

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

    self.name = [aDecoder decodeObjectForKey:kHbhAreasName];
    self.areasIdentifier = [aDecoder decodeDoubleForKey:kHbhAreasId];
    self.selected = [aDecoder decodeBoolForKey:kHbhAreasSelected];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kHbhAreasName];
    [aCoder encodeDouble:_areasIdentifier forKey:kHbhAreasId];
    [aCoder encodeBool:_selected forKey:kHbhAreasSelected];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhAreas *copy = [[HbhAreas alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.areasIdentifier = self.areasIdentifier;
        copy.selected = self.selected;
    }
    
    return copy;
}


@end
