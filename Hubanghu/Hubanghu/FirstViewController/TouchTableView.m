//
//  TouchTableView.m
//  Hubanghu
//
//  Created by qf on 14/10/23.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "TouchTableView.h"


@implementation TouchTableView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
		[_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
		{
		[_touchDelegate tableView:self touchesBegan:touches withEvent:event];
		}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
		[_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
		{
		[_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
		}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
		[_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
		{
		[_touchDelegate tableView:self touchesEnded:touches withEvent:event];
		}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
		[_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
		{
		[_touchDelegate tableView:self touchesMoved:touches withEvent:event];
		}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
