//
//  NetManager.m
//  JieJiong
//
//  Created by xie licai on 12-12-21.
//  Copyright (c) 2012年 xie licai. All rights reserved.
//

#import "NetManager.h"
#import <objc/runtime.h>
#import "JSONKit.h"
#import "ThreadSafeMutableDictionary.h"
@interface NetManager()
{
    NSMutableDictionary *mutaDict;
}
@end

@implementation NetManager

+ (NetManager *)shareInstance
{
    static NetManager *netMan;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netMan = [[NetManager alloc] init];
    });
    return netMan;
}

- (instancetype)init
{
    if(self = [super init])
    {
        mutaDict = [[ThreadSafeMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)addOperationAndKey:(NSString *)aKey operation:(id)aOperation
{
    [mutaDict setObject:aOperation forKey:aKey];
}

- (void)removeOperationKey:(NSString *)aKey
{
    if(aKey)
    {
        [mutaDict removeObjectForKey:aKey];
    }
}
- (id)objectForKey:(NSString *)aKey
{
    if(aKey)
    {
        return [mutaDict objectForKey:aKey];
    }
    return nil;
}
- (void)removeAllOperation
{
    [mutaDict removeAllObjects];
}

- (void)dealloc
{
    MLOG(@"Netmanager--dealloc");
}

+ (void)requestWith:(NSDictionary *)aDict
                url:(NSString *)aUrl
             method:(NSString *)aMethod
       operationKey:(NSString *)aKey
     parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
               succ:(SUCCESSBLOCK)success
            failure:(FAILUREBLOCK)failure

{
    AFHTTPClient *httpClient = [MyHttpClient shareHttpClient];

    httpClient.parameterEncoding = aEncoding;
    NSMutableURLRequest *request = [httpClient requestWithMethod:aMethod path:aUrl parameters:aDict];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NetManager *net = [NetManager shareInstance];
    if(aKey)
    {
        [net addOperationAndKey:aKey operation:operation];
    }
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        //请求成功
        [net removeOperationKey:aKey];
        NSDictionary *Dict = [operation.responseString objectFromJSONString];
        success(Dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求失败
        [net removeOperationKey:aKey];
        NSDictionary *resultDictionary = [operation.responseString objectFromJSONString];
        failure(resultDictionary, error);
    }];
    //[operation start];
    [httpClient.operationQueue addOperation:operation];
}

+ (void)cancelOperation:(id)aKey
{
    NetManager *net = [NetManager shareInstance];
    AFHTTPRequestOperation *operation = [net objectForKey:aKey];
    [operation cancel];
}

+ (void)uploadImg:(UIImage*)aImg
       parameters:(NSDictionary*)aParam
        uploadUrl:(NSString*)aUrl
    uploadimgName:(NSString*)aImgname
   parameEncoding:(AFHTTPClientParameterEncoding)aEncoding
    progressBlock:(PROGRESSBLOCK)block
             succ:(SUCCESSBLOCK)success
          failure:(FAILUREBLOCK)failure
{
    
    AFHTTPClient *httpClient = [MyHttpClient shareHttpClient];
    httpClient.parameterEncoding = aEncoding;
    NSData *imageData = UIImageJPEGRepresentation(aImg, 1);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:aUrl parameters:aParam constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        [formData appendPartWithFileData:imageData name:@"cardImage" fileName:aImgname mimeType:@"image/jpeg"];
        
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *Dict = [operation.responseString objectFromJSONString];
//        NSURLRequest *temRequest = operation.request;
//        //NSString *strRequestID = [temRequest valueForHTTPHeaderField:@"uploadImgRequestID"];
//        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [mutDict setObject:Dict forKey:@"successDict"];
//        //[mutDict setObject:strRequestID forKey:@"requestID"];
//        success(mutDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSDictionary *resultDictionary = [operation.responseString objectFromJSONString];
//        NSURLRequest *temRequest = operation.request;
//        //NSString *strRequestID = [temRequest valueForHTTPHeaderField:@"uploadImgRequestID"];
//        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [mutDict setObject:resultDictionary forKey:@"failDict"];
//        //[mutDict setObject:strRequestID forKey:@"requestID"];
//        failure(mutDict, error);
    }];
    [operation start];
}
@end
