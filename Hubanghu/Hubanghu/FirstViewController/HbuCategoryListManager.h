//
//  HbuCategoryListManager.h
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HbhCategory;
@interface HbuCategoryListManager : NSObject

+ (void)getCategroryInfoWithCateId:(double)cateId WithSuccBlock:(void(^)(HbhCategory *cModel))aSuccBlock and:(void(^)(void))aFailBlock;

@end