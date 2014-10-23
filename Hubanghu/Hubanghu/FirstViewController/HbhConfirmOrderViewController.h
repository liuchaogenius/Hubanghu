//
//  HbhConfirmOrderViewController.h
//  Hubanghu
//
//  Created by qf on 14/10/21.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HubOrder;
@interface HbhConfirmOrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
- (instancetype)initWithOrder:(HubOrder *)order;
- (instancetype)initWithOrderId:(NSString *)orderId;
@end
