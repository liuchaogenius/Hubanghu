//
//  HbhAppointmentNetManager.m
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhAppointmentNetManager.h"
#import "NetManager.h"
#import "HubOrder.h"
@implementation HbhAppointmentNetManager

- (void)commitOrderWith:(HubOrder *)order succ:(void (^)(NSDictionary *))succ failure:(void (^)())failure{
	NSString *url;
	kHubRequestUrl(@"commitOrder.ashx", url);
	NSDictionary *dic = [order dictionaryRepresentation];
	[NetManager requestWith:dic url:url method:@"POST" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
		succ(successDict);
	} failure:^(NSDictionary *failDict, NSError *error) {
		failure();
	}];
	
}


- (void)getOrderWith:(NSString *)orderId succ:(void (^)(HubOrder *))succ failure:(void (^)())failure{
	NSString *url;
	kHubRequestUrl(@"getOrder.ashx", url);
	[NetManager requestWith:@{@"orderId":orderId} url:url method:@"POST" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
		HubOrder *order = [HubOrder modelObjectWithDictionary:successDict[@"data"]];
		succ(order);
	} failure:^(NSDictionary *failDict, NSError *error) {
		failure();
	}];
}

- (void)getAppointmentInfoWith:(NSString*)cateId succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure{
	NSString *url;
	kHubRequestUrl(@"getApointmentInfo.ashx", url);
	[NetManager requestWith:@{@"cateId":@([cateId integerValue])} url:url method:@"POST" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
		succ(successDict[@"data"]);
	} failure:^(NSDictionary *failDict, NSError *error) {
		failure();
	}];
}

- (void)getAPpointmentPriceWith:(NSDictionary*)dic succ:(void(^)(NSString *price))succ{
	NSString *url;
	kHubRequestUrl(@"getApointmentPrice.ashx", url);
	[NetManager requestWith:dic url:url method:@"POST" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
		NSDictionary *dic = [successDict objectForKey:@"data"];
		succ(dic[@"price"]);
	} failure:^(NSDictionary *failDict, NSError *error) {
		
	}];
}
@end
