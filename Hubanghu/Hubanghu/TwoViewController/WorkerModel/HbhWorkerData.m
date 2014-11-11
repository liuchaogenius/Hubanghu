//
//  HbhWorkerData.m
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerData.h"
#import "HbhWorkerCaseClass.h"
#import "HbhWorkerComment.h"


NSString *const kHbhWorkerDataId = @"id";
NSString *const kHbhWorkerDataCertificationDesc = @"certificationDesc";
NSString *const kHbhWorkerDataCase = @"case";
NSString *const kHbhWorkerDataWorkTypeName = @"workTypeName";
NSString *const kHbhWorkerDataSuccCaseDesc = @"succCaseDesc";
NSString *const kHbhWorkerDataComment = @"comment";
NSString *const kHbhWorkerDataAttitude = @"attitude";
NSString *const kHbhWorkerDataDesc = @"desc";
NSString *const kHbhWorkerDataOrderCount = @"orderCount";
NSString *const kHbhWorkerDataSatisfaction = @"satisfaction";
NSString *const kHbhWorkerDataPhotoUrl = @"photoUrl";
NSString *const kHbhWorkerDataName = @"name";
NSString *const kHbhWorkerDataWorkingAge = @"workingAge";


@interface HbhWorkerData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize certificationDesc = _certificationDesc;
@synthesize caseProperty = _caseProperty;
@synthesize workTypeName = _workTypeName;
@synthesize succCaseDesc = _succCaseDesc;
@synthesize comment = _comment;
@synthesize attitude = _attitude;
@synthesize desc = _desc;
@synthesize orderCount = _orderCount;
@synthesize satisfaction = _satisfaction;
@synthesize photoUrl = _photoUrl;
@synthesize name = _name;
@synthesize workingAge = _workingAge;


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
            self.dataIdentifier = [[self objectOrNilForKey:kHbhWorkerDataId fromDictionary:dict] doubleValue];
            self.certificationDesc = [self objectOrNilForKey:kHbhWorkerDataCertificationDesc fromDictionary:dict];
    NSObject *receivedHbhWorkerCaseClass = [dict objectForKey:kHbhWorkerDataCase];
    NSMutableArray *parsedHbhWorkerCaseClass = [NSMutableArray array];
    if ([receivedHbhWorkerCaseClass isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhWorkerCaseClass) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhWorkerCaseClass addObject:[HbhWorkerCaseClass modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhWorkerCaseClass isKindOfClass:[NSDictionary class]]) {
       [parsedHbhWorkerCaseClass addObject:[HbhWorkerCaseClass modelObjectWithDictionary:(NSDictionary *)receivedHbhWorkerCaseClass]];
    }

    self.caseProperty = [NSArray arrayWithArray:parsedHbhWorkerCaseClass];
            self.workTypeName = [self objectOrNilForKey:kHbhWorkerDataWorkTypeName fromDictionary:dict];
            self.succCaseDesc = [self objectOrNilForKey:kHbhWorkerDataSuccCaseDesc fromDictionary:dict];
    NSObject *receivedHbhWorkerComment = [dict objectForKey:kHbhWorkerDataComment];
    NSMutableArray *parsedHbhWorkerComment = [NSMutableArray array];
    if ([receivedHbhWorkerComment isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhWorkerComment) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhWorkerComment addObject:[HbhWorkerComment modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhWorkerComment isKindOfClass:[NSDictionary class]]) {
       [parsedHbhWorkerComment addObject:[HbhWorkerComment modelObjectWithDictionary:(NSDictionary *)receivedHbhWorkerComment]];
    }

    self.comment = [NSArray arrayWithArray:parsedHbhWorkerComment];
            self.attitude = [[self objectOrNilForKey:kHbhWorkerDataAttitude fromDictionary:dict] doubleValue];
            self.desc = [self objectOrNilForKey:kHbhWorkerDataDesc fromDictionary:dict];
            int iOrderCount = [[self objectOrNilForKey:kHbhWorkerDataOrderCount fromDictionary:dict] intValue];
            self.orderCount = [NSString stringWithFormat:@"%d",iOrderCount];
            self.satisfaction = [[self objectOrNilForKey:kHbhWorkerDataSatisfaction fromDictionary:dict] doubleValue];
            self.photoUrl = [self objectOrNilForKey:kHbhWorkerDataPhotoUrl fromDictionary:dict];
            self.name = [self objectOrNilForKey:kHbhWorkerDataName fromDictionary:dict];
            self.workingAge = [self objectOrNilForKey:kHbhWorkerDataWorkingAge fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kHbhWorkerDataId];
    [mutableDict setValue:self.certificationDesc forKey:kHbhWorkerDataCertificationDesc];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCaseProperty] forKey:kHbhWorkerDataCase];
    [mutableDict setValue:self.workTypeName forKey:kHbhWorkerDataWorkTypeName];
    [mutableDict setValue:self.succCaseDesc forKey:kHbhWorkerDataSuccCaseDesc];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForComment] forKey:kHbhWorkerDataComment];
    [mutableDict setValue:[NSNumber numberWithDouble:self.attitude] forKey:kHbhWorkerDataAttitude];
    [mutableDict setValue:self.desc forKey:kHbhWorkerDataDesc];
    [mutableDict setValue:self.orderCount forKey:kHbhWorkerDataOrderCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.satisfaction] forKey:kHbhWorkerDataSatisfaction];
    [mutableDict setValue:self.photoUrl forKey:kHbhWorkerDataPhotoUrl];
    [mutableDict setValue:self.name forKey:kHbhWorkerDataName];
    [mutableDict setValue:self.workingAge forKey:kHbhWorkerDataWorkingAge];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kHbhWorkerDataId];
    self.certificationDesc = [aDecoder decodeObjectForKey:kHbhWorkerDataCertificationDesc];
    self.caseProperty = [aDecoder decodeObjectForKey:kHbhWorkerDataCase];
    self.workTypeName = [aDecoder decodeObjectForKey:kHbhWorkerDataWorkTypeName];
    self.succCaseDesc = [aDecoder decodeObjectForKey:kHbhWorkerDataSuccCaseDesc];
    self.comment = [aDecoder decodeObjectForKey:kHbhWorkerDataComment];
    self.attitude = [aDecoder decodeDoubleForKey:kHbhWorkerDataAttitude];
    self.desc = [aDecoder decodeObjectForKey:kHbhWorkerDataDesc];
    self.orderCount = [aDecoder decodeObjectForKey:kHbhWorkerDataOrderCount];
    self.satisfaction = [aDecoder decodeDoubleForKey:kHbhWorkerDataSatisfaction];
    self.photoUrl = [aDecoder decodeObjectForKey:kHbhWorkerDataPhotoUrl];
    self.name = [aDecoder decodeObjectForKey:kHbhWorkerDataName];
    self.workingAge = [aDecoder decodeObjectForKey:kHbhWorkerDataWorkingAge];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kHbhWorkerDataId];
    [aCoder encodeObject:_certificationDesc forKey:kHbhWorkerDataCertificationDesc];
    [aCoder encodeObject:_caseProperty forKey:kHbhWorkerDataCase];
    [aCoder encodeObject:_workTypeName forKey:kHbhWorkerDataWorkTypeName];
    [aCoder encodeObject:_succCaseDesc forKey:kHbhWorkerDataSuccCaseDesc];
    [aCoder encodeObject:_comment forKey:kHbhWorkerDataComment];
    [aCoder encodeDouble:_attitude forKey:kHbhWorkerDataAttitude];
    [aCoder encodeObject:_desc forKey:kHbhWorkerDataDesc];
    [aCoder encodeObject:_orderCount forKey:kHbhWorkerDataOrderCount];
    [aCoder encodeDouble:_satisfaction forKey:kHbhWorkerDataSatisfaction];
    [aCoder encodeObject:_photoUrl forKey:kHbhWorkerDataPhotoUrl];
    [aCoder encodeObject:_name forKey:kHbhWorkerDataName];
    [aCoder encodeObject:_workingAge forKey:kHbhWorkerDataWorkingAge];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerData *copy = [[HbhWorkerData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.certificationDesc = [self.certificationDesc copyWithZone:zone];
        copy.caseProperty = [self.caseProperty copyWithZone:zone];
        copy.workTypeName = [self.workTypeName copyWithZone:zone];
        copy.succCaseDesc = [self.succCaseDesc copyWithZone:zone];
        copy.comment = [self.comment copyWithZone:zone];
        copy.attitude = self.attitude;
        copy.desc = [self.desc copyWithZone:zone];
        copy.orderCount = [self.orderCount copyWithZone:zone];
        copy.satisfaction = self.satisfaction;
        copy.photoUrl = [self.photoUrl copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.workingAge = [self.workingAge copyWithZone:zone];
    }
    
    return copy;
}


@end
