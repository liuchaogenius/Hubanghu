//
//  HbhWorkerCaseClass.h
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhWorkerCaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double caseClassIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
