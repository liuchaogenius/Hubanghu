//
//  HubAppointUserInfoView.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol appointUserInfoDelegate <NSObject>

- (void)shouldResignAllFirstResponds;
- (void)shouldScrolltoPointY:(CGFloat)pointY;

@end

@interface HubAppointUserInfoView : UIView

@property(nonatomic) id<appointUserInfoDelegate> delegate;
@property(assign, nonatomic) CGFloat originY;

- (BOOL)infoCheck;

- (NSString *)getUserName;
- (NSString *)getTime;
- (NSString *)getPhone;
- (NSString *)getAreaId;
- (NSString *)getLocation;

@end
