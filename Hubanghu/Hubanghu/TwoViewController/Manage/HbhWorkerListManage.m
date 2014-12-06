//
//  HbhWorkerListManage.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerListManage.h"
#import "NetManager.h"

int pageCount;
int pageindex;
int totalCount;
NSString *areaId;
NSString *workTypeId;
NSString *orderCountId;
@implementation HbhWorkerListManage

- (void)getWorkerListWithAreaId:(int)aAreaId andWorkerTypeId:(int)aWorkTypeid andOrderCountId:(int)aOrderId SuccBlock:(void(^)(HbhData *aData))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    pageindex = 1;
    pageCount = 20;
    NSString *workerListUrl = nil;
    if (aAreaId!=-1) {
        areaId = [NSString stringWithFormat:@"%d", aAreaId];
    }
    if (aWorkTypeid!=-1) {
        workTypeId = [NSString stringWithFormat:@"%d", aWorkTypeid];
    }
    if (aOrderId!=-1) {
        orderCountId = [NSString stringWithFormat:@"%d", aOrderId];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:areaId,@"area",workTypeId,@"workerType",orderCountId,@"orderCount", [NSString stringWithFormat:@"%d", pageindex],@"pageIndex",[NSString stringWithFormat:@"%d", pageCount],@"pageSize", nil];
    kHubRequestUrl(@"getWorkerList.ashx", workerListUrl);
    [NetManager requestWith:dict url:workerListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        HbhData *data = [HbhData modelObjectWithDictionary:[successDict objectForKey:@"data"]];
        totalCount = data.totalCount;
        aSuccBlock(data);
    } failure:^(NSDictionary *failDict, NSError *error) {
        aFailBlock();
    }];
}

- (void)getNextPageWorerListSuccBlock:(void(^)(HbhData *aData))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    if (pageindex*pageCount<totalCount)
    {
        pageindex++;
        NSString *workerListUrl = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:areaId,@"area",workTypeId,@"workerType",orderCountId,@"orderCount", [NSString stringWithFormat:@"%d", pageindex],@"pageIndex",[NSString stringWithFormat:@"%d", pageCount],@"pageSize", nil];
        kHubRequestUrl(@"getWorkerList.ashx", workerListUrl);
        [NetManager requestWith:dict url:workerListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
            MLOG(@"%@", successDict);
            HbhData *data = [HbhData modelObjectWithDictionary:[successDict objectForKey:@"data"]];
            aSuccBlock(data);
        } failure:^(NSDictionary *failDict, NSError *error) {
            aFailBlock();
        }];

    }
}


@end
