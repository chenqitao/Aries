//
//  RRHTTPLive.h
//  RayCollege
//
//  Created by manito on 15/6/29.
//  Copyright (c) 2015年 manito. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^MMHTTPRequestSuccessBlock)(id responseObject);
typedef void (^MMHTTPRequestFailedBlock)(NSError *error);

@interface RRHTTPLive : AFHTTPSessionManager

+ (RRHTTPLive *)sharedHTTPRequest;

/**
 *  get 请求
 *
 *  @param method       请求地址
 *  @param parmars      请求参数
 *  @param successBlock 成功的block
 *  @param failedBlock  失败的block
 */
- (void)openAPIGetToMethod:(NSString *)method
                   parmars:(NSDictionary *)parmars
                   success:(MMHTTPRequestSuccessBlock)successBlock
                      fail:(MMHTTPRequestFailedBlock)failedBlock;

@end
