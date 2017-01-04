//
//  NPYRetrievePWViewController.m
//  牛品云
//
//  Created by Eric on 16/11/16.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYRetrievePWViewController.h"
#import "NPYBaseConstant.h"
#import "NPYRetrievePWDetailViewController.h"

@interface NPYRetrievePWViewController () {
    UITextField *captchaNumber;
    UIButton *nextBtn,*verifyBtn;
}

@property (nonatomic, strong) NPYRetrievePWDetailViewController *detailVC;

@end

@implementation NPYRetrievePWViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"找回密码";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self mainViewLoad];
}

- (void)mainViewLoad {
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, WIDTH_SCREEN, 20)];
    [self.view addSubview:titleL];
    
    titleL.text = [NSString stringWithFormat:@"*确保%@号码能接受短信",self.phoneStr];
    titleL.font = XNFont(16.0);
    titleL.textColor = XNColor(51, 51, 51, 1);
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.attributedText = [self attributedStringWithString:titleL.text];
    
    captchaNumber  = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleL.frame) + 60, WIDTH_SCREEN - 40, 20)];
    [self.view addSubview:captchaNumber];
    captchaNumber.tag = 100011;
    captchaNumber.placeholder = @"请输入短信验证码";
    captchaNumber.textColor = XNColor(51, 51, 51, 1);
    [captchaNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    captchaNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    verifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 120, CGRectGetMinY(captchaNumber.frame), 100, 20)];
    [self.view addSubview:verifyBtn];
    //    verifyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn setTitleColor:XNColor(51, 51, 51, 1) forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(verifyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *hLine = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(verifyBtn.frame) - 10, CGRectGetMinY(verifyBtn.frame) + 2.5 , 1, CGRectGetHeight(verifyBtn.frame) - 5)];
//    hLine.backgroundColor = GRAY_BG;
    hLine.image = [UIImage imageNamed:@"40hui_dl"];
    [self.view addSubview:hLine];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(captchaNumber.frame), CGRectGetMaxY(captchaNumber.frame) + 10, WIDTH_SCREEN - 40, 1)];
//    lineImg.backgroundColor = GRAY_BG;
    lineImg.image = [UIImage imageNamed:@"huixian_dl"];
    [self.view addSubview:lineImg];
    
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(captchaNumber.frame) + 50, WIDTH_SCREEN - 40, 40)];
    [self.view addSubview:nextBtn];
    NSString *imgName = captchaNumber.text.length > 0 ? @"hongikuang_dl" : @"huikuang_dl";
    UIImage *bgImg = [UIImage imageNamed:imgName];
    [nextBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    nextBtn.userInteractionEnabled = captchaNumber.text.length > 3 ? YES : NO;
    nextBtn.titleLabel.font = XNFont(18.0);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFieldDidChange:(UITextField *)tx {
    //验证手机号、验证码
    if (tx.tag == 100011) {
        NSString *imgName = captchaNumber.text.length > 0 ? @"hongikuang_dl" : @"huikuang_dl";
        UIImage *bgImg = [UIImage imageNamed:imgName];
        [nextBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
        nextBtn.userInteractionEnabled = tx.text.length > 3 ? YES : NO;
    }
    
}

- (void)verifyButtonPressed:(UIButton *)btn {
    //发送验证码
    //验证手机号码格式是否正确
    if ([self valiMobile:self.phoneStr]) {
        NSLog(@"格式正确，发送验证码...");
    } else {
        [ZHProgressHUD showMessage:@"请填写正确手机号码" inView:self.view];
    }
    
}

- (void)nextButtonPressed:(UIButton *)btn {
    //下一步
    self.detailVC = [[NPYRetrievePWDetailViewController alloc] init];
    [self.navigationController pushViewController:self.detailVC animated:YES];
}

#pragma mark - 不同大小颜色的字符串

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)aStr {
    //下面是要变色的字符串  需要NSMutableAttributedString字体
    NSMutableAttributedString*AttributedStr = [[NSMutableAttributedString alloc]initWithString:aStr];
    //下面是要变色的字符串
    NSString*nsstring = [NSString stringWithFormat:@"%@",AttributedStr];
    // 取出字符串长度做循环
    for(int i =0; i < [nsstring length]; ++i) {
        // 取出第几位
        int a = [nsstring characterAtIndex:i];
        //判断是否为数字
        if(isdigit(a)){
            //是
            [AttributedStr addAttribute:NSFontAttributeName
             
                                 value:[UIFont systemFontOfSize:16.0]
             
                                 range:NSMakeRange(i,1)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                 value:XNColor(0, 122, 255, 1)
             
                                 range:NSMakeRange(i,1)];
            
        }else {
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:16.0]
             
                                  range:NSMakeRange(0,1)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor redColor]
             
                                  range:NSMakeRange(0,1)];
            
            
            
        }
        
    }
    
    return AttributedStr;
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
