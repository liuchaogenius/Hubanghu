//
//  HbhBanners.h
//
//  Created by   on 14/11/26
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhBanners : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double bannerSort;
@property (nonatomic, strong) NSString *bannerText;
@property (nonatomic, assign) double bannerId;
@property (nonatomic, strong) NSString *bannerImg;
@property (nonatomic, strong) NSString *bannerHref;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
