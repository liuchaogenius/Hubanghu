//
//  HbhWorkerDetailManage.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhWorkerDetailManage.h"
#import "NetManager.h"

@implementation HbhWorkerDetailManage

- (void)getWorkerDetailWithWorkerId:(int)aWorkerId SuccBlock:(void(^)(HbhWorkerData *aData))aSuccBlock and:(void(^)(void))aFailBlock
{
    NSString *workerDetailUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",aWorkerId],@"getWorkerDetail.ashx", nil];
    kHubRequestUrl(@"getWorkerDetail.ashx", workerDetailUrl);
    [NetManager requestWith:dict url:workerDetailUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        
        HbhWorkerModel *model = [HbhWorkerModel modelObjectWithDictionary:successDict];
        aSuccBlock(model.data);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}
@end
