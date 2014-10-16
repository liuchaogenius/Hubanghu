//
//  HbhDropDownView.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhDropDownView.h"

@implementation HbhDropDownView

- (instancetype)initWithArray:(NSArray *)aArray andButton:(UIView *)aBtn
{
    self = [super init];
    
    cellHeight = 30;
    tableArray = aArray;
    if (aBtn.bottom+cellHeight*aArray.count>[UIScreen mainScreen].bounds.size.height)
    {
        tableHeight = [UIScreen mainScreen].bounds.size.height - aBtn.bottom;
    }
    else
    {
        tableHeight = cellHeight*aArray.count;
    }
    self.frame = CGRectMake(aBtn.left, aBtn.bottom, aBtn.right-aBtn.left, tableHeight);
    self.showItemTableView = [[UITableView alloc]
                              initWithFrame:self.bounds];
    self.showItemTableView.delegate = self;
    self.showItemTableView.dataSource = self;
    self.showItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.showItemTableView];
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = RGBCOLOR(242, 242, 242);
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    cell.textLabel.font = kFont15;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = RGBCOLOR(122, 122, 122);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, cell.frame.size.width, 1)];
    lineView.backgroundColor = RGBCOLOR(196, 196, 196);
    [cell addSubview:lineView];
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cellHeight)];
    leftLineView.backgroundColor = RGBCOLOR(196, 196, 196);
    [cell addSubview:leftLineView];
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3-1, 0, 1, cellHeight)];
    rightLineView.backgroundColor = RGBCOLOR(196, 196, 196);
    [cell addSubview:rightLineView];
    return cell;
}
@end
