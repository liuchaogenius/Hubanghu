//
//  HbhBanners.m
//
//  Created by   on 14/11/26
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HbhBanners.h"


NSString *const kHbhBannersBannerSort = @"BannerSort";
NSString *const kHbhBannersBannerText = @"BannerText";
NSString *const kHbhBannersBannerId = @"BannerId";
NSString *const kHbhBannersBannerImg = @"BannerImg";
NSString *const kHbhBannersBannerHref = @"BannerHref";


@interface HbhBanners ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation HbhBanners

@synthesize bannerSort = _bannerSort;
@synthesize bannerText = _bannerText;
@synthesize bannerId = _bannerId;
@synthesize bannerImg = _bannerImg;
@synthesize bannerHref = _bannerHref;


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
            self.bannerSort = [[self objectOrNilForKey:kHbhBannersBannerSort fromDictionary:dict] doubleValue];
            self.bannerText = [self objectOrNilForKey:kHbhBannersBannerText fromDictionary:dict];
            self.bannerId = [[self objectOrNilForKey:kHbhBannersBannerId fromDictionary:dict] doubleValue];
            self.bannerImg = [self objectOrNilForKey:kHbhBannersBannerImg fromDictionary:dict];
            self.bannerHref = [self objectOrNilForKey:kHbhBannersBannerHref fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bannerSort] forKey:kHbhBannersBannerSort];
    [mutableDict setValue:self.bannerText forKey:kHbhBannersBannerText];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bannerId] forKey:kHbhBannersBannerId];
    [mutableDict setValue:self.bannerImg forKey:kHbhBannersBannerImg];
    [mutableDict setValue:self.bannerHref forKey:kHbhBannersBannerHref];

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

    self.bannerSort = [aDecoder decodeDoubleForKey:kHbhBannersBannerSort];
    self.bannerText = [aDecoder decodeObjectForKey:kHbhBannersBannerText];
    self.bannerId = [aDecoder decodeDoubleForKey:kHbhBannersBannerId];
    self.bannerImg = [aDecoder decodeObjectForKey:kHbhBannersBannerImg];
    self.bannerHref = [aDecoder decodeObjectForKey:kHbhBannersBannerHref];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_bannerSort forKey:kHbhBannersBannerSort];
    [aCoder encodeObject:_bannerText forKey:kHbhBannersBannerText];
    [aCoder encodeDouble:_bannerId forKey:kHbhBannersBannerId];
    [aCoder encodeObject:_bannerImg forKey:kHbhBannersBannerImg];
    [aCoder encodeObject:_bannerHref forKey:kHbhBannersBannerHref];
}

- (id)copyWithZone:(NSZone *)zone
{
    HbhBanners *copy = [[HbhBanners alloc] init];
    
    if (copy) {

        copy.bannerSort = self.bannerSort;
        copy.bannerText = [self.bannerText copyWithZone:zone];
        copy.bannerId = self.bannerId;
        copy.bannerImg = [self.bannerImg copyWithZone:zone];
        copy.bannerHref = [self.bannerHref copyWithZone:zone];
    }
    
    return copy;
}


@end
