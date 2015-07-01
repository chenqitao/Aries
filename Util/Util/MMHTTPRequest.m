//
//  MMHTTPRequest.m
//  Manito
//
//  Created by manito on 15/5/6.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMHTTPRequest.h"

//http://192.168.20.89:8080
//http://api.touchyo.com
static NSString *baseURL = @"http://api.touchyo.com";

@implementation MMHTTPRequest

+ (MMHTTPRequest *)sharedHTTPRequest {
    static MMHTTPRequest *_sharedMMHTTPRequest = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMMHTTPRequest = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    return _sharedMMHTTPRequest;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)openAPIGetToMethod:(NSString *)method
                   parmars:(NSDictionary *)parmars
                   success:(MMHTTPRequestSuccessBlock)successBlock
                      fail:(MMHTTPRequestFailedBlock)failedBlock {
    [self GET:method
   parameters:parmars
      success:^(NSURLSessionDataTask *task, id responseObject) {
          HHDPRINT(@"method=%@,parmars=%@,responseObject=%@",method,parmars,responseObject);
          NSInteger code = [[responseObject objectForKey:@"code"] intValue];
          if (code == 0) {//成功
              successBlock(responseObject);
          } else  {//失败
              if (!responseObject) {
                  
              } else {
                  NSError *error = [[NSError alloc] initWithDomain:@"200" code:200 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                  failedBlock(error);
              }
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          HHDPRINT(@"method=%@,error=%@",method,error);
          failedBlock(error);
      }];
}

- (void)openAPIPostToMethod:(NSString *)method
                    parmars:(NSDictionary *)parmars
                    success:(MMHTTPRequestSuccessBlock)successBlock
                       fail:(MMHTTPRequestFailedBlock)failedBlock
{
   
    [self POST:method
    parameters:parmars
       success:^(NSURLSessionDataTask *task, id responseObject) {
           HHDPRINT(@"method=%@,parmars=%@,responseObject=%@",method,parmars,responseObject);
           NSInteger code = [[responseObject objectForKey:@"code"] intValue];
           if (code == 0) {//成功
               successBlock(responseObject);
           } else {//失败
               if (!responseObject) {
                   failedBlock([responseObject objectForKey:@"code"]);
               } else {
                   NSError *error = [[NSError alloc] initWithDomain:@"200" code:200 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                   failedBlock(error);
               }
           }
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           HHDPRINT(@"method=%@,error=%@",method,error);
           failedBlock(error);
       }];
}

- (void)openAPIPostToMethod:(NSString *)method
                    parmars:(NSDictionary *)parmars
                       data:(NSData *)fileData
                    fineURL:(NSString *)filePath
                       name:(NSString *)name
                    success:(MMHTTPRequestSuccessBlock)successBlock
                       fail:(MMHTTPRequestFailedBlock)failedBlock
{
    [self POST:method parameters:parmars constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (filePath) {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            if (fileURL) {
                [formData appendPartWithFileURL:fileURL name:name error:nil];
            }
        } else if (fileData) {
            [formData appendPartWithFormData:fileData name:name];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        HHDPRINT(@"method=%@,parmars=%@,responseObject=%@",method,parmars,responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 0) {//成功
            successBlock(responseObject);
        } else {//失败
            if (!responseObject) {
                failedBlock([responseObject objectForKey:@"code"]);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"200" code:200 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                failedBlock(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        HHDPRINT(@"method=%@,error=%@",method,error);
        failedBlock(error);
    }];
}


- (void)requestPostWithApi:(NSString *)api andParams:(NSDictionary *)dic andImage:(UIImage *)image andSuccess:(MMHTTPRequestSuccessBlock)success andfail:(MMHTTPRequestFailedBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValuesForKeysWithDictionary:dic];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    
    [self POST:api parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue]==0) {
            if (success) {
                success(responseObject);
            }
        } else {
            if (!responseObject) {
                fail([responseObject objectForKey:@"code"]);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"200" code:200 userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"message"]}];
                fail(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        HHDPRINT(@"method=%@,error=%@",api,error);
        fail(error);
    }];
}


@end
