//
//  CategoryInfoModel.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "CategoryInfoModel.h"
#import "CategoryChildInfoModel.h"
NSString *const kHbhNSObjectTitle = @"title";
NSString *const kHbhNSObjectChild = @"child";
NSString *const kHbhNSObjectCateId = @"cateId";
NSString *const kHbhNSObjectDepth = @"depth";

@interface CategoryInfoModel()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CategoryInfoModel

@synthesize title = _title;
@synthesize child = _child;
@synthesize cateId = _cateId;
@synthesize depth = _depth;


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
        self.title = [self objectOrNilForKey:kHbhNSObjectTitle fromDictionary:dict];
        NSObject *receivedHbhChild = [dict objectForKey:kHbhNSObjectChild];
        NSMutableArray *parsedHbhChild = [NSMutableArray array];
        if ([receivedHbhChild isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedHbhChild) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedHbhChild addObject:[CategoryChildInfoModel modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedHbhChild isKindOfClass:[NSDictionary class]]) {
            [parsedHbhChild addObject:[CategoryChildInfoModel modelObjectWithDictionary:(NSDictionary *)receivedHbhChild]];
        }
        
        self.child = [NSArray arrayWithArray:parsedHbhChild];
        self.cateId = [[self objectOrNilForKey:kHbhNSObjectCateId fromDictionary:dict] doubleValue];
        self.depth = [[self objectOrNilForKey:kHbhNSObjectDepth fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kHbhNSObjectTitle];
    NSMutableArray *tempArrayForChild = [NSMutableArray array];
    for (NSObject *subArrayObject in self.child) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForChild addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForChild addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForChild] forKey:kHbhNSObjectChild];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cateId] forKey:kHbhNSObjectCateId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.depth] forKey:kHbhNSObjectDepth];
    
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
    
    self.title = [aDecoder decodeObjectForKey:kHbhNSObjectTitle];
    self.child = [aDecoder decodeObjectForKey:kHbhNSObjectChild];
    self.cateId = [aDecoder decodeDoubleForKey:kHbhNSObjectCateId];
    self.depth = [aDecoder decodeDoubleForKey:kHbhNSObjectDepth];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_title forKey:kHbhNSObjectTitle];
    [aCoder encodeObject:_child forKey:kHbhNSObjectChild];
    [aCoder encodeDouble:_cateId forKey:kHbhNSObjectCateId];
    [aCoder encodeDouble:_depth forKey:kHbhNSObjectDepth];
}

- (id)copyWithZone:(NSZone *)zone
{
    CategoryInfoModel *copy = [[CategoryInfoModel alloc] init];
    
    if (copy) {
        
        copy.title = [self.title copyWithZone:zone];
        copy.child = [self.child copyWithZone:zone];
        copy.cateId = self.cateId;
        copy.depth = self.depth;
    }
    
    return copy;
}


@end
