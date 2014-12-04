//
//  CategoryInfoModel.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfoModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *child;
@property (nonatomic, assign) int cateId;
@property (nonatomic, assign) int depth;

@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIImageView *imageUrl;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *descUrl;
@property (nonatomic, strong) NSString *mountType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
