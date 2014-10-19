//
//  HbhAppointmentNetManager.h
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HbhAppointmentNetManager : NSObject
- (void)getAppointmentInfoWith:(NSString*)cateId succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure;
- (void)getAPpointmentPriceWith:(NSDictionary*)dic succ:(void(^)(NSString *price))succ;
@end
