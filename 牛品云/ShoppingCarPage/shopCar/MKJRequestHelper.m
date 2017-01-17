//
//  MKJRequestHelper.m
//  AutoLayoutShowTime
//
//  Created by MKJING on 16/8/19.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJRequestHelper.h"
//#import <MJExtension.h>
#import "MJExtension.h"
#import "shoppingCartModel.h"
#import "NPYBaseConstant.h"

#define shoppingCarUrl @"/index.php/app/Shopping/get"

@interface MKJRequestHelper () {
    NSMutableArray *shopMArr;
}

@end

@implementation MKJRequestHelper

static MKJRequestHelper *_requestHelper;

static id _requestHelp;

+ (instancetype)shareRequestHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [[self alloc] init];
    });
    return _requestHelp;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [super allocWithZone:zone];
    });
    return _requestHelp;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _requestHelp;
}


- (void)requestShoppingCartInfo:(requestHelperBlock)block
{
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    //主页面网络请求
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id", nil];
    [self requestShoppingCarDataWithUrlString:shoppingCarUrl withKeyValueParemes:requestDic block:block];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"shoppingCart" ofType:@"json"];
//    NSString *shoppingStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
//    NSDictionary *shoppingDic = [shoppingStr mj_JSONObject];
//    [BuyerInfo mj_setupObjectClassInArray:^NSDictionary *{
//        
//        return @{@"prod_list":@"ProductInfo"};
//        
//    }];
//    
//    [ProductInfo mj_setupObjectClassInArray:^NSDictionary *{
//       
//        return @{@"model_detail":@"ModelDeatail"};
//        
//    }];
//    
//    NSMutableArray *buyerLists = [BuyerInfo mj_objectArrayWithKeyValuesArray:shoppingDic[@"buyers_data"]];
//    block(buyerLists,nil);
}

- (void)requestShoppingCarDataWithUrlString:(NSString *)url withKeyValueParemes:(NSDictionary *)pareme block:(requestHelperBlock)block {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSArray *tpArr = dataDict[@"data"];
            
            NSMutableArray *goodsMArr = [NSMutableArray new];
            
            NSMutableArray *specMArr = [NSMutableArray new];
            
            shopMArr = [NSMutableArray new];
            NSMutableDictionary *shopMDict = [NSMutableDictionary new];
            
            
            for (int i = 0; i < tpArr.count; i++) {
                NSDictionary *tpDict = tpArr[i];
                NSMutableDictionary *specMDict = [NSMutableDictionary new];
                [specMDict setObject:[tpDict valueForKey:@"spec_id"] forKey:@"key"];
                [specMDict setObject:[tpDict valueForKey:@"spec_name"] forKey:@"type_name"];
                [specMDict setObject:[tpDict valueForKey:@"postage"] forKey:@"value"];//邮费
                [specMArr addObject:specMDict];
                
                NSMutableDictionary *goodsMDict = [NSMutableDictionary new];
                [goodsMDict setObject:[tpDict valueForKey:@"goods_id"] forKey:@"prod_id"];
                [goodsMDict setObject:[tpDict valueForKey:@"goods_img"] forKey:@"image"];
                [goodsMDict setObject:[tpDict valueForKey:@"goods_name"] forKey:@"title"];
                [goodsMDict setObject:[tpDict valueForKey:@"goods_price"] forKey:@"price"];
                [goodsMDict setObject:[tpDict valueForKey:@"goods_price"] forKey:@"order_price"];
                [goodsMDict setObject:[tpDict valueForKey:@"goods_price"] forKey:@"cn_price"];
                [goodsMDict setObject:specMArr forKey:@"model_detail"];
                [goodsMDict setObject:[tpDict valueForKey:@"number"] forKey:@"count"];
                [goodsMDict setObject:[tpDict valueForKey:@"spec_id"] forKey:@"remark"];
                [goodsMArr addObject:goodsMDict];
                
            }
            
            for (int i = 0; i < tpArr.count; i++) {
                NSDictionary *tpDict = tpArr[i];
                NSString *str = [tpDict valueForKey:@"shop_id"];
                
                if (i == 0) {
                    [shopMDict setObject:[tpDict valueForKey:@"shopping_id"] forKey:@"buyer_shopping_id"];
                    [shopMDict setObject:[tpDict valueForKey:@"shop_id"] forKey:@"buyer_id"];
                    [shopMDict setObject:[tpDict valueForKey:@"shop_name"] forKey:@"nick_name"];
                    [shopMDict setObject:goodsMArr forKey:@"prod_list"];
                    [shopMDict setObject:[tpDict valueForKey:@"shop_img"] forKey:@"user_avatar"];
                    [shopMDict setObject:[tpDict valueForKey:@"postage"] forKey:@"trans_fee"];
                    
                    [shopMArr addObject:shopMDict];
                    
                }
                
                for (int i = 1; i < tpArr.count; i++) {
                    NSDictionary *tpDict2 = tpArr[i];
                    NSString *str2 = [tpDict2 valueForKey:@"shop_id"];
                    
                    if ([str2 isEqualToString:str]) {
                        
                    } else {
                        [shopMDict setObject:[tpDict valueForKey:@"shopping_id"] forKey:@"buyer_shopping_id"];
                        [shopMDict setObject:[tpDict valueForKey:@"shop_id"] forKey:@"buyer_id"];
                        [shopMDict setObject:[tpDict valueForKey:@"shop_name"] forKey:@"nick_name"];
                        [shopMDict setObject:goodsMArr forKey:@"prod_list"];
                        [shopMDict setObject:[tpDict valueForKey:@"shop_img"] forKey:@"user_avatar"];
                        [shopMDict setObject:[tpDict valueForKey:@"postage"] forKey:@"trans_fee"];
                        
                        [shopMArr addObject:shopMDict];
                    }
                    
                }
                
            }
            
            [BuyerInfo mj_setupObjectClassInArray:^NSDictionary *{
                
                return @{@"prod_list":@"ProductInfo"};
                
            }];
            
            [ProductInfo mj_setupObjectClassInArray:^NSDictionary *{
                
                return @{@"model_detail":@"ModelDeatail"};
                
            }];
            
            NSMutableArray *buyerLists = [BuyerInfo mj_objectArrayWithKeyValuesArray:shopMArr];
            block(buyerLists,nil);
            
        } else {
            //失败
            block(nil,dataDict[@"data"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestMoreRecommandInfo:(requestHelperBlock)block
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"moreRecommand" ofType:@"json"];
    NSString *relatedStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    NSDictionary *relatedDic = [relatedStr mj_JSONObject];
    [RelatedProducts mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"list":@"SingleProduct"};
    }];
    RelatedProducts *products = [RelatedProducts mj_objectWithKeyValues:relatedDic];
    block(products.list,nil);
}


- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count ==0 || array == nil);
}

- (NSAttributedString *)recombinePrice:(CGFloat)CNPrice orderPrice:(CGFloat)unitPrice
{
    NSMutableAttributedString *mutableAttributeStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.f",unitPrice] attributes:@{NSForegroundColorAttributeName : [UIColor redColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:12]}];
    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.f",CNPrice] attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:11],NSStrikethroughStyleAttributeName :@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName : [UIColor lightGrayColor]}];
    [mutableAttributeStr appendAttributedString:string1];
    [mutableAttributeStr appendAttributedString:string2];
    return mutableAttributeStr;
}

@end
