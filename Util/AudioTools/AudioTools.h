//
//  AvdioTools.h
//  AvdioDemo
//
//  Created by manito on 15/5/15.
//  Copyright (c) 2015年 manito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTools : NSObject

+ (instancetype)shareplaySouldTools;

- (void)playSould:(NSString *)name ofType:(NSString *)type;

@end
