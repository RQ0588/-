//
//  NPYHttpRequest.h
//  牛品云
//
//  Created by Eric on 16/12/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NPYUploadParam;

typedef NS_ENUM(NSUInteger, HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    
    /**
     *  post请求
     */
    HttpRequestTypePost
    
};

@interface NPYHttpRequest : NSObject

+ (instancetype)sharedInstance;

/**
 *  发送get请求
 *
 *  urlString   请求的网址字符串
 *  parameters  请求的参数
 *  success     请求成功的回调
 *  failure     请求失败的回调
 */
- (void)getWithUrlString:(NSString *)urlString
              parameters:(id)parameters
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  urlString   请求的网址字符串
 *  parameters  请求的参数
 *  success     请求成功的回调
 *  failure     请求失败的回调
 */
- (void)postWithUrlString:(NSString *)urlString
              parameters:(id)parameters
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  发送网络请求
 *
 *  urlString   请求的网址字符串
 *  parameters  请求的参数
 *  type        请求的类型
 *  success     请求成功的回调
 *  failure     请求失败的回调
 */
- (void)requestWithUrlString:(NSString *)urlString
              parameters:(id)parameters
                    type:(HttpRequestType)type
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  urlString       上传图片的网址字符串
 *  parameters      上传图片的参数
 *  uploadParams    上传图片的信息
 *  success         上传成功的回调
 *  failure         上传失败的回调
 */
- (void)uploadWithUrlString:(NSString *)urlString
                  parameters:(id)parameters
                        uploadParam:(NSArray <NPYUploadParam *> *)uploadParams
                     success:(void(^)())success
                     failure:(void(^)(NSError *error))failure;

/**
 *  下载数据
 *
 *  urlString       下载数据的网址
 *  parameters      下载数据的参数
 *  success         下载成功的回调
 *  failure         下载失败的回调
 */
- (void)downloadWithUrlString:(NSString *)urlString
                   parameters:(id)parameters
                     progress:(void(^)())progress
                      success:(void(^)())success
                      failure:(void(^)(NSError *error))failure;

@end




