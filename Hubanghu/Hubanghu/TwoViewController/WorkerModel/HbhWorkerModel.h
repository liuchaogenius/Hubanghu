//
//  HbhWorkerModel.h
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HbhWorkerData;

@interface HbhWorkerModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) HbhWorkerData *data;
@property (nonatomic, strong) NSString *code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
