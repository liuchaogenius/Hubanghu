//
//  MyHttpClient.h
//  BrainStorm
//
//  Created by only on 12-10-31.
//  Copyright (c) 2012年 only. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface MyHttpClient : AFHTTPClient

+ (AFHTTPClient *)shareHttpClient;

@end
