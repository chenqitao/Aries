//
//  CoreImageTools.h
//  Manito
//
//  Created by manito on 15/5/20.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreImageTools : NSObject

@property (nonatomic, strong, readonly) UIImage *result;

- (instancetype)initFilterImageUrl:(NSString *)url orImage:(UIImage *)image filterName:(NSString *)name;

@end
