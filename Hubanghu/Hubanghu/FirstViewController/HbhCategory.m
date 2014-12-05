//
//  HbhCategory.m
//
//  Created by   on 14/12/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhCategory.h"


NSString *const kHbhCategoryDepth = @"depth";
NSString *const kHbhCategoryCateId = @"cateId";
NSString *const kHbhCategorySubTitle = @"subTitle";
NSString *const kHbhCategoryDescUrl = @"descUrl";
NSString *const kHbhCategoryAmountType = @"amountType";
NSString *const kHbhCategoryTitle = @"title";
NSString *const kHbhCategoryImageUrl = @"imageUrl";
NSString *const kHbhCategoryChild = @"child";
NSString *const kHbhCategoryMountType = @"mountType";
NSString *const kHbhCategoryDesc = @"desc";
NSString *const kHbhCategoryMountDefault = @"mountDefualt";


@interface HbhCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhCategory

@synthesize depth = _depth;
@synthesize cateId = _cateId;
@synthesize subTitle = _subTitle;
@synthesize descUrl = _descUrl;
@synthesize amountType = _amountType;
@synthesize title = _title;
@synthesize imageUrl = _imageUrl;
@synthesize child = _child;
@synthesize mountType = _mountType;
@synthesize desc = _desc;
@synthesize mountDefault = _mountDefault;


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
            self.depth = [[self objectOrNilForKey:kHbhCategoryDepth fromDictionary:dict] intValue];
            self.cateId = [[self objectOrNilForKey:kHbhCategoryCateId fromDictionary:dict] intValue];
            self.subTitle = [self objectOrNilForKey:kHbhCategorySubTitle fromDictionary:dict];
            self.descUrl = [self objectOrNilForKey:kHbhCategoryDescUrl fromDictionary:dict];
            self.amountType = [self objectOrNilForKey:kHbhCategoryAmountType fromDictionary:dict];
            self.title = [self objectOrNilForKey:kHbhCategoryTitle fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kHbhCategoryImageUrl fromDictionary:dict];
    NSArray *receivedHbhChild = [dict objectForKey:kHbhCategoryChild];

    self.child = [NSArray arrayWithArray:receivedHbhChild];
            self.mountType = [self objectOrNilForKey:kHbhCategoryMountType fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kHbhCategoryDesc fromDictionary:dict];
        self.mountDefault = [self objectOrNilForKey:kHbhCategoryMountDefault fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.depth] forKey:kHbhCategoryDepth];
    [mutableDict setValue:[NSNumber numberWithInt:self.cateId] forKey:kHbhCategoryCateId];
    [mutableDict setValue:self.subTitle forKey:kHbhCategorySubTitle];
    [mutableDict setValue:self.descUrl forKey:kHbhCategoryDescUrl];
    [mutableDict setValue:self.amountType forKey:kHbhCategoryAmountType];
    [mutableDict setValue:self.title forKey:kHbhCategoryTitle];
    [mutableDict setValue:self.imageUrl forKey:kHbhCategoryImageUrl];
    [mutableDict setValue:self.child forKey:kHbhCategoryChild];
    [mutableDict setValue:self.mountType forKey:kHbhCategoryMountType];
    [mutableDict setValue:self.desc forKey:kHbhCategoryDesc];
    [mutableDict setValue:self.mountDefault forKey:kHbhCategoryMountDefault];

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

    self.depth = [aDecoder decodeIntForKey:kHbhCategoryDepth];
    self.cateId = [aDecoder decodeIntForKey:kHbhCategoryCateId];
    self.subTitle = [aDecoder decodeObjectForKey:kHbhCategorySubTitle];
    self.descUrl = [aDecoder decodeObjectForKey:kHbhCategoryDescUrl];
    self.amountType = [aDecoder decodeObjectForKey:kHbhCategoryAmountType];
    self.title = [aDecoder decodeObjectForKey:kHbhCategoryTitle];
    self.imageUrl = [aDecoder decodeObjectForKey:kHbhCategoryImageUrl];
    self.child = [aDecoder decodeObjectForKey:kHbhCategoryChild];
    self.mountType = [aDecoder decodeObjectForKey:kHbhCategoryMountType];
    self.desc = [aDecoder decodeObjectForKey:kHbhCategoryDesc];
    self.mountDefault = [aDecoder decodeObjectForKey:kHbhCategoryMountDefault];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_depth forKey:kHbhCategoryDepth];
    [aCoder encodeInt:_cateId forKey:kHbhCategoryCateId];
    [aCoder encodeObject:_subTitle forKey:kHbhCategorySubTitle];
    [aCoder encodeObject:_descUrl forKey:kHbhCategoryDescUrl];
    [aCoder encodeObject:_amountType forKey:kHbhCategoryAmountType];
    [aCoder encodeObject:_title forKey:kHbhCategoryTitle];
    [aCoder encodeObject:_imageUrl forKey:kHbhCategoryImageUrl];
    [aCoder encodeObject:_child forKey:kHbhCategoryChild];
    [aCoder encodeObject:_mountType forKey:kHbhCategoryMountType];
    [aCoder encodeObject:_desc forKey:kHbhCategoryDesc];
    [aCoder encodeObject:_mountDefault forKey:kHbhCategoryMountDefault];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhCategory *copy = [[HbhCategory alloc] init];
    
    if (copy) {

        copy.depth = self.depth;
        copy.cateId = self.cateId;
        copy.subTitle = [self.subTitle copyWithZone:zone];
        copy.descUrl = [self.descUrl copyWithZone:zone];
        copy.amountType = [self.amountType copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
        copy.child = [self.child copyWithZone:zone];
        copy.mountType = [self.mountType copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.mountDefault = [self.mountDefault copyWithZone:zone];
    }
    
    return copy;
}


@end
