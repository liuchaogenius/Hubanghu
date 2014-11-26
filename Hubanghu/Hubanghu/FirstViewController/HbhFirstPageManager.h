//
//  HbhFirstPageManager.h
//  Hubanghu
//
//  Created by yato_kami on 14/11/26.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HbhFirstPageManager : NSObject

- (void)getBannersWithSucc:(void(^)(NSMutableArray* succArray))succ failure:(void(^)())failure;

@end
