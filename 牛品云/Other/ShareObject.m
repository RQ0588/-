//
//  ShareObject.m
//  SDWTestProduct
//
//  Created by Raija on 16/4/13.
//  Copyright © 2016年 Lqing. All rights reserved.
//

#import "ShareObject.h"
#import "NPYBaseConstant.h"

@implementation ShareObject

+ (ShareObject *)shareDefault {
    
    static ShareObject *object = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        object = [[ShareObject alloc] init];
    });
    
    return object;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        //ShareSDK
        [ShareSDK registerApp:@"19d2d6125e05a"
         //分享平台
              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformSubTypeWechatSession),
                                @(SSDKPlatformSubTypeWechatTimeline),
                                @(SSDKPlatformSubTypeQZone),
                                @(SSDKPlatformSubTypeQQFriend)]
         //连接平台SDK
                     onImport:^(SSDKPlatformType platformType) {
                         
                         switch (platformType) {
                             case SSDKPlatformTypeSinaWeibo:
                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                 break;
                             case SSDKPlatformTypeWechat:
                                 [ShareSDKConnector connectWeChat:[WXApi class]];
                                 break;
                             case SSDKPlatformTypeQQ:
                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                 break;
                                 
                             default:
                                 break;
                         }
                         
                     }
         //配置平台
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                  
                  switch (platformType)
                  {
                      case SSDKPlatformTypeSinaWeibo:
                          //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                          [appInfo SSDKSetupSinaWeiboByAppKey:@"1002644024"
                                                    appSecret:@"adeb23182b5b175cdeb5c998dd903438"
                                                  redirectUri:@"http://www.niupinyun.com"
                                                     authType:SSDKAuthTypeBoth];
                          break;
                      case SSDKPlatformTypeWechat:
                          [appInfo SSDKSetupWeChatByAppId:@"wxa2c8d7db5afb8bf6"
                                                appSecret:@"a6cc077669692f37e81728b68e9cfb21"];
                          break;
                      case SSDKPlatformTypeQQ:
                          [appInfo SSDKSetupQQByAppId:@"1105805099"
                                               appKey:@"RLmjh7SyoJE4FdqQ"
                                             authType:SSDKAuthTypeBoth];
                          break;
                          
                      default:
                          break;
                  }
              }];
        
    }
    
    return self;
}

- (void)sendMessageWithTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)aUrlString withImages:(id)images result:(shareResultBlock)result {
    
    self.block = result;
    
    //1、创建分享参数
    NSArray* imageArray = images;
    
    if (title == nil) {
        title = @"牛品云分享";
    }
    
    if (content == nil) {
        content = @"详情分享";
    }
    
    if (aUrlString == nil) {
        aUrlString = @"http://www.niupinyun.com";
    }
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:aUrlString]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN - 64, WIDTH_SCREEN, 0)];
        [[UIApplication sharedApplication].keyWindow addSubview:container];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",content,aUrlString] title:title image:images url:[NSURL URLWithString:aUrlString] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单）
        //调用分享的方法
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:container
                                                                         items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                        
                                                                       NSLog(@"分享成功!");
                                                                       break;
                                                                   case SSDKResponseStateFail:
                                                                       NSLog(@"分享失败%@",error);
                                                                  
                                                                       break;
                                                                   case SSDKResponseStateCancel:
                                                                       NSLog(@"分享已取消");
                                                               
                                                                       
                                                                       break;
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        //删除和添加平台示例
//        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];//(默认微信，QQ，QQ空间都是直接跳客户端分享，加了这个方法之后，可以跳分享编辑界面分享)
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];//（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
        
    }
    
}


@end
