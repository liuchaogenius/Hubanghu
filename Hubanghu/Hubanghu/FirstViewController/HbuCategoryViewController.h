//
//  HbuCategoryViewController.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "BaseViewController.h"

@interface HbuCategoryViewController : BaseViewController

@property (assign, nonatomic) double cateId;

- (instancetype)initWithCateId:(double)cateId;

@end
