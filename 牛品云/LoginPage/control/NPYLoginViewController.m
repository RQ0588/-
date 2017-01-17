//
//  NPYLoginViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYLoginViewController.h"
#import "NPYBaseConstant.h"
#import "NPYRegisterViewController.h"
#import "NPYRetrievePWViewController.h"
#import "NPYLoginMode.h"

#define LoginUrl    @"/app/login/index"

@interface NPYLoginViewController () {
    UITextField *name,*pw;
    UIButton *loginBtn;
}

@property (nonatomic, strong) NPYRegisterViewController     *registerVC;
@property (nonatomic, strong) NPYRetrievePWViewController   *retrievePWVC;

@property (nonatomic, strong) NPYLoginMode *model;

@end

@implementation NPYLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    if (userDict) {
        _model = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
        _model.r = userDict[@"r"];
        _model.sign = userDict[@"sign"];
    }
    
    [self navigateViewLoad];
    
    [self subViewLoad];
}

- (void)navigateViewLoad {
    self.navigationItem.title = @"登录牛品云";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)subViewLoad {
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 60, 20)];
    [self.view addSubview:nameL];
    nameL.text = @"账号";
    nameL.font = XNFont(17.0);
    nameL.textColor = XNColor(0, 0, 0, 1);
    
    UILabel *pwL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + 30, CGRectGetWidth(nameL.frame), CGRectGetHeight(nameL.frame))];
    [self.view addSubview:pwL];
    pwL.text = @"密码";
    pwL.font = XNFont(17.0);
    pwL.textColor = [UIColor blackColor];
    
    name = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame), CGRectGetMinY(nameL.frame), WIDTH_SCREEN - 40 - CGRectGetWidth(nameL.frame) - 10, CGRectGetHeight(nameL.frame))];
    [self.view addSubview:name];
    name.text = _model.user_phone;
    name.font = XNFont(17.0);
    name.placeholder = @"请输入手机号";
    name.textColor = [UIColor blackColor];
    name.borderStyle = UITextBorderStyleNone;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    [name addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [name becomeFirstResponder];
    name.adjustsFontSizeToFitWidth = YES;
    
    pw = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMinY(pwL.frame), CGRectGetWidth(name.frame), CGRectGetHeight(name.frame))];
    [self.view addSubview:pw];
    pw.text = @"";
    pw.font = XNFont(17.0);
    pw.placeholder = @"请输入密码";
    pw.borderStyle = UITextBorderStyleNone;
    pw.secureTextEntry = YES;
    pw.clearButtonMode = UITextFieldViewModeWhileEditing;
    pw.textColor = [UIColor blackColor];
    pw.adjustsFontSizeToFitWidth = YES;
    
    for (int i = 0; i < 2; i++) {
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameL.frame), CGRectGetMaxY(nameL.frame) + i * 50 + 15, WIDTH_SCREEN - 40, 1)];
//        lineImg.backgroundColor = GRAY_BG;
        lineImg.image = [UIImage imageNamed:@"huixian_dl"];
        [self.view addSubview:lineImg];
    }
    
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(pwL.frame) + 50, WIDTH_SCREEN - 40, 40)];
    [self.view addSubview:loginBtn];
    
    NSString *imgName = name.text.length > 0 ? @"hongikuang_dl" : @"huikuang_dl";
    UIImage *bgImg = [UIImage imageNamed:imgName];
    [loginBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    loginBtn.userInteractionEnabled = name.text.length > 0 ? YES : NO;
    loginBtn.titleLabel.font = XNFont(18.0);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginBtn.frame) + 10, 100, 30)];
    [self.view addSubview:registerBtn];
    [registerBtn setTitle:@"帐号注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [registerBtn addTarget:self action:@selector(registerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *retryPW = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 100, CGRectGetMinY(registerBtn.frame), 100, 30)];
    [self.view addSubview:retryPW];
    [retryPW setTitle:@"忘记密码" forState:UIControlStateNormal];
    [retryPW setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    retryPW.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [retryPW addTarget:self action:@selector(retryPWButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)textFieldDidChange:(UITextField *)tx {
    NSString *imgName = name.text.length > 0 ? @"hongikuang_dl" : @"huikuang_dl";
    UIImage *bgImg = [UIImage imageNamed:imgName];
    [loginBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    loginBtn.userInteractionEnabled = tx.text.length > 0 ? YES : NO;
    
}

//登录 (http://npy.cq-vip.com/app/login/index?data={"name":"13133333333","pwd":"123456"})
- (void)loginButtonPressed:(UIButton *)btn {
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:name.text,@"name",pw.text,@"pwd", nil];
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:requestDic] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,LoginUrl] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"登录成功" inView:self.view];
            NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dataDict[@"data"]];
            model.r = dataDict[@"r"];
            model.sign = dataDict[@"sign"];
            
            [NPYSaveGlobalVariable saveValueAtLocal:dataDict withKey:LoginData_Local];
            [NPYSaveGlobalVariable saveValueAtLocal:dataDict[@"r"] withKey:LoginState];
            
            //发送别名给阿里
            [CloudPushSDK addAlias:model.user_id withCallback:^(CloudPushCallbackResult *res) {
                if (res.success) {
                    NSLog(@"success");
                }
            }];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            //用户账号不存在
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

//注册
- (void)registerButtonPressed:(UIButton *)btn {
    self.registerVC = [[NPYRegisterViewController alloc] init];
    [self.navigationController pushViewController:self.registerVC animated:YES];
    
}
//忘记密码
- (void)retryPWButtonPressed:(UIButton *)btn {
    if (![self valiMobile:name.text] || [name.text isKindOfClass:[NSNull class]]) {
        [ZHProgressHUD showMessage:@"请填写正确手机号码" inView:self.view];
        return;
    }
    
    self.retrievePWVC = [[NPYRetrievePWViewController alloc] init];
    self.retrievePWVC.phoneStr = name.text;
    [self.navigationController pushViewController:self.retrievePWVC animated:YES];
    
}

#pragma mark - 判断手机号码格式是否正确

- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)backButtonPressed:(UIButton *)btn {
    //
    [self.navigationController popToRootViewControllerAnimated:YES];
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
