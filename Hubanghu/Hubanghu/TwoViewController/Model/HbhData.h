//
//  HbhData.h
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *workerTypes;
@property (nonatomic, strong) NSArray *orderCountRegions;
@property (nonatomic, strong) NSArray *workers;
@property (nonatomic, strong) NSArray *areas;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
