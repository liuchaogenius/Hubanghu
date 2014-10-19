//
//  HbuAreaListModelAreas.m
//
//  Created by   on 14/10/19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbuAreaListModelAreas.h"


NSString *const kHbuAreaListModelAreasName = @"name";
NSString *const kHbuAreaListModelAreasParent = @"parent";
NSString *const kHbuAreaListModelAreasLevel = @"level";
NSString *const kHbuAreaListModelAreasAreaId = @"areaId";
NSString *const kHbuAreaListModelAreasTypeName = @"TypeName";
NSString *const kHbuAreaListModelAreasFirstchar = @"firstchar";


@interface HbuAreaListModelAreas ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbuAreaListModelAreas

@synthesize name = _name;
@synthesize parent = _parent;
@synthesize level = _level;
@synthesize areaId = _areaId;
@synthesize typeName = _typeName;
@synthesize firstchar = _firstchar;


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
            self.name = [self objectOrNilForKey:kHbuAreaListModelAreasName fromDictionary:dict];
            self.parent = [[self objectOrNilForKey:kHbuAreaListModelAreasParent fromDictionary:dict] doubleValue];
            self.level = [[self objectOrNilForKey:kHbuAreaListModelAreasLevel fromDictionary:dict] doubleValue];
            self.areaId = [[self objectOrNilForKey:kHbuAreaListModelAreasAreaId fromDictionary:dict] doubleValue];
            self.typeName = [self objectOrNilForKey:kHbuAreaListModelAreasTypeName fromDictionary:dict];
            self.firstchar = [self objectOrNilForKey:kHbuAreaListModelAreasFirstchar fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kHbuAreaListModelAreasName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.parent] forKey:kHbuAreaListModelAreasParent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.level] forKey:kHbuAreaListModelAreasLevel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areaId] forKey:kHbuAreaListModelAreasAreaId];
    [mutableDict setValue:self.typeName forKey:kHbuAreaListModelAreasTypeName];
    [mutableDict setValue:self.firstchar forKey:kHbuAreaListModelAreasFirstchar];

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

    self.name = [aDecoder decodeObjectForKey:kHbuAreaListModelAreasName];
    self.parent = [aDecoder decodeDoubleForKey:kHbuAreaListModelAreasParent];
    self.level = [aDecoder decodeDoubleForKey:kHbuAreaListModelAreasLevel];
    self.areaId = [aDecoder decodeDoubleForKey:kHbuAreaListModelAreasAreaId];
    self.typeName = [aDecoder decodeObjectForKey:kHbuAreaListModelAreasTypeName];
    self.firstchar = [aDecoder decodeObjectForKey:kHbuAreaListModelAreasFirstchar];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kHbuAreaListModelAreasName];
    [aCoder encodeDouble:_parent forKey:kHbuAreaListModelAreasParent];
    [aCoder encodeDouble:_level forKey:kHbuAreaListModelAreasLevel];
    [aCoder encodeDouble:_areaId forKey:kHbuAreaListModelAreasAreaId];
    [aCoder encodeObject:_typeName forKey:kHbuAreaListModelAreasTypeName];
    [aCoder encodeObject:_firstchar forKey:kHbuAreaListModelAreasFirstchar];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbuAreaListModelAreas *copy = [[HbuAreaListModelAreas alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.parent = self.parent;
        copy.level = self.level;
        copy.areaId = self.areaId;
        copy.typeName = [self.typeName copyWithZone:zone];
        copy.firstchar = [self.firstchar copyWithZone:zone];
    }
    
    return copy;
}


@end
