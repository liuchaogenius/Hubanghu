//
//  HbhWorkerComment.h
//
//  Created by  C陈政旭 on 14/10/17
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhWorkerComment : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *worker;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double time;
@property (nonatomic, assign) double commentIdentifier;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *cate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
