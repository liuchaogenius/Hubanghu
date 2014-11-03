//
//  HbhWorkerCommentManage.h
//  Hubanghu
//
//  Created by Johnny's on 14/11/3.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HbhDataModels.h"

@interface HbhWorkerCommentManage : NSObject


- (void)getWorkerListWithWorkerId:(int)aWorkerId SuccBlock:(void(^)(NSArray *aCommentArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock;
- (void)getNextWorkerListSuccBlock:(void(^)(NSArray *aCommentArray))aSuccBlock andFailBlock:(void(^)(void))aFailBlock;
@end
