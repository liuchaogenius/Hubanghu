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

@end

@interface HubAppointUserInfoView : UIView

@property(nonatomic) id<appointUserInfoDelegate> delegate;

- (BOOL)infoCheck;

- (NSString *)getUserName;
- (NSString *)getTime;
- (NSString *)getPhone;
- (NSString *)getAreaId;
- (NSString *)getLocation;

@end
