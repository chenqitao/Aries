//
//  MyAnnotation.m
//  Travel
//
//  Created by YangXIAOYU on 14/12/17.
//  Copyright (c) 2014年 mickel. All rights reserved.
//

#import "MyAnnotation.h"

@interface MyAnnotation ()
@end

@implementation MyAnnotation

- (id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate
 {
     if (self = [super init]) {
         self.mytitle = title;
         self.subTitle = subtitle;
         self.coord = coordinate;
     }
     return self;
}

- (NSString *)title
{
    return _mytitle;
}

- (NSString *)subtitle
{
    return _subTitle;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coord;
}

@end
