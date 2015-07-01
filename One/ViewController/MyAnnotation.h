//
//  MyAnnotation.h
//  Travel
//
//  Created by YangXIAOYU on 14/12/17.
//  Copyright (c) 2014年 mickel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MyAnnotation : NSObject<MKAnnotation>
@property (nonatomic, strong) NSString *mytitle;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

- (id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate;
@end
