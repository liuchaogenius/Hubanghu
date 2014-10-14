//
//  HbhOrderManage.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HbhOrderManage : NSObject

- (void)getOrderListSuccBlock:(void(^)(NSArray *aArray))aSuccBlock and:(void(^)(void))aFailBlock;
@end
