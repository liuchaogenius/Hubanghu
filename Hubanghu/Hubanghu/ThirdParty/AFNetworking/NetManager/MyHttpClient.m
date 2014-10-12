//
//  MyHttpClient.m
//  BrainStorm
//
//  Created by only on 12-10-31.
//  Copyright (c) 2012年 only. All rights reserved.
//

#import "MyHttpClient.h"

static AFHTTPClient *afHttpClient;

@implementation MyHttpClient

+ (AFHTTPClient *)shareHttpClient
{
    if (afHttpClient == nil)
    {
        afHttpClient = [[self alloc] initWithBaseURL:nil];
    }
    return afHttpClient;
}

@end
