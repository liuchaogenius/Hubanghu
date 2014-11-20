//
//  HbhOrderDetailViewController.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HbhOrderModel.h"

@protocol OrderDetailVCDelegaet <NSObject>

- (void)anyPayedSuccess;

@end

@interface HbhOrderDetailViewController : BaseViewController

@property (weak, nonatomic) id<OrderDetailVCDelegaet> orderDelegaet;

- (instancetype)initWithOrderStatus:(HbhOrderModel *)aModel;

@end
