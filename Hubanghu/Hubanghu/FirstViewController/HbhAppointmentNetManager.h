//
//  HbhAppointmentNetManager.h
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlixPayOrder.h"


@class HubOrder;
@interface HbhAppointmentNetManager : NSObject

- (void)commitOrderWith:(HubOrder *)order succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure;

//通过orderID获取order的信息
- (void)getOrderWith:(NSString *)orderId succ:(void(^)(HubOrder* order))succ failure:(void(^)())failure;

- (void)getAppointmentInfoWith:(NSString*)cateId succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure;

- (void)getAppointmentPriceWithCateId:(NSString *)cateId type:(int)type amountType:(int)amountType amount:(NSString *)amount urgent:(BOOL)urgent succ:(void(^)(NSString *price))succ failure:(void(^)())failure;
- (void)aliPaySigned:(HubOrder *)aOrder
             orderId:(NSString *)aOrderId
         productDesx:(NSString *)aDisc
               title:(NSString *)aTitle
               price:(NSString *)aPrice
                succ:(void(^)(NSString *sigAlipayInfo))succ
             failure:(void(^)(NSError *error))failure;
@end
