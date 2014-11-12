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
#import "HbhUser.h"
@interface NetManager()
{
    NSMutableDictionary *mutaDict;
    NSString *strUserid;
    float lat;
    float lon;
    NSString *areaId;
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

- (void)setUserid:(NSString *)aUserid
{
    strUserid = aUserid;
}

- (void)setLat:(float)alat
{
    lat = alat;
}

- (void)setLon:(float)alon
{
    lon = alon;
}

- (void)setAreaId:(NSString *)aAreaId
{
    areaId = aAreaId;
}

- (NSString *)getUserid
{
    return strUserid;
}

- (float)getLat
{
    return lat;
}

- (float)getLon
{
    return lon;
}

- (NSString *)getAreaId
{
    return areaId;
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
    [NetManager setRequestHeadValue:request];
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

+ (void)setRequestHeadValue:(NSMutableURLRequest*)aRequest
{
    NetManager *net = [NetManager shareInstance];
    HbhUser *user = [HbhUser sharedHbhUser];
    if(user.userID)
    {
        [aRequest addValue:user.userID forHTTPHeaderField:@"hbh_uid"];
        //[aRequest addValue:@"1" forHTTPHeaderField:@"hbh_uid"];
        MLOG(@"userId : %@",user.userID);
    }
    if ([net getAreaId]) {
        [aRequest setValue:[net getAreaId] forHTTPHeaderField:@"hbh_areaId"];
    }
    if ([net getLat]) {
        [aRequest setValue:[NSString stringWithFormat:@"%.3f",[net getLat]] forHTTPHeaderField:@"hbh_lat"];
    }
    if ([net getLon]) {
        [aRequest setValue:[NSString stringWithFormat:@"%.3f",[net getLon]] forHTTPHeaderField:@"hbh_lon"];
    }
#if DEBUG
    [aRequest addValue:@"0" forHTTPHeaderField:@"hbh_mock"];
#else
    [aRequest addValue:@"0" forHTTPHeaderField:@"hbh_mock"];
#endif
    
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [bundleDic objectForKey:@"CFBundleShortVersionString"];
    [aRequest addValue:appVersion forHTTPHeaderField:@"hbh_appver"];
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
        block(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *Dict = [operation.responseString objectFromJSONString];
        success(Dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *resultDictionary = [operation.responseString objectFromJSONString];
        failure(resultDictionary, nil);
    }];
    [operation start];
}
@end
