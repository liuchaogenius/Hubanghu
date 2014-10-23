//
//  HbhAppointmentNetManager.h
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HubOrder;
@interface HbhAppointmentNetManager : NSObject

- (void)commitOrderWith:(HubOrder *)order succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure;

//通过orderID获取order的信息
- (void)getOrderWith:(NSString *)orderId succ:(void(^)(HubOrder* order))succ failure:(void(^)())failure;

- (void)getAppointmentInfoWith:(NSString*)cateId succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure;
- (void)getAPpointmentPriceWith:(NSDictionary*)dic succ:(void(^)(NSString *price))succ;
@end
