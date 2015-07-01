//
//  MMHTTPRequest.h
//  Manito
//
//  Created by manito on 15/5/6.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^MMHTTPRequestSuccessBlock)(id responseObject);
typedef void (^MMHTTPRequestFailedBlock)(NSError *error);

@interface MMHTTPRequest : AFHTTPSessionManager

+ (MMHTTPRequest *)sharedHTTPRequest;

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
/**
 *  post 请求
 *
 *  @param method       请求地址
 *  @param parmars      请求参数
 *  @param successBlock 成功的block
 *  @param failedBlock  失败的block
 */
- (void)openAPIPostToMethod:(NSString *)method
                    parmars:(NSDictionary *)parmars
                    success:(MMHTTPRequestSuccessBlock)successBlock
                       fail:(MMHTTPRequestFailedBlock)failedBlock;

/**
 *  包括上传文件的 POST 请求
 *
 *  @param method       上传请求地址
 *  @param parmars      上传请求参数
 *  @param fileData     上传请求的文件Data:和fileURL二选一，没有为nil
 *  @param fileURL      上传请求的文件路径: 和fileData二选一，没有为nil
 *  @param name         上传文件的别名，不是文件名称
 *  @param successBlock 成功的block
 *  @param failedBlock  失败的block
 */
- (void)openAPIPostToMethod:(NSString *)method
                    parmars:(NSDictionary *)parmars
                       data:(NSData *)fileData
                    fineURL:(NSString *)filePath
                       name:(NSString *)name
                    success:(MMHTTPRequestSuccessBlock)successBlock
                       fail:(MMHTTPRequestFailedBlock)failedBlock;


- (void)requestPostWithApi:(NSString *)api andParams:(NSDictionary *)dic andImage:(UIImage *)image andSuccess:(MMHTTPRequestSuccessBlock)success andfail:(MMHTTPRequestFailedBlock)fail;

@end
