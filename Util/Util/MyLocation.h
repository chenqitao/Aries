//
//  MyLocation.h
//  EasyBS
//
//  Created by 杨 逍宇 on 14-4-16.
//  Copyright (c) 2014年 杨 逍宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^finishLocation)(CLLocation *lo,NSError *error);
typedef void(^finishGeocoder)(NSString *pl,NSError *error);
typedef void(^failBlock) (NSString * file);

@interface MyLocation : NSObject
+(instancetype)shareMyLocation;

- (void)getUserLocation:(finishLocation)callback fail:(failBlock)failBlock;//获取当前位置
- (void)getUserGeocoder:(finishGeocoder)callback;//获取当前位置的中文名称
- (void)getGeocoderWith:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude andBlock:(finishGeocoder)callback;//根据经纬度获取位置名称
@end
