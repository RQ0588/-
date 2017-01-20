//
//  NPYVacciniaViewController.m
//  牛品云
//
//  Created by Eric on 16/12/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYVacciniaViewController.h"
#import "NPYBaseConstant.h"

@interface NPYVacciniaViewController () {
    NSDictionary *shareDict;
}

@end

@implementation NPYVacciniaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    userModel.sign = [userDict valueForKey:@"sign"];
    //分享的数据
    NSDictionary *shareRequest = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id", nil];
    [self requestShareInfoWithUrlString:@"/index.php/app/User/share_user" withParames:shareRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"获取牛豆";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.mainScroller.contentSize = CGSizeMake(0, WIDTH_SCREEN + 50);
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//fenxiang
- (IBAction)shareButtonPressed:(id)sender {
    ShareObject *share = [ShareObject shareDefault];
    if (!shareDict) {
        return;
    }
    [share sendMessageWithTitle:[shareDict valueForKey:@"text"] withContent:[shareDict valueForKey:@"text"] withUrl:[shareDict valueForKey:@"url"] withImages:[shareDict valueForKey:@"img"] result:^(NSString *result, UIAlertViewStyle style) {
       
        [ZHProgressHUD showMessage:result inView:self.view];
        
    }];

}

- (IBAction)wxClick:(id)sender {
    //weixinhaoyou
    
}

- (IBAction)wxFriendClick:(id)sender {
    //weixinpengyouquan
    
}
- (IBAction)wbClick:(id)sender {
    //weibo
    
}

- (void)requestShareInfoWithUrlString:(NSString *)url withParames:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            
            shareDict = [NSDictionary dictionaryWithObjectsAndKeys:[tpDict valueForKey:@"img"],@"img",[tpDict valueForKey:@"text"],@"text",[tpDict valueForKey:@"url"],@"url", nil];
            
        } else {
            //失败
            //            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
