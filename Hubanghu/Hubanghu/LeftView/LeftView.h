//
//  LeftView.h
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) int selectItem;
@property(nonatomic, strong) UITableView *leftTableView;
@end
