//
//  HbhWorkerListManage.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerListManage.h"
#import "NetManager.h"

@implementation HbhWorkerListManage

- (void)getWorkerListSuccBlock:(void(^)(HbhData *aData))aSuccBlock andFailBlock:(void(^)(void))aFailBlock
{
    NSString *workerListUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"area",@"2",@"workerType",@"3",@"orderCount", nil];
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
