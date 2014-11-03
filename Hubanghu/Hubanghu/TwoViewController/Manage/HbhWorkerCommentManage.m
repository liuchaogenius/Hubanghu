//
//  HbhWorkerCommentManage.m
//  Hubanghu
//
//  Created by Johnny's on 14/11/3.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerCommentManage.h"
#import "NetManager.h"

int pageCount;
int pageindex;
int totalCount;
NSString *workerId;
@implementation HbhWorkerCommentManage

- (void)getWorkerListWithWorkerId:(int)aWorkerId SuccBlock:(void (^)(NSArray *))aSuccBlock andFailBlock:(void (^)(void))aFailBlock
{
    pageCount = 20;
    pageindex = 1;
    workerId = [NSString stringWithFormat:@"%d", aWorkerId];
    NSString *workerCommentListUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:workerId, @"workerId", [NSString stringWithFormat:@"%d", pageindex],@"pageIndex",[NSString stringWithFormat:@"%d", pageCount],@"pageSize", nil];
    kHubRequestUrl(@"getWorkerComment.aspx", workerCommentListUrl);
    [NetManager requestWith:dict url:workerCommentListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        HbhWorkerCommentModel *model = [HbhWorkerCommentModel modelObjectWithDictionary:successDict];
        totalCount = model.totalCount;
        aSuccBlock(model.comment);
    } failure:^(NSDictionary *failDict, NSError *error) {
        aFailBlock();
    }];
}

- (void)getNextWorkerListSuccBlock:(void (^)(NSArray *))aSuccBlock andFailBlock:(void (^)(void))aFailBlock
{
    if (pageindex*pageCount<totalCount)
    {
        pageindex++;
        NSString *workerCommentListUrl = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:workerId, @"workerId", [NSString stringWithFormat:@"%d", pageindex],@"pageIndex",[NSString stringWithFormat:@"%d", pageCount],@"pageSize", nil];
        kHubRequestUrl(@"getWorkerComment.aspx", workerCommentListUrl);
        [NetManager requestWith:dict url:workerCommentListUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
            MLOG(@"%@", successDict);
            HbhWorkerCommentModel *model = [HbhWorkerCommentModel modelObjectWithDictionary:successDict];
            totalCount = model.totalCount;
            aSuccBlock(model.comment);
        } failure:^(NSDictionary *failDict, NSError *error) {
            aFailBlock();
        }];
    }
}

@end
