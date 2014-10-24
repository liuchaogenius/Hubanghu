//
//  BaseViewController.h
//  FW_Project
//
//  Created by  striveliu on 13-10-3.
//  Copyright (c) 2013年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) CGFloat g_OffsetY;
@property (nonatomic, strong) UIImage *backgroundimg;
@property (nonatomic ,strong) UIButton *rightButton;
- (void)setLeftButton:(UIImage *)aImg
                title:(NSString *)aTitle
               target:(id)aTarget
               action:(SEL)aSelector;
- (void)setRightButton:(UIImage *)aImg
                 title:(NSString *)aTitle
                target:(id)aTarget
                action:(SEL)aSelector;
- (void)settitleLabel:(NSString*)aTitle;
- (void)pushView:(UIView*)aView;

- (void)popView:(UIView*)aView completeBlock:(void(^)(BOOL isComplete))aCompleteblock;
@end
