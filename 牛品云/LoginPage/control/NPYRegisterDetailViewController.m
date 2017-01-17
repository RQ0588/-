//
//  NPYRegisterDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/11/16.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYRegisterDetailViewController.h"
#import "NPYBaseConstant.h"
#import "NPYLoginMode.h"

@interface NPYRegisterDetailViewController () {
    UITextField *nameT,*pwT,*confirmPWT;
    UIButton *completeBtn;
}

@end

@implementation NPYRegisterDetailViewController

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"帐号注册";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self mainViewLoad];
}

- (void)mainViewLoad {
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 80, 20)];
    [self.view addSubview:nameL];
    nameL.text = @"账号";
    nameL.textColor = [UIColor blackColor];
    
    UILabel *pwL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + 30, CGRectGetWidth(nameL.frame), CGRectGetHeight(nameL.frame))];
    [self.view addSubview:pwL];
    pwL.text = @"密码";
    pwL.textColor = [UIColor blackColor];
    
    UILabel *confirmPWL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(pwL.frame) + 30, CGRectGetWidth(nameL.frame), CGRectGetHeight(nameL.frame))];
    [self.view addSubview:confirmPWL];
    confirmPWL.text = @"确认密码";
    confirmPWL.textColor = [UIColor blackColor];
    
    nameT = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame) + 5, CGRectGetMinY(nameL.frame), WIDTH_SCREEN - 40 - CGRectGetWidth(nameL.frame) - 10, CGRectGetHeight(nameL.frame))];
    [self.view addSubview:nameT];
    nameT.placeholder = @"请输入会员名";
    nameT.textColor = [UIColor blackColor];
    nameT.borderStyle = UITextBorderStyleNone;
    nameT.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [nameT becomeFirstResponder];
    nameT.adjustsFontSizeToFitWidth = YES;
    
    pwT = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameT.frame), CGRectGetMinY(pwL.frame), CGRectGetWidth(nameT.frame), CGRectGetHeight(nameL.frame))];
    [self.view addSubview:pwT];
    pwT.placeholder = @"请输入密码";
    pwT.textColor = [UIColor blackColor];
    pwT.borderStyle = UITextBorderStyleNone;
    pwT.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    pwT.adjustsFontSizeToFitWidth = YES;
    
    confirmPWT = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(pwT.frame), CGRectGetMinY(confirmPWL.frame), CGRectGetWidth(nameT.frame), CGRectGetHeight(nameL.frame))];
    [self.view addSubview:confirmPWT];
    confirmPWT.placeholder = @"请再次输入密码";
    confirmPWT.textColor = [UIColor blackColor];
    confirmPWT.borderStyle = UITextBorderStyleNone;
    confirmPWT.clearButtonMode = UITextFieldViewModeWhileEditing;
    [confirmPWT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    confirmPWT.adjustsFontSizeToFitWidth = YES;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + i * 50 + 10, WIDTH_SCREEN - 40, 1)];
        lineImg.backgroundColor = GRAY_BG;
        [self.view addSubview:lineImg];
    }
    
    completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(confirmPWT.frame) + 50, WIDTH_SCREEN - 40, 40)];
    [self.view addSubview:completeBtn];
    completeBtn.backgroundColor =  [UIColor redColor];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)textFieldDidChange:(UITextField *)tx {
    
}

- (void)completeBtnButtonPressed:(UIButton *)btn {
    //完成注册，返回到首页
    if (![pwT.text isEqualToString:confirmPWT.text] || pwT.text.length == 0 || confirmPWT.text.length == 0) {
        [ZHProgressHUD showMessage:@"输入的密码不一致or信息没有填写完整" inView:self.view];
        return;
    }
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",nameT.text,@"name",pwT.text,@"pwd",self.phoneNumber,@"phone",self.verifyCode,@"code",self.refereesPhone,@"recommend", nil];
    [self requestDataWithUrlString:Register_url withKeyValueParemes:requestDic];
    
}

- (void)requestDataWithUrlString:(NSString *)url withKeyValueParemes:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            
            NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dataDict[@"data"]];
            model.r = dataDict[@"r"];
            model.sign = dataDict[@"sign"];
            
            [NPYSaveGlobalVariable saveValueAtLocal:dataDict withKey:LoginData_Local];
            [NPYSaveGlobalVariable saveValueAtLocal:dataDict[@"r"] withKey:LoginState];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
