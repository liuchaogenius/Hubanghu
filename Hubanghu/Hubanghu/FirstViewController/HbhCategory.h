//
//  HbhCategory.h
//
//  Created by   on 14/12/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhCategory : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) int depth;
@property (nonatomic, assign) int cateId;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *descUrl;
@property (nonatomic, strong) NSString *amountType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSArray *child;
@property (nonatomic, strong) NSString *mountType;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) int mountDefault;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
