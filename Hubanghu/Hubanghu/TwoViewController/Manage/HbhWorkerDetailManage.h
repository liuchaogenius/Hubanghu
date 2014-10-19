//
//  HbhWorkerDetailManage.h
//  Hubanghu
//
//  Created by Johnny's on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HbhWorkerDataModels.h"

@interface HbhWorkerDetailManage : NSObject

- (void)getWorkerDetailWithWorkerId:(int)aWorkerId SuccBlock:(void(^)(HbhWorkerData *aData))aSuccBlock and:(void(^)(void))aFailBlock;
@end
