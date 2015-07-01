//
//  MyLocation.m
//  EasyBS
//
//  Created by 杨 逍宇 on 14-4-16.
//  Copyright (c) 2014年 杨 逍宇. All rights reserved.
//

#import "MyLocation.h"

@interface MyLocation ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@property (copy, nonatomic) finishLocation finishBlock;
@property (copy, nonatomic) finishGeocoder geocoderBlock;
@property (copy, nonatomic) failBlock failBlock;
@end

@implementation MyLocation
+ (instancetype)shareMyLocation{
    static MyLocation *location = nil;
    static dispatch_once_t initMyLocation;
    dispatch_once(&initMyLocation, ^{
        location = [[MyLocation alloc] init];
    });
    return location;
}

- (id)init{
    self = [super init];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy=kCLLocationAccuracyBest;
        if (IOS8) {
            [self.manager requestWhenInUseAuthorization];//添加这句
        }
        self.manager.distanceFilter=1000.0f;
    }
    return self;
}

- (void)getUserLocation:(finishLocation)callback fail:(failBlock)failBlock{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        failBlock(@"file");
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"无法获取你的位置信息。 请到手机系统的[设置]—>[隐私]—>[定位服务]中打开定位服务，并允许TouchYO使用定位服务。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if(buttonIndex == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
    } else {
        [self.manager startUpdatingLocation];
        _finishBlock = callback;
    }
}

- (void)getUserGeocoder:(finishGeocoder)callback{
    [self getUserLocation:^(CLLocation *lo, NSError *error) {
        if (!error) {
            CLGeocoder *geo = [[CLGeocoder alloc] init];
            [geo reverseGeocodeLocation:lo completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *p = [placemarks lastObject];
                NSString *s;
                if (p.locality) {
                    s = [NSString stringWithFormat:@"%@,%@",p.locality,p.subLocality];
                }else
                    s = [NSString stringWithFormat:@"%@,%@",p.administrativeArea,p.subLocality];
                callback(s,error);
            }];
        }
    } fail:^(NSString *file) {
        
    }];
}

- (void)getGeocoderWith:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude andBlock:(finishGeocoder)callback{
    CLLocation *lo = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:lo completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *p = [placemarks lastObject];
        NSString *s;
        if (p.locality) {
            s = [NSString stringWithFormat:@"%@%@%@",p.locality,p.subLocality,p.thoroughfare];
        }else
            s = [NSString stringWithFormat:@"%@%@%@",p.administrativeArea,p.subLocality,p.thoroughfare];
        callback(s,error);
    }];
}

#pragma mark -- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _finishBlock([locations lastObject],nil);
    [self.manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied) { //访问被拒绝
        
    } if ([error code] == kCLErrorLocationUnknown) { //无法获取位置信息
        
    }
    _finishBlock(nil,error);
    [self.manager stopUpdatingLocation];
}

#pragma mark - dealloc
- (void)dealloc{
    [self.manager stopUpdatingLocation];
    self.manager = nil;
}

@end
