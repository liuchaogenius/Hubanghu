//
//  HubOrder.m
//
//  Created by qf  on 14/10/21
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HubOrder.h"


NSString *const kHubOrderWorkerId = @"workerId";
NSString *const kHubOrderAreaId = @"areaId";
NSString *const kHubOrderPhone = @"phone";
NSString *const kHubOrderAmount = @"amount";
NSString *const kHubOrderWorkerName = @"workerName";
NSString *const kHubOrderTime = @"time";
NSString *const kHubOrderMountType = @"mountType";
NSString *const kHubOrderUrgent = @"urgent";
NSString *const kHubOrderComment = @"comment";
NSString *const kHubOrderPrice = @"price";
NSString *const kHubOrderLocation = @"location";
NSString *const kHubOrderCateId = @"cateId";
NSString *const kHubOrderUsername = @"username";
NSString *const kHubOrderName = @"name";


@interface HubOrder ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HubOrder

@synthesize workerId = _workerId;
@synthesize areaId = _areaId;
@synthesize phone = _phone;
@synthesize amount = _amount;
@synthesize workerName = _workerName;
@synthesize time = _time;
@synthesize mountType = _mountType;
@synthesize urgent = _urgent;
@synthesize comment = _comment;
@synthesize price = _price;
@synthesize location = _location;
@synthesize cateId = _cateId;
@synthesize username = _username;
@synthesize name = _name;


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
            self.workerId = [[self objectOrNilForKey:kHubOrderWorkerId fromDictionary:dict] doubleValue];
            self.areaId = [[self objectOrNilForKey:kHubOrderAreaId fromDictionary:dict] doubleValue];
            self.phone = [[self objectOrNilForKey:kHubOrderPhone fromDictionary:dict] doubleValue];
            self.amount = [[self objectOrNilForKey:kHubOrderAmount fromDictionary:dict] doubleValue];
            self.workerName = [self objectOrNilForKey:kHubOrderWorkerName fromDictionary:dict];
            self.time = [[self objectOrNilForKey:kHubOrderTime fromDictionary:dict] doubleValue];
            self.mountType = [[self objectOrNilForKey:kHubOrderMountType fromDictionary:dict] doubleValue];
            self.urgent = [[self objectOrNilForKey:kHubOrderUrgent fromDictionary:dict] doubleValue];
            self.comment = [self objectOrNilForKey:kHubOrderComment fromDictionary:dict];
            self.price = [[self objectOrNilForKey:kHubOrderPrice fromDictionary:dict] doubleValue];
            self.location = [self objectOrNilForKey:kHubOrderLocation fromDictionary:dict];
            self.cateId = [[self objectOrNilForKey:kHubOrderCateId fromDictionary:dict] doubleValue];
            self.username = [self objectOrNilForKey:kHubOrderUsername fromDictionary:dict];
            self.name = [self objectOrNilForKey:kHubOrderName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.workerId] forKey:kHubOrderWorkerId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.areaId] forKey:kHubOrderAreaId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.phone] forKey:kHubOrderPhone];
    [mutableDict setValue:[NSNumber numberWithDouble:self.amount] forKey:kHubOrderAmount];
    [mutableDict setValue:self.workerName forKey:kHubOrderWorkerName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kHubOrderTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mountType] forKey:kHubOrderMountType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.urgent] forKey:kHubOrderUrgent];
    [mutableDict setValue:self.comment forKey:kHubOrderComment];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kHubOrderPrice];
    [mutableDict setValue:self.location forKey:kHubOrderLocation];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cateId] forKey:kHubOrderCateId];
    [mutableDict setValue:self.username forKey:kHubOrderUsername];
    [mutableDict setValue:self.name forKey:kHubOrderName];

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

    self.workerId = [aDecoder decodeDoubleForKey:kHubOrderWorkerId];
    self.areaId = [aDecoder decodeDoubleForKey:kHubOrderAreaId];
    self.phone = [aDecoder decodeDoubleForKey:kHubOrderPhone];
    self.amount = [aDecoder decodeDoubleForKey:kHubOrderAmount];
    self.workerName = [aDecoder decodeObjectForKey:kHubOrderWorkerName];
    self.time = [aDecoder decodeDoubleForKey:kHubOrderTime];
    self.mountType = [aDecoder decodeDoubleForKey:kHubOrderMountType];
    self.urgent = [aDecoder decodeDoubleForKey:kHubOrderUrgent];
    self.comment = [aDecoder decodeObjectForKey:kHubOrderComment];
    self.price = [aDecoder decodeDoubleForKey:kHubOrderPrice];
    self.location = [aDecoder decodeObjectForKey:kHubOrderLocation];
    self.cateId = [aDecoder decodeDoubleForKey:kHubOrderCateId];
    self.username = [aDecoder decodeObjectForKey:kHubOrderUsername];
    self.name = [aDecoder decodeObjectForKey:kHubOrderName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_workerId forKey:kHubOrderWorkerId];
    [aCoder encodeDouble:_areaId forKey:kHubOrderAreaId];
    [aCoder encodeDouble:_phone forKey:kHubOrderPhone];
    [aCoder encodeDouble:_amount forKey:kHubOrderAmount];
    [aCoder encodeObject:_workerName forKey:kHubOrderWorkerName];
	[aCoder encodeDouble:_time forKey:kHubOrderTime];
    [aCoder encodeDouble:_mountType forKey:kHubOrderMountType];
    [aCoder encodeDouble:_urgent forKey:kHubOrderUrgent];
    [aCoder encodeObject:_comment forKey:kHubOrderComment];
    [aCoder encodeDouble:_price forKey:kHubOrderPrice];
    [aCoder encodeObject:_location forKey:kHubOrderLocation];
    [aCoder encodeDouble:_cateId forKey:kHubOrderCateId];
    [aCoder encodeObject:_username forKey:kHubOrderUsername];
    [aCoder encodeObject:_name forKey:kHubOrderName];
}

- (id)copyWithZone:(NSZone *)zone
{
    HubOrder *copy = [[HubOrder alloc] init];
    
    if (copy) {

        copy.workerId = self.workerId;
        copy.areaId = self.areaId;
        copy.phone = self.phone;
        copy.amount = self.amount;
        copy.workerName = [self.workerName copyWithZone:zone];
        copy.time = self.time;
        copy.mountType = self.mountType;
        copy.urgent = self.urgent;
        copy.comment = [self.comment copyWithZone:zone];
        copy.price = self.price;
        copy.location = [self.location copyWithZone:zone];
        copy.cateId = self.cateId;
        copy.username = [self.username copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
