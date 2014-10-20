//
//  HbhWorkerListManage.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerListManage.h"
#import "NetManager.h"

NSString *areaId;
NSString *workTypeId;
NSString *orderCountId;
@implementation HbhWorkerListManage

- (void)getWorkerListWithAreaId:(int)aAreaId andWorkerTypeId:(int)aWorkTypeid andOrderCountId:(int)aOrderId SuccBlock:(void(^)(HbhData *aData))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    NSString *workerListUrl = nil;
    if ((aAreaId != [areaId intValue])&&aAreaId!=-1) {
        areaId = [NSString stringWithFormat:@"%d", aAreaId];
    }
    if ((aWorkTypeid != [workTypeId intValue])&&aWorkTypeid!=-1) {
        workTypeId = [NSString stringWithFormat:@"%d", aWorkTypeid];
    }
    if ((aOrderId != [orderCountId intValue])&&aOrderId!=-1) {
        orderCountId = [NSString stringWithFormat:@"%d", aOrderId];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:areaId,@"area",workTypeId,@"workerType",orderCountId,@"orderCount", nil];
    kHubRequestUrl(@"getWorkerList.ashx", workerListUrl);
    [NetManager requestWith:dict url:workerListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        HbhData *data = [HbhData modelObjectWithDictionary:[successDict objectForKey:@"data"]];
        aSuccBlock(data);
    } failure:^(NSDictionary *failDict, NSError *error) {
        aFailBlock();
    }];
}


@end
