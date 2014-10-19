//
//  HbuAreaListModelBaseClass.h
//
//  Created by   on 14/10/19
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbuAreaListModelBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, assign) double time;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
