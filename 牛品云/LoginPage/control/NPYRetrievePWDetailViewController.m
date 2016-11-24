//
//  NPYRetrievePWDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/11/16.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYRetrievePWDetailViewController.h"
#import "NPYBaseConstant.h"

@interface NPYRetrievePWDetailViewController () {
    UITextField *pwT,*confirmPWT;
    UIButton *completeBtn;
}

@end

@implementation NPYRetrievePWDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"重置密码";
    
    [self mainViewLoad];
}

- (void)mainViewLoad {
    UILabel *pw = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 80, 20)];
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
    
    for (int i = 0; i < 2; i++) {
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(pw.frame), CGRectGetMaxY(pw.frame) + i * 50 + 15, WIDTH_SCREEN - 40, 1)];
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
    //完成重置密码，返回到首页
    if (![pwT.text isEqualToString:confirmPWT.text] || pwT.text.length == 0 || confirmPWT.text.length == 0) {
        [ZHProgressHUD showMessage:@"输入的密码不一致or没有填写密码" inView:self.view];
        return;
    }
    
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
