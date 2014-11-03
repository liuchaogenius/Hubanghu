//
//  HbhWorkerCommentModel.h
//
//  Created by  C陈政旭 on 14/11/3
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HbhWorkerCommentModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *comment;
@property (nonatomic, assign) double totalCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
