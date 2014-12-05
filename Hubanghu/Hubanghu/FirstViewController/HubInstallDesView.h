//
//  HubInstallDesView.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IDesDelegate <NSObject>
- (void)showDescUrl;
@end
@interface HubInstallDesView : UIView

@property (weak, nonatomic) id<IDesDelegate> delegate;
- (void)setContent:(NSString *)aContent;
- (void)setdescUrl:(NSString *)aUrl;

@end
