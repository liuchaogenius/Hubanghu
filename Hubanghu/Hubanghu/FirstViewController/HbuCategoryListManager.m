//
//  HbuCategoryListManager.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbuCategoryListManager.h"
#import "NetManager.h"
#import "CategoryInfoModel.h"
#import "CategoryChildInfoModel.h"

@implementation HbuCategoryListManager

+ (void)getCategroryInfoWithCateId:(double)cateId WithSuccBlock:(void(^)(CategoryInfoModel *cModel))aSuccBlock and:(void(^)(void))aFailBlock{
    NSString *getCategoryUrl = nil;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:cateId] forKey:@"cateId"];
    kHubRequestUrl(@"getCategory.ashx",getCategoryUrl);
    [NetManager requestWith:dic url:getCategoryUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        
        NSDictionary *dataDic = successDict[@"data"];
        
        if (aSuccBlock) {
            aSuccBlock([CategoryInfoModel modelObjectWithDictionary:dataDic]);
        }
        
    } failure:^(NSDictionary *failDict, NSError *error) {
        MLOG(@"%@",error.localizedDescription);
    }];
}

@end
