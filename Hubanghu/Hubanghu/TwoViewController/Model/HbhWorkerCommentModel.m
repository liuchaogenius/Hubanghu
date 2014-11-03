//
//  HbhWorkerCommentModel.m
//
//  Created by  C陈政旭 on 14/11/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhWorkerCommentModel.h"
#import "HbhWorkerCommentComment.h"


NSString *const kHbhWorkerCommentModelComment = @"comment";
NSString *const kHbhWorkerCommentModelTotalCount = @"totalCount";


@interface HbhWorkerCommentModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhWorkerCommentModel

@synthesize comment = _comment;
@synthesize totalCount = _totalCount;


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
    NSObject *receivedHbhWorkerCommentComment = [dict objectForKey:kHbhWorkerCommentModelComment];
    NSMutableArray *parsedHbhWorkerCommentComment = [NSMutableArray array];
    if ([receivedHbhWorkerCommentComment isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedHbhWorkerCommentComment) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedHbhWorkerCommentComment addObject:[HbhWorkerCommentComment modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedHbhWorkerCommentComment isKindOfClass:[NSDictionary class]]) {
       [parsedHbhWorkerCommentComment addObject:[HbhWorkerCommentComment modelObjectWithDictionary:(NSDictionary *)receivedHbhWorkerCommentComment]];
    }

    self.comment = [NSArray arrayWithArray:parsedHbhWorkerCommentComment];
            self.totalCount = [[self objectOrNilForKey:kHbhWorkerCommentModelTotalCount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForComment] forKey:kHbhWorkerCommentModelComment];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalCount] forKey:kHbhWorkerCommentModelTotalCount];

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

    self.comment = [aDecoder decodeObjectForKey:kHbhWorkerCommentModelComment];
    self.totalCount = [aDecoder decodeDoubleForKey:kHbhWorkerCommentModelTotalCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_comment forKey:kHbhWorkerCommentModelComment];
    [aCoder encodeDouble:_totalCount forKey:kHbhWorkerCommentModelTotalCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhWorkerCommentModel *copy = [[HbhWorkerCommentModel alloc] init];
    
    if (copy) {

        copy.comment = [self.comment copyWithZone:zone];
        copy.totalCount = self.totalCount;
    }
    
    return copy;
}


@end
