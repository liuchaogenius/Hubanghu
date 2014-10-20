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
- (void)getOrderWithListFilterId:(int)aFilterId andSuccBlock:(void(^)(NSArray *aArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    NSString *orderListUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"filterId", nil];
    kHubRequestUrl(@"getOrderList.ashx", orderListUrl);
    [NetManager requestWith:dict url:orderListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        NSMutableArray *dataArray = [successDict objectForKey:@"data"];
        NSMutableArray *array = [NSMutableArray new];
        for (int i=0; i<dataArray.count; i++)
        {
            HbhOrderModel *model = [HbhOrderModel modelObjectWithDictionary:[dataArray objectAtIndex:i]];
            [array addObject:model];
        }
        aSuccBlock(array);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

- (void)cancelOrder:(int)aOrderID andSuccBlock:(void(^)(void))aSuccBlock and:(void(^)(void))aFailBlock
{
    NSString *cancelOrderUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",aOrderID], @"orderId",nil];
    kHubRequestUrl(@"cancelOrder.ashx", cancelOrderUrl);
    [NetManager requestWith:dict url:cancelOrderUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict){
        MLOG(@"%@", successDict);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}
@end