//
//  HbhFirstPageManager.m
//  Hubanghu
//
//  Created by yato_kami on 14/11/26.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhFirstPageManager.h"
#import "HbhBanners.h"
#import "NetManager.h"
@implementation HbhFirstPageManager

- (void)getBannersWithSucc:(void(^)(NSMutableArray* succArray))succ failure:(void(^)())failure
{
    NSString *url;
    kHubRequestUrl(@"getBanner.ashx", url);
    [NetManager requestWith:nil url:url method:@"GET" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        NSDictionary *data = successDict[@"data"];
        if ([data[@"result"] integerValue] == 1) {
            NSArray *bannerArray = data[@"Banners"];
            NSMutableArray *bannerModelsArray = [NSMutableArray arrayWithCapacity:bannerArray.count];
            for (int i = 0; i < bannerArray.count; i++) {
                HbhBanners *bannerModel = [HbhBanners modelObjectWithDictionary:bannerArray[i]];
                bannerModelsArray[i] = bannerModel;
            }
            if (bannerModelsArray.count) {
                succ(bannerModelsArray);
            }else{
                failure();
            }
        }else{
            failure();
        }
    } failure:^(NSDictionary *failDict, NSError *error) {
        failure();
    }];
}

@end
