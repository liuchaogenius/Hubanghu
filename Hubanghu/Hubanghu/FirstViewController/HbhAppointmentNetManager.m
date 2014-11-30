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
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "DataSigner.h"
#import "JSONKit.h"

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
    cateId = cateId?cateId:@"0";
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
                succ:(void(^)(NSString *sigAlipayInfo))succ
             failure:(void(^)(NSError *error))failure
{
    if(aOrder == nil || aPrice==nil || aOrderId == nil)
    {
        return;
    }
    NSString *url = nil;
    kHubRequestUrl(@"getAlipaysigned.ashx", url);
    AlixPayOrder *aliOrder = [[AlixPayOrder alloc] init];
    aliOrder.partner = kAlipayPartnerId;
    aliOrder.seller = kAlipaySellerAcount;
    aliOrder.tradeNO = aOrderId;
    aliOrder.productName = aTitle; //商品标题
    aliOrder.productDescription = aDisc; //商品描述
    float fprice = [aPrice floatValue];
    aliOrder.amount = [NSString stringWithFormat:@"%.2f",fprice]; //商品价格
    NSString *notifyUrl = nil;
    kHubRequestUrl(@"TaobaoNotify_URL.ashx", notifyUrl);
    aliOrder.notifyURL =  notifyUrl; //回调URL;
    NSString *returnUrl = notifyUrl;
    aliOrder.returnUrl = returnUrl;
    NSString *strAliOrer = [aliOrder description];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [NetManager setRequestHeadValue:request];
        NSData *reqData = [strAliOrer dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:reqData];
        NSError *error = nil;
        NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(error)
        {
            MLOG(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *strResult = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            MLOG(@"%@",strResult);
            NSDictionary *dict = [strResult objectFromJSONString];
            if(dict)
            {
                NSDictionary *dataDict = [dict objectForKey:@"data"];
                if([[dataDict objectForKey:@"result"] intValue] == 1)
                {
                    NSString *sigInfo = [dataDict objectForKey:@"rsaSigned"];
                    MLOG(@"sigInfo:%@",sigInfo);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self aliPayOrder:strAliOrer sigInfo:sigInfo];
                    });
                }
            }

        }
    });
  /////////////////
    
//    [NetManager requestWith:dict url:url method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
//        MLOG(@"succes = %@", successDict);
//        NSDictionary *dict = [successDict objectForKey:@"data"];
//        if(dict)
//        {
//            if([[dict objectForKey:@"result"] intValue] == 1)
//            {
//                NSString *sigInfo = [dict objectForKey:@"rsaSigned"];
//                [self aliPayOrder:strAliOrer sigInfo:sigInfo];
//            }
//        }
//    } failure:^(NSDictionary *failDict, NSError *error) {
//        MLOG(@"succes = %@", failDict);
//    }];
}

- (void)aliPayOrder:(NSString *)orderInfo sigInfo:(NSString *)sigInfo
{
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, sigInfo, @"RSA"];
    NSString *strSchem = @"com.hubanghu.hu8hu";
    MLOG(@"alipaystring= %@", orderString);
    [AlixLibService payOrder:orderString AndScheme:strSchem seletor:@selector(aliPayResult:) target:self];
}


- (void)aliPayResult:(NSString*)resultid
{
    MLOG(@"alipayresut");
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayOrderResultMessage object:resultid];
}
@end
