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
}
@property(nonatomic, strong) void(^ myBlock)(int);
@property(nonatomic, strong) UITableView *showItemTableView;
@property(nonatomic, strong) NSArray *tableArray;
- (instancetype)initWithArray:(NSArray *)aArray andButton:(UIView *)aBtn;
- (void)useBlock:(void(^)(int row))aBlock;
- (void)reloadTableView;
@end
