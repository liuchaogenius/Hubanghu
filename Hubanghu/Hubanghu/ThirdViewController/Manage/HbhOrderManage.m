//
//  HbhOrderManage.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderManage.h"
#import "HbhOrderModel.h"
#import "NetManager.h"

@implementation HbhOrderManage
- (void)getOrderListSuccBlock:(void(^)(NSArray *aArray))aSuccBlock and:(void(^)(void))aFailBlock
{
    NSString *orderListUrl = @"http://114.215.207.196/ApiService/getOrderList.ashx";
    [NetManager requestWith:nil url:orderListUrl method:@"POST" operationKey:nil parameEncoding:AFFormURLParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}
@end