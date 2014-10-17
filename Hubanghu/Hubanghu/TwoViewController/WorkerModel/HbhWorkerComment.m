//
//  HbhWorkerComment.m
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerComment.h"


NSString *const kHbhWorkerCommentWorker = @"worker";
NSString *const kHbhWorkerCommentContent = @"content";
NSString *const kHbhWorkerCommentTime = @"time";
NSString *const kHbhWorkerCommentId = @"id";
NSString *const kHbhWorkerCommentUsername = @"username";
NSString *const kHbhWorkerCommentPhotoUrl = @"photoUrl";
NSString *const kHbhWorkerCommentCate = @"cate";


@interface HbhWorkerComment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerComment

@synthesize worker = _worker;
@synthesize content = _content;
@synthesize time = _time;
@synthesize commentIdentifier = _commentIdentifier;
@synthesize username = _username;
@synthesize photoUrl = _photoUrl;
@synthesize cate = _cate;


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
            self.worker = [self objectOrNilForKey:kHbhWorkerCommentWorker fromDictionary:dict];
            self.content = [self objectOrNilForKey:kHbhWorkerCommentContent fromDictionary:dict];
            self.time = [[self objectOrNilForKey:kHbhWorkerCommentTime fromDictionary:dict] doubleValue];
            self.commentIdentifier = [[self objectOrNilForKey:kHbhWorkerCommentId fromDictionary:dict] doubleValue];
            self.username = [self objectOrNilForKey:kHbhWorkerCommentUsername fromDictionary:dict];
            self.photoUrl = [self objectOrNilForKey:kHbhWorkerCommentPhotoUrl fromDictionary:dict];
            self.cate = [self objectOrNilForKey:kHbhWorkerCommentCate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.worker forKey:kHbhWorkerCommentWorker];
    [mutableDict setValue:self.content forKey:kHbhWorkerCommentContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kHbhWorkerCommentTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentIdentifier] forKey:kHbhWorkerCommentId];
    [mutableDict setValue:self.username forKey:kHbhWorkerCommentUsername];
    [mutableDict setValue:self.photoUrl forKey:kHbhWorkerCommentPhotoUrl];
    [mutableDict setValue:self.cate forKey:kHbhWorkerCommentCate];

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

    self.worker = [aDecoder decodeObjectForKey:kHbhWorkerCommentWorker];
    self.content = [aDecoder decodeObjectForKey:kHbhWorkerCommentContent];
    self.time = [aDecoder decodeDoubleForKey:kHbhWorkerCommentTime];
    self.commentIdentifier = [aDecoder decodeDoubleForKey:kHbhWorkerCommentId];
    self.username = [aDecoder decodeObjectForKey:kHbhWorkerCommentUsername];
    self.photoUrl = [aDecoder decodeObjectForKey:kHbhWorkerCommentPhotoUrl];
    self.cate = [aDecoder decodeObjectForKey:kHbhWorkerCommentCate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_worker forKey:kHbhWorkerCommentWorker];
    [aCoder encodeObject:_content forKey:kHbhWorkerCommentContent];
    [aCoder encodeDouble:_time forKey:kHbhWorkerCommentTime];
    [aCoder encodeDouble:_commentIdentifier forKey:kHbhWorkerCommentId];
    [aCoder encodeObject:_username forKey:kHbhWorkerCommentUsername];
    [aCoder encodeObject:_photoUrl forKey:kHbhWorkerCommentPhotoUrl];
    [aCoder encodeObject:_cate forKey:kHbhWorkerCommentCate];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerComment *copy = [[HbhWorkerComment alloc] init];
    
    if (copy) {

        copy.worker = [self.worker copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.time = self.time;
        copy.commentIdentifier = self.commentIdentifier;
        copy.username = [self.username copyWithZone:zone];
        copy.photoUrl = [self.photoUrl copyWithZone:zone];
        copy.cate = [self.cate copyWithZone:zone];
    }
    
    return copy;
}


@end
