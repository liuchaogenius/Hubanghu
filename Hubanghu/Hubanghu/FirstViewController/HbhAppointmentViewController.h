//
//  HbhAppointmentViewController.h
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HbhAppointmentDetailsTableViewCell.h"
@class HbhWorkers;
@interface HbhAppointmentViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HbhAppointmentDelegate>
- (instancetype)initWithTitle:(NSString *)title cateId:(NSString *)cateId andWork:(HbhWorkers *)worker;
@end
