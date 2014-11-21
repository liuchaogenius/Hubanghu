//
//  HbhOrderDetailViewController.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HbhOrderModel.h"

@interface HbhOrderDetailViewController : BaseViewController

- (instancetype)initWithOrderStatus:(HbhOrderModel *)aModel;

@end
