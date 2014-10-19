//
//  HbhWorkerTypes.h
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhWorkerTypes : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double value;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
