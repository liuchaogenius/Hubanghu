//
//  SecondViewController.h
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HbhDataModels.h"

@interface SecondViewController : BaseViewController

- (instancetype)initAndUseWorkerDetailBlock:(void(^)(HbhWorkers *aWorkerModel))aBlock;
@end
