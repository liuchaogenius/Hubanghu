//
//  HbhWorkers.m
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkers.h"


NSString *const kHbhWorkersName = @"name";
NSString *const kHbhWorkersId = @"id";
NSString *const kHbhWorkersWorkTypeName = @"workTypeName";
NSString *const kHbhWorkersPhotoUrl = @"photoUrl";
NSString *const kHbhWorkersOrderCount = @"orderCount";
NSString *const kHbhWorkersCase = @"case";
NSString *const kHbhWorkersWorkingAge = @"workingAge";
NSString *const kHbhWorkersComment = @"comment";


@interface HbhWorkers ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkers

@synthesize name = _name;
@synthesize workersIdentifier = _workersIdentifier;
@synthesize workTypeName = _workTypeName;
@synthesize photoUrl = _photoUrl;
@synthesize orderCount = _orderCount;
@synthesize caseProperty = _caseProperty;
@synthesize workingAge = _workingAge;
@synthesize comment = _comment;


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
            self.name = [self objectOrNilForKey:kHbhWorkersName fromDictionary:dict];
            self.workersIdentifier = [[self objectOrNilForKey:kHbhWorkersId fromDictionary:dict] intValue];
            self.workTypeName = [self objectOrNilForKey:kHbhWorkersWorkTypeName fromDictionary:dict];
            self.photoUrl = [self objectOrNilForKey:kHbhWorkersPhotoUrl fromDictionary:dict];
            self.orderCount = [[self objectOrNilForKey:kHbhWorkersOrderCount fromDictionary:dict] intValue];
            self.caseProperty = [self objectOrNilForKey:kHbhWorkersCase fromDictionary:dict];
            int age = [[self objectOrNilForKey:kHbhWorkersWorkingAge fromDictionary:dict] intValue];
            self.workingAge = [NSString stringWithFormat:@"%d", age];
            self.comment = [self objectOrNilForKey:kHbhWorkersComment fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kHbhWorkersName];
    [mutableDict setValue:[NSNumber numberWithInt:self.workersIdentifier] forKey:kHbhWorkersId];
    [mutableDict setValue:self.workTypeName forKey:kHbhWorkersWorkTypeName];
    [mutableDict setValue:self.photoUrl forKey:kHbhWorkersPhotoUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.orderCount] forKey:kHbhWorkersOrderCount];
    NSMutableArray *tempArrayForCaseProperty = [NSMutableArray array];
    for (NSObject *subArrayObject in self.caseProperty) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCaseProperty addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCaseProperty addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCaseProperty] forKey:kHbhWorkersCase];
    [mutableDict setValue:self.workingAge forKey:kHbhWorkersWorkingAge];
    NSMutableArray *tempArrayForComment = [NSMutableArray array];
    for (NSObject *subArrayObject in self.comment) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForComment addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForComment addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForComment] forKey:kHbhWorkersComment];

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

    self.name = [aDecoder decodeObjectForKey:kHbhWorkersName];
    self.workersIdentifier = [aDecoder decodeIntForKey:kHbhWorkersId];
    self.workTypeName = [aDecoder decodeObjectForKey:kHbhWorkersWorkTypeName];
    self.photoUrl = [aDecoder decodeObjectForKey:kHbhWorkersPhotoUrl];
    self.orderCount = [aDecoder decodeIntForKey:kHbhWorkersOrderCount];
    self.caseProperty = [aDecoder decodeObjectForKey:kHbhWorkersCase];
    self.workingAge = [aDecoder decodeObjectForKey:kHbhWorkersWorkingAge];
    self.comment = [aDecoder decodeObjectForKey:kHbhWorkersComment];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kHbhWorkersName];
    [aCoder encodeInt:_workersIdentifier forKey:kHbhWorkersId];
    [aCoder encodeObject:_workTypeName forKey:kHbhWorkersWorkTypeName];
    [aCoder encodeObject:_photoUrl forKey:kHbhWorkersPhotoUrl];
    [aCoder encodeInt:_orderCount forKey:kHbhWorkersOrderCount];
    [aCoder encodeObject:_caseProperty forKey:kHbhWorkersCase];
    [aCoder encodeObject:_workingAge forKey:kHbhWorkersWorkingAge];
    [aCoder encodeObject:_comment forKey:kHbhWorkersComment];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkers *copy = [[HbhWorkers alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.workersIdentifier = self.workersIdentifier;
        copy.workTypeName = [self.workTypeName copyWithZone:zone];
        copy.photoUrl = [self.photoUrl copyWithZone:zone];
        copy.orderCount = self.orderCount;
        copy.caseProperty = [self.caseProperty copyWithZone:zone];
        copy.workingAge = [self.workingAge copyWithZone:zone];
        copy.comment = [self.comment copyWithZone:zone];
    }
    
    return copy;
}


@end
