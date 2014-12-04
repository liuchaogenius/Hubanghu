//
//  HuhAppointmentVC.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "BaseViewController.h"
@class HbhWorkers;
@class HbhCategory;
@interface HuhAppointmentVC : BaseViewController

//- (void)setVCData:(NSString *)title cateId:(NSString *)cateId andWork:(HbhWorkers *)worker;

- (void)setCustomedVCofDepthisZero;//进入类似二次翻新的定制方法-depth = 0时，直接进入下单

- (instancetype)initWithCateModel:(HbhCategory *)model andWorker:(HbhWorkers *)worker;

@end
