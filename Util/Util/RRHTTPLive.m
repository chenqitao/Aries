//
//  RRHTTPLive.m
//  RayCollege
//
//  Created by manito on 15/6/29.
//  Copyright (c) 2015年 manito. All rights reserved.
//

#import "RRHTTPLive.h"

static NSString *baseURL = @"http://api.map.baidu.com";

@implementation RRHTTPLive

+ (RRHTTPLive *)sharedHTTPRequest {
    static RRHTTPLive *_sharedMMHTTPRequest = nil;
    
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
          if (responseObject) {
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

@end
