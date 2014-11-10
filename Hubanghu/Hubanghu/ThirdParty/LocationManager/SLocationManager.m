//
//  FWLocationObj.m
//  FW_Project
//
//  Created by  striveliu on 14-2-20.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "SLocationManager.h"
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#define MIN_VALUE 1e-8  //根据需要调整这个值
#define IS_DOUBLE_ZERO(d) (abs(d) < MIN_VALUE)

#ifdef DEBUG
#define MLOG(...)  printf("\n\t<%s line%d>\n%s\n", __FUNCTION__,__LINE__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String])

#else
#define MLOG(...)
#define NSLog(...) {}
#endif

static SLocationManager *myLocationObj = nil;
@implementation SLocationManager
@synthesize myLocationManager;
@synthesize locationDict;
@synthesize addressBlock;
//@synthesize runLoopModes = _runLoopModes;
+ (SLocationManager *)getMyLocationInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(myLocationObj == nil)
        {
            myLocationObj = [[SLocationManager alloc] init];
        }
    });
    return myLocationObj;
}

//+ (void)networkEntry:(id)__unused object {
//    do {
//        @autoreleasepool {
//            [[NSRunLoop currentRunLoop] run];
//        }
//    } while (YES);
//}
//
//void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity,
//                       void *info)
//{
//    NSLog(@"runloop");
//}
//
//+ (NSThread *)networkThread
//{
//    static NSThread *_networkThread = nil;
//    static dispatch_once_t oncePredicate;
//    
//    dispatch_once(&oncePredicate, ^{
//        _networkThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkEntry:) object:nil];
//        [_networkThread start];
//    });
//    
//    return _networkThread;
//}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.longitude = 0.00;
        self.latitude = 0.00;
        [self initLocationManager];
    }
    return self;
}

- (void)initLocationManager
{
    self.myLocationManager = [[CLLocationManager alloc] init];
    self.myLocationManager.delegate = self;
    self.myLocationManager.distanceFilter = 1000;
//    self.myLocationManager.purpose =
//    @"请开启定位,以便我们提供更精确的判断.";
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
}


- (void)applicationdidBecome
{

}

- (void)statUpdateLocation:(void(^)(Location2d al2d))aBlock
{
    [self startLocation:aBlock];
}

- (void)requestAuthorization
{
    BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
    BOOL hasWhenInUseKey = [[NSBundle mainBundle]
                            objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
    MLOG(@"authorizationStatus = %d",[CLLocationManager authorizationStatus]);
    if(hasAlwaysKey && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self requestAlwaysLocationAuthorization];
    }
    else if(hasWhenInUseKey && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self requestWhenUserLocationAuthorization];
    }
    else
    {
        [self startLocation];
    }
}

- (void)startLocation
{
    isLocationing = YES;///重复定位和重复网络请求？？？？？？？？
    [self.myLocationManager startUpdatingLocation];
    [self performSelector:@selector(locationTimeOut) withObject:nil afterDelay:10];
}

- (void)startLocation:(void(^)(Location2d al2d))aBlock
{
    self.locationDegree = aBlock;
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    [self requestAuthorization];
//#else
//    if([CLLocationManager locationServicesEnabled] && isLocationing == NO)
//    {
//        isLocationing = YES;///重复定位和重复网络请求？？？？？？？？
//        [self.myLocationManager startUpdatingLocation];
//        [self performSelector:@selector(locationTimeOut) withObject:nil afterDelay:10];
//    }
//#endif
}

- (void)requestAlwaysLocationAuthorization
{
//#ifdef __IPHONE_8_0
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if([self.myLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        //[self.myLocationManager requestAlwaysAuthorization];
        [self.myLocationManager performSelector:@selector(requestAlwaysAuthorization)];
    }
    if([CLLocationManager locationServicesEnabled] && isLocationing == NO)
    {
        [self startLocation];
    }

    
//#endif
//#endif
}

- (void)requestWhenUserLocationAuthorization
{
//#ifdef __IPHONE_8_0
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if([self.myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        //[self.myLocationManager requestWhenInUseAuthorization];
        [self.myLocationManager performSelector:@selector(requestWhenInUseAuthorization)];
    }
    if([CLLocationManager locationServicesEnabled] && isLocationing == NO)
    {
        [self startLocation];
    }

//#endif
//#endif
}

- (void)locationTimeOut
{
    MLOG(@"超时");
    isLocationing = NO;
    [self.myLocationManager stopUpdatingLocation];
    Location2d l2d = {0};
    l2d.code = 0;
    if(addressBlock)
    {
        addressBlock(nil, l2d);
    }
    if(self.locationDegree)
    {
        self.locationDegree(l2d);
    }
}
///< ios6
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self locationManager:manager getLocation:newLocation];
}
//>=ios6.0
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(locations.count > 0){
        [self locationManager:manager getLocation:[locations lastObject]];
    }

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status >= kCLAuthorizationStatusAuthorized)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(locationTimeOut) withObject:nil afterDelay:20];
        [self.myLocationManager startUpdatingLocation];
    }
}

- (int)getLocationAuthorStatus
{
    return [CLLocationManager authorizationStatus];
}

- (void)locationManager:(CLLocationManager *)manager getLocation:(CLLocation *)location
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.myLocationManager stopUpdatingLocation];
    MLOG(@"Latitude = %f", location.coordinate.latitude);
    MLOG(@"Longitude = %f", location.coordinate.longitude);
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    if(isLocationing == YES)
    {
        if(self.locationDegree)
        {
            Location2d l2d={0};
            l2d.lat = self.latitude;
            l2d.lon = self.longitude;
            l2d.code = 1;
            self.locationDegree(l2d);
        }
        [self locationAddressWithLocation:self.latitude lon:self.longitude];
    }
    isLocationing = NO;
}

- (void)getLocationAddress:(BOOL)isStartLocation resultBlock:(void(^)(NSDictionary *aLocationDict,Location2d aL2d))aBlock
{
    if(addressBlock)
    {
        addressBlock = nil;
    }
    addressBlock = aBlock;
    if(isStartLocation)
    {
        [self statUpdateLocation:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /* Failed to receive user's location */
    isLocationing = NO;
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code])
    {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    [self locationTimeOut];
}

- (void)locationAddressWithLocation:(float)lat lon:(float)alon
{
    __weak SLocationManager *weakself = self;
    NSString *strlocation = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=F2fc1e6d3ef4195131cbcb8af07a604b&callback=renderReverse&location=%.6f,%.6f&output=json",lat,alon];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strlocation]];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        MLOG(@"%@",str1);
        NSMutableString *mutstr = [[NSMutableString alloc] initWithString:str1];
        NSRange rang = [mutstr rangeOfString:@"renderReverse&&renderReverse("];
        [mutstr replaceCharactersInRange:rang withString:@""];
        NSRange rang1 = [mutstr rangeOfString:@")"];
        [mutstr replaceCharactersInRange:rang1 withString:@""];
        self.locationDict = [mutstr objectFromJSONString];
        Location2d l2d={0};
        l2d.lat = weakself.latitude;
        l2d.lon = weakself.longitude;
        l2d.code = 1;
        MLOG(@"1111%@",self.locationDict);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.addressBlock(weakself.locationDict, l2d);
        });
    });

    
//    __weak SLocationManager *weakself = self;
//    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
//    [clGeoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         MLOG(@"error %@ placemarks count %lu",error.localizedDescription,(unsigned long)placemarks.count);
//         for (CLPlacemark *placeMark in placemarks)
//         {
//             self.locationDict = placeMark.addressDictionary;
//         }
//         MLOG(@"CLPlacemarkCLPlacemark%@",weakself.locationDict);
//         if(self.addressBlock)
//         {
//             Location2d l2d={0};
//             l2d.lat = weakself.latitude;
//             l2d.lon = weakself.longitude;
//             l2d.code = 1;
//             self.addressBlock(weakself.locationDict, l2d);
//         }
//     }];
}


@end
