//
//  HbhModel.h
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HbhData;

@interface HbhModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) HbhData *data;
@property (nonatomic, strong) NSString *code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
