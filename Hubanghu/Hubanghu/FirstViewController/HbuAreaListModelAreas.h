//
//  HbuAreaListModelAreas.h
//
//  Created by   on 14/10/19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbuAreaListModelAreas : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double parent;
@property (nonatomic, assign) double level;
@property (nonatomic, assign) double areaId;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *firstchar;
@property (nonatomic, assign) int ishotcity;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
