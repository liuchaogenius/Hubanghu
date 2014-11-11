//
//  HbhOrderModel.m
//
//  Created by  C陈政旭 on 14-10-14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhOrderModel.h"


NSString *const kHbhOrderModelStatus = @"status";
NSString *const kHbhOrderModelWorkerName = @"workerName";
NSString *const kHbhOrderModelUrgent = @"urgent";
NSString *const kHbhOrderModelId = @"id";
NSString *const kHbhOrderModelPrice = @"price";
NSString *const kHbhOrderModelTime = @"time";
NSString *const kHbhOrderModelMountType = @"mountType";
NSString *const kHbhOrderModelComment = @"comment";
NSString *const kHbhOrderModelName = @"name";


@interface HbhOrderModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhOrderModel

@synthesize orderId = _orderId;
@synthesize status = _status;
@synthesize workerName = _workerName;
@synthesize urgent = _urgent;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize price = _price;
@synthesize time = _time;
@synthesize mountType = _mountType;
@synthesize comment = _comment;
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
            self.orderId = [[self objectOrNilForKey:kHbhOrderModelId fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kHbhOrderModelStatus fromDictionary:dict] doubleValue];
            self.workerName = [self objectOrNilForKey:kHbhOrderModelWorkerName fromDictionary:dict];
            self.urgent = [[self objectOrNilForKey:kHbhOrderModelUrgent fromDictionary:dict] boolValue];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kHbhOrderModelId fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kHbhOrderModelPrice fromDictionary:dict] doubleValue];
            self.time = [[self objectOrNilForKey:kHbhOrderModelTime fromDictionary:dict] doubleValue];
            self.mountType = [[self objectOrNilForKey:kHbhOrderModelMountType fromDictionary:dict] doubleValue];
            self.comment = [self objectOrNilForKey:kHbhOrderModelComment fromDictionary:dict];
            self.name = [self objectOrNilForKey:kHbhOrderModelName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kHbhOrderModelStatus];
    [mutableDict setValue:self.workerName forKey:kHbhOrderModelWorkerName];
    [mutableDict setValue:[NSNumber numberWithBool:self.urgent] forKey:kHbhOrderModelUrgent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kHbhOrderModelId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kHbhOrderModelPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kHbhOrderModelTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.mountType] forKey:kHbhOrderModelMountType];
    [mutableDict setValue:self.comment forKey:kHbhOrderModelComment];
    [mutableDict setValue:self.name forKey:kHbhOrderModelName];

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

    self.status = [aDecoder decodeDoubleForKey:kHbhOrderModelStatus];
    self.workerName = [aDecoder decodeObjectForKey:kHbhOrderModelWorkerName];
    self.urgent = [aDecoder decodeBoolForKey:kHbhOrderModelUrgent];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kHbhOrderModelId];
    self.price = [aDecoder decodeDoubleForKey:kHbhOrderModelPrice];
    self.time = [aDecoder decodeDoubleForKey:kHbhOrderModelTime];
    self.mountType = [aDecoder decodeDoubleForKey:kHbhOrderModelMountType];
    self.comment = [aDecoder decodeObjectForKey:kHbhOrderModelComment];
    self.name = [aDecoder decodeObjectForKey:kHbhOrderModelName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_status forKey:kHbhOrderModelStatus];
    [aCoder encodeObject:_workerName forKey:kHbhOrderModelWorkerName];
    [aCoder encodeBool:_urgent forKey:kHbhOrderModelUrgent];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kHbhOrderModelId];
    [aCoder encodeDouble:_price forKey:kHbhOrderModelPrice];
    [aCoder encodeDouble:_time forKey:kHbhOrderModelTime];
    [aCoder encodeDouble:_mountType forKey:kHbhOrderModelMountType];
    [aCoder encodeObject:_comment forKey:kHbhOrderModelComment];
    [aCoder encodeObject:_name forKey:kHbhOrderModelName];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhOrderModel *copy = [[HbhOrderModel alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.workerName = [self.workerName copyWithZone:zone];
        copy.urgent = self.urgent;
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.price = self.price;
        copy.time = self.time;
        copy.mountType = self.mountType;
        copy.comment = [self.comment copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
