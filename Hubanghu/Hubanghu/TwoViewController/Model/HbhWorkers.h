//
//  HbhWorkers.h
//
//  Created by  C陈政旭 on 14/10/20
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhWorkers : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double workersIdentifier;
@property (nonatomic, strong) NSString *workTypeName;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, assign) double orderCount;
@property (nonatomic, strong) NSArray *caseProperty;
@property (nonatomic, strong) NSString *workingAge;
@property (nonatomic, strong) NSArray *comment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
