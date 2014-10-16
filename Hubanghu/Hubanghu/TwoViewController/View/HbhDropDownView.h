//
//  HbhDropDownView.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbhDropDownView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat cellHeight;
    CGFloat tableHeight;
    NSArray *tableArray;
}

@property(nonatomic, strong) UITableView *showItemTableView;
- (instancetype)initWithArray:(NSArray *)aArray andButton:(UIView *)aBtn;
@end
