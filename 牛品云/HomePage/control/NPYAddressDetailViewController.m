//
//  NPYAddAddressViewController.m
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAddressDetailViewController.h"
#import "NPYBaseConstant.h"
#import "SelctCityView.h"

#define UPDATA_ADDRESS_URL @"/index.php/app/User/set_address"

@interface NPYAddressDetailViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate> {
    UITableView     *mainTView;
    SelctCityView   *selectCityView;
    
    NSArray *cellTextes;
    UITextField *editTF;
    UITextView *addressTView;
    
    UIButton *defaultBtn;
    
    NSMutableArray *dataArr;
    
}

@end

@implementation NPYAddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_isDefault == nil) {
        _isDefault = @"0";
    }
    
    cellTextes = @[@"收货人",@"联系电话",@"所在地区",@"详细地址"];
    if (_dataDict == nil) {
        _dataDict = [NSMutableDictionary new];
        [_dataDict setValue:@"姓名" forKey:@"name"];
        [_dataDict setValue:@"手机号" forKey:@"phone"];
        [_dataDict setValue:@"选择城市" forKey:@"city"];
        [_dataDict setValue:@"详细地址" forKey:@"address"];
    }
    if (_isEdit) {
        dataArr = [NSMutableArray arrayWithObjects:[_dataDict valueForKey:@"name"],[_dataDict valueForKey:@"phone"],[_dataDict valueForKey:@"city"],[_dataDict valueForKey:@"address"], nil];
        
    } else {
        dataArr = [NSMutableArray new];
        
    }
    
    
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)navigationViewLoad {
    self.navigationItem.title = _isEdit ? @"编辑地址" : @"新增地址";    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"保存" forState:0];
    [rightMesg setTitleColor:XNColor(17, 17, 17, 1) forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void) mainViewLoad {
    mainTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStyleGrouped];
    [self.view addSubview:mainTView];
    
    mainTView.backgroundColor = GRAY_BG;
    mainTView.delegate = self;
    mainTView.dataSource = self;
    mainTView.showsVerticalScrollIndicator = NO;
    
//    __weak typeof(self) _weakSelf = self;
    selectCityView = [[SelctCityView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN, WIDTH_SCREEN, 300) andMyCitySelect:^(NSString *selectCity) {
        UITextField *tf = [self.view viewWithTag:1000];
        tf.text = selectCity;
    }];
    [self.view addSubview:selectCityView];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isEdit) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section == 0) {
            
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
            nameL.text = cellTextes[indexPath.row];
            nameL.textColor = XNColor(17, 17, 17, 1);
            nameL.font = [UIFont systemFontOfSize:16.0];
            nameL.center = CGPointMake(CGRectGetMidX(nameL.frame), CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:nameL];
            
            editTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame), CGRectGetMinY(nameL.frame), WIDTH_SCREEN - 140, 20)];
            editTF.placeholder = cellTextes[indexPath.row];
            editTF.text = dataArr.count < 4 ? @"" : dataArr[indexPath.row];
            editTF.tag = indexPath.row + 100;
            editTF.delegate = self;
            editTF.returnKeyType = UIReturnKeyDone;
            editTF.textColor = XNColor(17, 17, 17, 1);
            editTF.font = [UIFont systemFontOfSize:16.0];
            editTF.center = CGPointMake(CGRectGetMidX(editTF.frame), CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:editTF];
            editTF.adjustsFontSizeToFitWidth = YES;
            editTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            if (indexPath.row == 2) {
                editTF.userInteractionEnabled = NO;
                editTF.tag = 1000;
                mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (indexPath.row == 3) {
                addressTView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame), 0, WIDTH_SCREEN - 140, 30)];
                addressTView.text = dataArr.count < 4 ? @"" : dataArr[indexPath.row];
                addressTView.textColor = XNColor(17, 17, 17, 1);
                addressTView.font = [UIFont systemFontOfSize:16.0];
                addressTView.textAlignment = NSTextAlignmentLeft;
                addressTView.center = CGPointMake(CGRectGetMidX(addressTView.frame), CGRectGetMidY(mainCell.frame));
                addressTView.showsVerticalScrollIndicator = NO;
                [mainCell addSubview:addressTView];
                
                [editTF removeFromSuperview];
                editTF = nil;
            }
            
        }
        
        if (indexPath.section == 1) {
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
            nameL.text = @"设置默认地址";
            nameL.textColor = XNColor(17, 17, 17, 1);
            nameL.font = [UIFont systemFontOfSize:16.0];
            nameL.center = CGPointMake(CGRectGetMidX(nameL.frame), CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:nameL];
            
            defaultBtn = [[UIButton alloc] init];
            defaultBtn.frame = CGRectMake(WIDTH_SCREEN - 37, 39 / 2, 21, 21);
            defaultBtn.selected = NO;
            [defaultBtn setImage:[UIImage imageNamed:@"xuanze_fou"] forState:UIControlStateNormal];
            [defaultBtn setImage:[UIImage imageNamed:@"xuanze_shi"] forState:UIControlStateSelected];
            [defaultBtn addTarget:self action:@selector(defaultButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            if ([_isDefault intValue] == 1) {
                [defaultBtn setSelected:YES];
            }
            [mainCell addSubview:defaultBtn];
        }
        
        if (indexPath.section == 2) {
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 20)];
            nameL.text = @"删除地址";
            nameL.textColor = XNColor(248, 21, 21, 1);
            nameL.textAlignment = NSTextAlignmentCenter;
            nameL.font = [UIFont systemFontOfSize:18.0];
            nameL.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:nameL];
        }
    }
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        //城区选择
        UITextField *tf = [self.view viewWithTag:100];
        [tf resignFirstResponder];
        UITextField *tf1 = [self.view viewWithTag:101];
        [tf1 resignFirstResponder];
        UITextField *tf2 = [self.view viewWithTag:102];
        [tf2 resignFirstResponder];
        [addressTView resignFirstResponder];
        
        [UIView animateWithDuration:0.5 animations:^{
            selectCityView.frame = CGRectMake(0, HEIGHT_SCREEN - 300, WIDTH_SCREEN, 300);
        }];
    }
    
    if (indexPath.section == 2) {
        //删除地址
        if (self.delegate && [self.delegate respondsToSelector:@selector(passDeleteIndexToParentView:)]) {
            [self.delegate passDeleteIndexToParentView:self.index];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([mainTView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([mainTView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    
    if (textField.tag == 100) {
        [_dataDict setValue:textField.text forKey:@"name"];
    }
    
    if (textField.tag == 101) {
        [_dataDict setValue:textField.text forKey:@"phone"];
    }
    
    if (textField.tag == 102) {
        [_dataDict setValue:textField.text forKey:@"city"];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [_dataDict setValue:textView.text forKey:@"address"];
    
}

- (void)rightMessageButtonPressed:(UIButton *)btn {
    //编辑后保存
    UITextField *tf = [self.view viewWithTag:100];
   
    UITextField *tf1 = [self.view viewWithTag:101];
    
    UITextField *tf3 = [self.view viewWithTag:1000];
    
    if (tf.text.length <=0 || tf1.text.length <= 0 || tf3.text.length <= 0 || addressTView.text.length <=0) {
        [ZHProgressHUD showMessage:@"填写完整信息" inView:self.view];
        return;
    }
    
    _dataDict = [NSMutableDictionary new];
    
    [_dataDict setValue:tf.text forKey:@"name"];
    [_dataDict setValue:tf1.text forKey:@"phone"];
    [_dataDict setValue:tf3.text forKey:@"city"];
    [_dataDict setValue:addressTView.text forKey:@"address"];
    
    NSString *tpye = @"";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passValueToParentView:andValue:)]) {
        if (self.isEdit) {
            [self.delegate passValueToParentView:self.index andValue:_dataDict];
            tpye = @"update";
            
        } else {
            [self.delegate passValueToParentView:-1 andValue:_dataDict];
            tpye = @"add";
            
        }
        
    }
    
    NSString *province = [tf3.text componentsSeparatedByString:@"-"][0];
    
    NSString *city = [tf3.text componentsSeparatedByString:@"-"][1];
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",self.address_id,@"address_id",tpye,@"type",tf.text,@"receiver",tf1.text,@"phone",city,@"city",province,@"province",addressTView.text,@"detailed",_isDefault,@"default", nil];
    
    [self requestUpdataAddressInfoWithUrlString:UPDATA_ADDRESS_URL withParames:request];
    
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//设置默认地址
- (void)defaultButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _isDefault = @"1";
        
    } else {
        _isDefault = @"0";
        
    }
}

- (void)requestUpdataAddressInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            //失败
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
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
