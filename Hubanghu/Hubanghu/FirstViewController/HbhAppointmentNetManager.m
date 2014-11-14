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
	[NetManager requestWith:dic url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
		succ(successDict);
	} failure:^(NSDictionary *failDict, NSError *error) {
		failure();
	}];
	
}


- (void)getOrderWith:(NSString *)orderId succ:(void (^)(HubOrder *))succ failure:(void (^)())failure{
	NSString *url;
	kHubRequestUrl(@"getOrder.ashx", url);
    [NetManager requestWith:@{@"orderId":(orderId ? orderId : @"")} url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
		HubOrder *order = [HubOrder modelObjectWithDictionary:successDict[@"data"]];
		succ(order);
	} failure:^(NSDictionary *failDict, NSError *error) {
		failure();
	}];
}

- (void)getAppointmentInfoWith:(NSString*)cateId succ:(void(^)(NSDictionary* succDic))succ failure:(void(^)())failure{
	NSString *url;
    NSString *akey = @"appPrice";
    [NetManager cancelOperation:akey];
	kHubRequestUrl(@"getApointmentInfo.ashx", url);
    NSString *strCataid = [NSString stringWithFormat:@"%d",[cateId intValue]];
    [NetManager requestWith:@{@"cateId":(strCataid ? strCataid : @"")} url:url method:@"POST" operationKey:akey parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSDictionary *data = successDict[@"data"];
        if (data) {
            succ(data);
        }else failure();
	} failure:^(NSDictionary *failDict, NSError *error) {
		failure();
	}];
}


- (void)getAppointmentPriceWithCateId:(NSString *)cateId type:(int)type amountType:(int)amountType amount:(NSString *)amount urgent:(BOOL)urgent succ:(void(^)(NSString *price))succ failure:(void(^)())failure
{
    cateId = cateId?:@"0";
    NSString *strCateid = [NSString stringWithFormat:@"%d",[cateId intValue]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:(strCateid ? strCateid : @""),@"cateId",[NSNumber numberWithInt:type],@"type",(amount ? amount : @""),@"amount",[NSNumber numberWithInt:urgent],@"urgent", nil];
    NSString *url;
    kHubRequestUrl(@"getApointmentPrice.ashx", url);
    [NetManager requestWith:dic url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSDictionary *dic = [successDict objectForKey:@"data"];
        succ(dic[@"price"]);
    } failure:^(NSDictionary *failDict, NSError *error) {
        failure();
        MLOG(@"%@",error.localizedDescription);
    }];
}


- (void)aliPaySigned:(HubOrder *)aOrder
             orderId:(NSString *)aOrderId
         productDesx:(NSString *)aDisc
               title:(NSString *)aTitle
               price:(NSString *)aPrice
{
    NSString *url = nil;
    kHubRequestUrl(@"getAlipaysigned.ashx", url);
    AlixPayOrder *aliOrder = [[AlixPayOrder alloc] init];
    aliOrder.partner = @"2088311602278363";
    aliOrder.seller =@"hu8hu888@sina.com";
    aliOrder.tradeNO = aOrderId;
    aliOrder.productName = aTitle; //商品标题
    aliOrder.productDescription = aDisc; //商品描述
    aliOrder.amount = aPrice; //商品价格
    aliOrder.notifyURL =  @"http%3A%2F%2Fwwww.xxx.com"; //回调URL;
    NSString *strAliOrer = [aliOrder description];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strAliOrer,@"rsaSigned", nil];
    [NetManager requestWith:dict url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"succes = %@", successDict);
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"succes = %@", failDict);
    }];
}
@end
