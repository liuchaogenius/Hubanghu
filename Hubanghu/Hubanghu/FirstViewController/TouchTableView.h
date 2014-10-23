//
//  TouchTableView.h
//  Hubanghu
//
//  Created by qf on 14/10/23.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView
	 touchesBegan:(NSSet *)touches
		withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
		withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
	 touchesEnded:(NSSet *)touches
		withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
	 touchesMoved:(NSSet *)touches
		withEvent:(UIEvent *)event;


@end

@interface TouchTableView : UITableView
@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;
@end
