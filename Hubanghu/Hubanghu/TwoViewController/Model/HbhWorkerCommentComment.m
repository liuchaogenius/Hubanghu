//
//  HbhWorkerCommentComment.m
//
//  Created by  C陈政旭 on 14/11/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerCommentComment.h"


NSString *const kHbhWorkerCommentCommentWorker = @"worker";
NSString *const kHbhWorkerCommentCommentContent = @"content";
NSString *const kHbhWorkerCommentCommentTime = @"time";
NSString *const kHbhWorkerCommentCommentId = @"id";
NSString *const kHbhWorkerCommentCommentUsername = @"username";
NSString *const kHbhWorkerCommentCommentPhotoUrl = @"photoUrl";
NSString *const kHbhWorkerCommentCommentCate = @"cate";


@interface HbhWorkerCommentComment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerCommentComment

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
            self.worker = [self objectOrNilForKey:kHbhWorkerCommentCommentWorker fromDictionary:dict];
            self.content = [self objectOrNilForKey:kHbhWorkerCommentCommentContent fromDictionary:dict];
            self.time = [[self objectOrNilForKey:kHbhWorkerCommentCommentTime fromDictionary:dict] doubleValue];
            self.commentIdentifier = [[self objectOrNilForKey:kHbhWorkerCommentCommentId fromDictionary:dict] doubleValue];
            self.username = [self objectOrNilForKey:kHbhWorkerCommentCommentUsername fromDictionary:dict];
            self.photoUrl = [self objectOrNilForKey:kHbhWorkerCommentCommentPhotoUrl fromDictionary:dict];
            self.cate = [self objectOrNilForKey:kHbhWorkerCommentCommentCate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.worker forKey:kHbhWorkerCommentCommentWorker];
    [mutableDict setValue:self.content forKey:kHbhWorkerCommentCommentContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kHbhWorkerCommentCommentTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentIdentifier] forKey:kHbhWorkerCommentCommentId];
    [mutableDict setValue:self.username forKey:kHbhWorkerCommentCommentUsername];
    [mutableDict setValue:self.photoUrl forKey:kHbhWorkerCommentCommentPhotoUrl];
    [mutableDict setValue:self.cate forKey:kHbhWorkerCommentCommentCate];

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

    self.worker = [aDecoder decodeObjectForKey:kHbhWorkerCommentCommentWorker];
    self.content = [aDecoder decodeObjectForKey:kHbhWorkerCommentCommentContent];
    self.time = [aDecoder decodeDoubleForKey:kHbhWorkerCommentCommentTime];
    self.commentIdentifier = [aDecoder decodeDoubleForKey:kHbhWorkerCommentCommentId];
    self.username = [aDecoder decodeObjectForKey:kHbhWorkerCommentCommentUsername];
    self.photoUrl = [aDecoder decodeObjectForKey:kHbhWorkerCommentCommentPhotoUrl];
    self.cate = [aDecoder decodeObjectForKey:kHbhWorkerCommentCommentCate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_worker forKey:kHbhWorkerCommentCommentWorker];
    [aCoder encodeObject:_content forKey:kHbhWorkerCommentCommentContent];
    [aCoder encodeDouble:_time forKey:kHbhWorkerCommentCommentTime];
    [aCoder encodeDouble:_commentIdentifier forKey:kHbhWorkerCommentCommentId];
    [aCoder encodeObject:_username forKey:kHbhWorkerCommentCommentUsername];
    [aCoder encodeObject:_photoUrl forKey:kHbhWorkerCommentCommentPhotoUrl];
    [aCoder encodeObject:_cate forKey:kHbhWorkerCommentCommentCate];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerCommentComment *copy = [[HbhWorkerCommentComment alloc] init];
    
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
