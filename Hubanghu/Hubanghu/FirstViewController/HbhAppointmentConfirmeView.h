//
//  HbhAppointmentConfirmeView.h
//  Hubanghu
//
//  Created by qf on 14/10/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbhAppointmentConfirmeView : UIView

@property (nonatomic,assign) double price;
@property (nonatomic,strong) UIButton *pickWorkerBt;
@property (nonatomic,strong) UIButton *confirmeButton;
- (instancetype)initWithType:(NSInteger)style;
@end
