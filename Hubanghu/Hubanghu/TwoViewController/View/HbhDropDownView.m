//
//  HbhDropDownView.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhDropDownView.h"
#import "HbhDataModels.h"

@implementation HbhDropDownView

- (void)useBlock:(void(^)(int row))aBlock
{
    self.myBlock = aBlock;
}


- (instancetype)initWithArray:(NSArray *)aArray andButton:(UIView *)aBtn
{
    self = [super init];
    
    cellHeight = 42;
    _tableArray = aArray;
    if (cellHeight*aArray.count>42*6)
    {
        tableHeight = 42*6;
    }
    else
    {
        tableHeight = cellHeight*aArray.count;
    }
    self.frame = CGRectMake(aBtn.left, aBtn.bottom, aBtn.right-aBtn.left, tableHeight);
    self.showItemTableView = [[UITableView alloc]
                              initWithFrame:self.bounds];
    if (kSystemVersion>=7) {
        self.showItemTableView.backgroundColor = [UIColor clearColor];
    }
    self.showItemTableView.bounces = NO;
    self.showItemTableView.delegate = self;
    self.showItemTableView.dataSource = self;
    self.showItemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.showItemTableView];
    return self;
}

- (void)reloadTableView
{
    if (cellHeight*self.tableArray.count>42*6)
    {
        tableHeight = 42*6;
    }
    else
    {
        tableHeight = cellHeight*self.tableArray.count;
    }
    CGRect temFrame = self.frame;
    temFrame.size.height = tableHeight;
    self.frame = temFrame;
    self.showItemTableView.frame = self.bounds;
    [self.showItemTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = RGBCOLOR(242, 242, 242);
    HbhAreas *model = [_tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = kFont15;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = RGBCOLOR(122, 122, 122);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42-1, cell.frame.size.width, 1)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.myBlock((int)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
