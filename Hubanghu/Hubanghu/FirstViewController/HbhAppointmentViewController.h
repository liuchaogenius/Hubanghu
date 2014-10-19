//
//  HbhAppointmentViewController.h
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HbhAppointmentDetailsTableViewCell.h"
typedef NS_ENUM(NSInteger, HbhAppointmentStyle) {
	HbhAppointmentStyleNoWorker,
	HbhAppointmentStyleHaveWorker
};

@interface HbhAppointmentViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HbhAppointmentDelegate>
@property (nonatomic,assign) HbhAppointmentStyle style;
- (instancetype)initWithTitle:(NSString *)title cateId:(NSString *)cateId andWork:(NSDictionary *)dic;
@end
