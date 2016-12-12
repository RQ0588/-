//
//  NPYHttpRequest.m
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYHttpRequest.h"
#import "NPYUploadParam.h"

#import "NPYBaseConstant.h"

static id _instance = nil;

@implementation NPYHttpRequest

+ (instancetype)sharedInstance {
    return [[self alloc] init];
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    //位置网络
                    NSLog(@"位置网络");
                }
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                {
                    //无法联网
                    NSLog(@"无法联网");
                }
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    //手机自带网络
                    NSLog(@"当前使用的是蜂窝网络");
                }
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    //WIFI
                    NSLog(@"当前在WIFI网络下");
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    });
    
    return _instance;
}

#pragma mark -- GET请求 --
- (void)getWithUrlString:(NSString *)urlString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*可以接受的类型*/
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /**设置相应的缓存策略*/
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    /*请求队列的最大并发数*/
//    manager.operationQueue.maxConcurrentOperationCount = 5;
    /*请求超时的时间*/
    manager.requestSerializer.timeoutInterval = 30;
    /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /**/
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

#pragma mark -- POST请求 --

- (void)postWithUrlString:(NSString *)urlString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*可以接受的类型*/
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /*设置相应的缓存策略*/
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    /*请求队列的最大并发数*/
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /*请求超时的时间*/
    manager.requestSerializer.timeoutInterval = 30;
    /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    /**/
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

#pragma mark -- POST/GET网络请求 --

- (void)requestWithUrlString:(NSString *)urlString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
        case HttpRequestTypePost:
        {
            [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
    }
    
}

#pragma mark -- 上传图片 --

- (void)uploadWithUrlString:(NSString *)urlString
                 parameters:(id)parameters
                uploadParam:(NSArray<NPYUploadParam *> *)uploadParams
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NPYUploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

#pragma mark -- 下载数据 --

- (void)downloadWithUrlString:(NSString *)urlString
                   parameters:(id)parameters
                     progress:(void (^)())progress
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress();
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return targetPath;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    [downLoadTask resume];
    
}

@end



