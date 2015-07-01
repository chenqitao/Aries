//
//  CoreImageTools.m
//  Manito
//
//  Created by manito on 15/5/20.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "CoreImageTools.h"

@interface CoreImageTools ()
{
    CIImage *ciImage;
}
@property (nonatomic, strong, readwrite) UIImage *result;

@end

@implementation CoreImageTools

- (instancetype)initFilterImageUrl:(NSString *)url orImage:(UIImage *)image filterName:(NSString *)name {

    self = [super init];
    if (self) {
        // 将UIImage转换成CIImage
        
        if (image) {
            ciImage = [[CIImage alloc] initWithImage:image];
        } else {
           ciImage = [[CIImage alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.touchyo.com%@",url]]];
        }
        
        // 创建滤镜
        CIFilter *filter = [CIFilter filterWithName:name
                                      keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setDefaults];
        
        // 获取绘制上下文
        CIContext *context = [CIContext contextWithOptions:nil];
        
        // 渲染并输出CIImage
        CIImage *outputImage = [filter outputImage];
        
        // 创建CGImage句柄
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        
        _result = [UIImage imageWithCGImage:cgImage];
        // 释放CGImage句柄
        CGImageRelease(cgImage);
    }
    return self;
}

@end
