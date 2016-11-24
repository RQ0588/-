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

@interface NPYAddressDetailViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView     *mainTView;
    SelctCityView   *selectCityView;
    
    NSArray *cellTextes;
    UITextField *editTF;
    UITextView *addressTView;
}

@end

@implementation NPYAddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellTextes = @[@"收货人",@"联系电话",@"所在地区",@"详细地址"];
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)navigationViewLoad {
    self.navigationItem.title = _isEdit ? @"编辑地址" : @"新增地址";    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 50, 20)];
    [rightMesg setTitle:@"保存" forState:0];
    [rightMesg setTitleColor:[UIColor grayColor] forState:0];
    rightMesg.titleLabel.font = [UIFont systemFontOfSize:15.0];
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
        
        NSArray *textes = @[@"牛品云",@"13962111234",@"江苏苏州高新区",@"苏州高新区科技城致远大厦"];
        
        if (indexPath.section == 0) {
            
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
            nameL.text = cellTextes[indexPath.row];
            nameL.textColor = [UIColor blackColor];
            nameL.font = [UIFont systemFontOfSize:15.0];
            nameL.center = CGPointMake(CGRectGetMidX(nameL.frame), CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:nameL];
            
            editTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame), CGRectGetMinY(nameL.frame), WIDTH_SCREEN - 140, 20)];
            editTF.text = textes[indexPath.row];
            editTF.textColor = [UIColor blackColor];
            editTF.font = [UIFont systemFontOfSize:15.0];
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
                addressTView.text = textes[indexPath.row];
                addressTView.textColor = [UIColor blackColor];
                addressTView.font = [UIFont systemFontOfSize:15.0];
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
            nameL.textColor = [UIColor blackColor];
            nameL.font = [UIFont systemFontOfSize:15.0];
            nameL.center = CGPointMake(CGRectGetMidX(nameL.frame), CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:nameL];
            
        }
        
        if (indexPath.section == 2) {
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 20)];
            nameL.text = @"删除地址";
            nameL.textColor = [UIColor redColor];
            nameL.textAlignment = NSTextAlignmentCenter;
            nameL.font = [UIFont systemFontOfSize:17.0];
            nameL.center = CGPointMake(WIDTH_SCREEN / 2, CGRectGetMidY(mainCell.frame));
            [mainCell addSubview:nameL];
        }
    }
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
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
        [UIView animateWithDuration:0.5 animations:^{
            selectCityView.frame = CGRectMake(0, HEIGHT_SCREEN - 300, WIDTH_SCREEN, 300);
        }];
    }
    
    if (indexPath.section == 2) {
        //删除地址
        if (self.delegate && [self.delegate respondsToSelector:@selector(passDeleteIndexToParentView:)]) {
            [self.delegate passDeleteIndexToParentView:0];
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

- (void)rightMessageButtonPressed:(UIButton *)btn {
    //编辑后保存
    if (self.delegate && [self.delegate respondsToSelector:@selector(passValueToParentView:andValue:)]) {
        [self.delegate passValueToParentView:0 andValue:Nil];
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
