//
//  HubOrder.h
//
//  Created by qf  on 14/10/21
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HubOrder : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double workerId;
@property (nonatomic, assign) double areaId;
@property (nonatomic, assign) double phone;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *workerName;
@property (nonatomic, assign) double time;
@property (nonatomic, assign) double mountType;
@property (nonatomic, assign) double urgent;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) double cateId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
