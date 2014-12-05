//
//  HubControlPriceView.h
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HbhCategory;
@protocol controlPriceDelegate <NSObject>

- (void)priceChangedWithPrice:(NSString *)price; //和vc交互 修改价格

@end

@interface HubControlPriceView : UIView<UITextFieldDelegate>

@property(nonatomic, weak) id<controlPriceDelegate> delegate;
@property(nonatomic, assign) BOOL hadGetPrice;

- (instancetype)initWithFrame:(CGRect)frame categoryModel:(HbhCategory *)cateModel;
//- (void)setCountType:(int)aType;// 1:(数量),2:（面积）,3:（长度)
//- (void)setCateId:(NSString *)cateId;
- (void)allTextFieldsResignFirstRespond;

- (BOOL)infoCheck;
- (NSString *)getUrgent;
- (NSString *)getMountType;//种类
- (NSString *)getAmount;//数量
- (NSString *)getComment;//备注
- (NSString *)getCateButtonType;//返回 是纯装  纯拆。。。

- (void)customedOfRenovate;//二次翻新定制显示状态

@end
