//
//  HbhWorkerData.h
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhWorkerData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *certificationDesc;
@property (nonatomic, strong) NSArray *caseProperty;
@property (nonatomic, strong) NSString *workTypeName;
@property (nonatomic, strong) NSString *succCaseDesc;
@property (nonatomic, strong) NSArray *comment;
@property (nonatomic, assign) double attitude;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) int orderCount;
@property (nonatomic, assign) double satisfaction;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *workingAge;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
