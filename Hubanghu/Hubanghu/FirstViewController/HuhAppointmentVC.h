//
//  HuhAppointmentVC.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "BaseViewController.h"
@class HbhWorkers;
@interface HuhAppointmentVC : BaseViewController

- (void)setVCData:(NSString *)title cateId:(NSString *)cateId andWork:(HbhWorkers *)worker;

- (void)setCustomedVCofRenovateWithCateId:(NSString *)cateId ;//首页进入二次翻新的定制方法

@end
