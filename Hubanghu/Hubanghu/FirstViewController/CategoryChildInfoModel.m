//
//  CategoryChildInfoModel.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "CategoryChildInfoModel.h"

NSString *const kHbhChildTitle = @"title";
NSString *const kHbhChildImageUrl = @"imageUrl";
NSString *const kHbhChildChild = @"child";
NSString *const kHbhChildCateId = @"cateId";
NSString *const kHbhChildDepth = @"depth";

@interface CategoryChildInfoModel()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CategoryChildInfoModel

@synthesize title = _title;
@synthesize imageUrl = _imageUrl;
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
        self.title = [self objectOrNilForKey:kHbhChildTitle fromDictionary:dict];
        self.imageUrl = [self objectOrNilForKey:kHbhChildImageUrl fromDictionary:dict];
        self.child = [self objectOrNilForKey:kHbhChildChild fromDictionary:dict];
        self.cateId = [[self objectOrNilForKey:kHbhChildCateId fromDictionary:dict] doubleValue];
        self.depth = [[self objectOrNilForKey:kHbhChildDepth fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kHbhChildTitle];
    [mutableDict setValue:self.imageUrl forKey:kHbhChildImageUrl];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForChild] forKey:kHbhChildChild];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cateId] forKey:kHbhChildCateId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.depth] forKey:kHbhChildDepth];
    
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
    
    self.title = [aDecoder decodeObjectForKey:kHbhChildTitle];
    self.imageUrl = [aDecoder decodeObjectForKey:kHbhChildImageUrl];
    self.child = [aDecoder decodeObjectForKey:kHbhChildChild];
    self.cateId = [aDecoder decodeDoubleForKey:kHbhChildCateId];
    self.depth = [aDecoder decodeDoubleForKey:kHbhChildDepth];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_title forKey:kHbhChildTitle];
    [aCoder encodeObject:_imageUrl forKey:kHbhChildImageUrl];
    [aCoder encodeObject:_child forKey:kHbhChildChild];
    [aCoder encodeDouble:_cateId forKey:kHbhChildCateId];
    [aCoder encodeDouble:_depth forKey:kHbhChildDepth];
}

- (id)copyWithZone:(NSZone *)zone
{
    CategoryChildInfoModel *copy = [[CategoryChildInfoModel alloc] init];
    
    if (copy) {
        
        copy.title = [self.title copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
        copy.child = [self.child copyWithZone:zone];
        copy.cateId = self.cateId;
        copy.depth = self.depth;
    }
    
    return copy;
}

@end
