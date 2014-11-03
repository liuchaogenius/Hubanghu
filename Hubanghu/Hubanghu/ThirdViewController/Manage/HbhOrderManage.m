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

int pageCount;
int pageIndex;
int filterId;
int totalCount;
@implementation HbhOrderManage
- (void)getOrderWithListFilterId:(int)aFilterId andSuccBlock:(void(^)(NSArray *aArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    pageIndex=1;
    pageCount=20;
    filterId=aFilterId;
    NSString *orderListUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", filterId],@"filterId", [NSString stringWithFormat:@"%d", pageCount], @"pageCount",[NSString stringWithFormat:@"%d", pageIndex], @"pageIndex",nil];
    kHubRequestUrl(@"getOrderList.ashx", orderListUrl);
    [NetManager requestWith:dict url:orderListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        totalCount = [[successDict objectForKey:@"totalCount"] intValue];
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

- (void)getNextOrderListSuccBlock:(void(^)(NSArray *aArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    if (pageIndex*pageCount<totalCount) {
        pageIndex++;
        NSString *orderListUrl = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", filterId],@"filterId", [NSString stringWithFormat:@"%d", pageCount], @"pageCount",[NSString stringWithFormat:@"%d", pageIndex], @"pageIndex",nil];
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
}
@end