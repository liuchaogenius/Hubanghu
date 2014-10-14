//
//  HbhOrderModel.h
//
//  Created by  C陈政旭 on 14-10-13
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhOrderModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double status;
@property (nonatomic, strong) NSString *workerName;
@property (nonatomic, assign) BOOL urgent;
@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) double mountType;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
