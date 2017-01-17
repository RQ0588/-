//
//  NPYRetrievePWDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/11/16.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYRetrievePWDetailViewController.h"
#import "NPYBaseConstant.h"

#define Update_PW_Url @"/index.php/app/User/update_pwd"

@interface NPYRetrievePWDetailViewController () {
    UITextField *orPWT,*pwT,*confirmPWT;
    UIButton *completeBtn;
    int hCout;
}

@end

@implementation NPYRetrievePWDetailViewController

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.titleName;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self mainViewLoad];
}

- (void)mainViewLoad {
    if ([self.navigationItem.title isEqualToString:@"修改登录密码"]) {
        UILabel *orPW = [[UILabel alloc] initWithFrame:CGRectMake(18, 120, 80, 20)];
        [self.view addSubview:orPW];
        orPW.text = @"原密码";
        orPW.textColor = [UIColor blackColor];
        orPW.font = XNFont(17.0);
        hCout = 3;
        
        orPWT = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orPW.frame), CGRectGetMinY(orPW.frame), WIDTH_SCREEN - 40 - CGRectGetWidth(orPW.frame) - 10, CGRectGetHeight(orPW.frame))];
        [self.view addSubview:orPWT];
        orPWT.placeholder = @"请输入原密码";
        orPWT.textColor = [UIColor blackColor];
        orPWT.borderStyle = UITextBorderStyleNone;
        orPWT.clearButtonMode = UITextFieldViewModeWhileEditing;
        [orPWT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [orPWT becomeFirstResponder];
        orPWT.adjustsFontSizeToFitWidth = YES;
        
    } else {
        hCout = 2;
        
    }
    
    CGFloat pwY = orPWT == nil ? 120 : CGRectGetMaxY(orPWT.frame) + 30;
    
    UILabel *pw = [[UILabel alloc] initWithFrame:CGRectMake(18, pwY, 80, 20)];
    [self.view addSubview:pw];
    pw.text = @"新密码";
    pw.textColor = [UIColor blackColor];
    
    UILabel *pwL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(pw.frame), CGRectGetMaxY(pw.frame) + 30, CGRectGetWidth(pw.frame), CGRectGetHeight(pw.frame))];
    [self.view addSubview:pwL];
    pwL.text = @"确认密码";
    pwL.textColor = [UIColor blackColor];
    
    pwT = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pw.frame), CGRectGetMinY(pw.frame), WIDTH_SCREEN - 40 - CGRectGetWidth(pw.frame) - 10, CGRectGetHeight(pw.frame))];
    [self.view addSubview:pwT];
    pwT.placeholder = @"请输入密码";
    pwT.textColor = [UIColor blackColor];
    pwT.borderStyle = UITextBorderStyleNone;
    pwT.secureTextEntry = YES;
    pwT.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwT addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [pwT becomeFirstResponder];
    pwT.adjustsFontSizeToFitWidth = YES;
    
    confirmPWT = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(pwT.frame), CGRectGetMinY(pwL.frame), CGRectGetWidth(pwT.frame), CGRectGetHeight(pwT.frame))];
    [self.view addSubview:confirmPWT];
    confirmPWT.placeholder = @"请输入密码";
    confirmPWT.borderStyle = UITextBorderStyleNone;
    confirmPWT.secureTextEntry = YES;
    confirmPWT.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPWT.textColor = [UIColor blackColor];
    confirmPWT.adjustsFontSizeToFitWidth = YES;
    
    for (int i = 0; i < hCout; i++) {
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(pw.frame), 155 + i * 50, WIDTH_SCREEN - 40, 1)];
//        lineImg.backgroundColor = GRAY_BG;
        lineImg.image = [UIImage imageNamed:@"huixian_dl"];
        [self.view addSubview:lineImg];
    }
 
    completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(confirmPWT.frame) + 70, WIDTH_SCREEN - 40, 45)];
    [self.view addSubview:completeBtn];
    completeBtn.backgroundColor =  [UIColor redColor];
    completeBtn.titleLabel.font = XNFont(18.0);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)textFieldDidChange:(UITextField *)tx {
    
}

- (void)completeBtnButtonPressed:(UIButton *)btn {
    //完成重置密码，返回到首页
    if (![pwT.text isEqualToString:confirmPWT.text] || pwT.text.length == 0 || confirmPWT.text.length == 0) {
        [ZHProgressHUD showMessage:@"输入的密码不一致or没有填写密码" inView:self.view];
        return;
    }
    
    if (orPWT.text.length != 0 && pwT.text.length != 0) {
        
        NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
        NSDictionary *dataDict = [NSDictionary dictionaryWithDictionary:[userDict valueForKey:@"data"]];
        
        NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",[dataDict valueForKey:@"user_id"],@"user_id",orPWT.text,@"past_pwd",pwT.text,@"new_pwd", nil];
        
        [self requestUpdatePasswordWithUrlstring:Update_PW_Url withParame:requestDict];
    }
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)titleName {
    if (_titleName == nil) {
        _titleName = @"重置密码";
    }
    return _titleName;
}

#pragma mark - 网络请求

- (void)requestUpdatePasswordWithUrlstring:(NSString *)urlStr withParame:(NSDictionary *)parame {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"修改成功" inView:self.view];
            
            [NPYSaveGlobalVariable saveValueAtLocal:pwT.text withKey:LocalPassword];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            //用户账号不存在
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
