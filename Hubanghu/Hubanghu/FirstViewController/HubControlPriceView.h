//
//  HubControlPriceView.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol controlPriceDelegate <NSObject>

- (void)priceChangedWithPrice:(NSString *)price; //和vc交互 修改价格

@end

@interface HubControlPriceView : UIView<UITextFieldDelegate>

@property(nonatomic, weak) id<controlPriceDelegate> delegate;

- (void)setCountType:(int)aType;// 1:(数量),2:（面积）,3:（长度)
- (void)setCateId:(NSString *)cateId;

@end
