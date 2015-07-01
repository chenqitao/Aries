//
//  MMString.m
//  Manito
//
//  Created by manito on 15/5/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMString.h"

@implementation MMString

+ (NSString *)photoStringWithSubString:(NSString *)subPath {
    return [NSString stringWithFormat:@"http://api.touchyo.com/%@",subPath];
}

@end
