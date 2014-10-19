//
//  HbhWorkerCaseClass.m
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerCaseClass.h"


NSString *const kHbhWorkerCaseClassId = @"id";
NSString *const kHbhWorkerCaseClassTitle = @"title";
NSString *const kHbhWorkerCaseClassImageUrl = @"imageUrl";


@interface HbhWorkerCaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerCaseClass

@synthesize caseClassIdentifier = _caseClassIdentifier;
@synthesize title = _title;
@synthesize imageUrl = _imageUrl;


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
            self.caseClassIdentifier = [[self objectOrNilForKey:kHbhWorkerCaseClassId fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kHbhWorkerCaseClassTitle fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kHbhWorkerCaseClassImageUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.caseClassIdentifier] forKey:kHbhWorkerCaseClassId];
    [mutableDict setValue:self.title forKey:kHbhWorkerCaseClassTitle];
    [mutableDict setValue:self.imageUrl forKey:kHbhWorkerCaseClassImageUrl];

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

    self.caseClassIdentifier = [aDecoder decodeDoubleForKey:kHbhWorkerCaseClassId];
    self.title = [aDecoder decodeObjectForKey:kHbhWorkerCaseClassTitle];
    self.imageUrl = [aDecoder decodeObjectForKey:kHbhWorkerCaseClassImageUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_caseClassIdentifier forKey:kHbhWorkerCaseClassId];
    [aCoder encodeObject:_title forKey:kHbhWorkerCaseClassTitle];
    [aCoder encodeObject:_imageUrl forKey:kHbhWorkerCaseClassImageUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerCaseClass *copy = [[HbhWorkerCaseClass alloc] init];
    
    if (copy) {

        copy.caseClassIdentifier = self.caseClassIdentifier;
        copy.title = [self.title copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
    }
    
    return copy;
}


@end
