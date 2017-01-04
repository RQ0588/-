//
//  NPYAddressViewController.m
//  牛品云
//
//  Created by Eric on 16/11/10.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAddressViewController.h"
#import "NPYBaseConstant.h"
#import "NPYAddressTableViewCell.h"
#import "NPYAddressDetailViewController.h"
#import "NPYAddressModel.h"

#define GET_ADDRESS_URL @"/index.php/app/User/get_address"

@interface NPYAddressViewController () <UITableViewDelegate,UITableViewDataSource,editButtonPressedEventDelegate,passValueToBackDeleagate> {
    UITableView *mainTV;
    NSMutableArray *addressArray;
}

@property (nonatomic, strong) NPYAddressDetailViewController    *addressInfoVC;

@end

@implementation NPYAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    addressArray = [NSMutableArray new];
    
    [self navigationLoad];
    
    [self mainViewLoad];
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id", nil];
    
    [self requestAddressInfoWithUrlString:GET_ADDRESS_URL withParames:request];
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

- (void)navigationLoad {
    self.navigationItem.title = @"选择地址";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    //右侧消息按钮
    UIButton *rightMesg = [[UIButton alloc] init];
    [rightMesg setFrame:CGRectMake(0, 0, 18, 18)];
    [rightMesg setImage:[UIImage imageNamed:@"tianjia_gouwu"] forState:UIControlStateNormal];
    [rightMesg addTarget:self action:@selector(rightMessageButtonPressed:) forControlEvents:7];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightMesg];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)mainViewLoad {
    mainTV = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:mainTV];
    
    mainTV.backgroundColor = GRAY_BG;
    mainTV.delegate = self;
    mainTV.dataSource = self;
    mainTV.showsVerticalScrollIndicator = NO;
    mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
    NPYAddressTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[NPYAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    mainCell.model = addressArray[indexPath.row];
    mainCell.index = indexPath.row;
    mainCell.delegate = self;
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    mainCell.backgroundColor = [UIColor clearColor];
    
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popValue:)]) {
        NPYAddressModel *model = addressArray[indexPath.row];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model.receiver,@"name",model.phone,@"phone",model.detailed,@"address",model.city,@"city", nil];
        
        [self.delegate popValue:dict];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - -

- (void)passValueToParentView:(NSInteger)index andValue:(NSDictionary *)dic {
    NPYAddressModel *model = [NPYAddressModel mj_objectWithKeyValues:dic];
    if (index == -1) {
        
        [addressArray insertObject:model atIndex:0];
        
    } else {
        
        [addressArray replaceObjectAtIndex:index withObject:model];
        
    }
    
    [mainTV reloadData];
}

- (void)passDeleteIndexToParentView:(NSInteger)index {
    [addressArray removeObjectAtIndex:index];
    
    [mainTV reloadData];
}

- (void)passCellIndex:(NSInteger)index {
    self.addressInfoVC = [[NPYAddressDetailViewController alloc] init];
    self.addressInfoVC.isEdit = YES;
    self.addressInfoVC.delegate = self;
    self.addressInfoVC.index = index;
    
    NPYAddressModel *model = addressArray[index];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model.receiver,@"name",model.phone,@"phone",[NSString stringWithFormat:@"%@-%@",model.province,model.city],@"city",model.detailed,@"address", nil];
    self.addressInfoVC.dataDict = [dict copy];
    self.addressInfoVC.address_id = model.address_id;
    self.addressInfoVC.isDefault = model.defaults;
    
    [self.navigationController pushViewController:self.addressInfoVC animated:YES];
}

- (void)rightMessageButtonPressed:(UIButton *)btn {
//    NSLog(@"添加地址按钮点击了...");
    self.addressInfoVC = [[NPYAddressDetailViewController alloc] init];
    self.addressInfoVC.isEdit = NO;
    self.addressInfoVC.delegate = self;
    self.addressInfoVC.index = -1;
    [self.navigationController pushViewController:self.addressInfoVC animated:YES];
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 

- (void)requestAddressInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            
            [addressArray removeAllObjects];
            
            NSArray *tpArr = dataDict[@"data"];
            
            for (int i = 0; i < tpArr.count; i++) {
                NSDictionary *dict = tpArr[i];
                NPYAddressModel *model = [NPYAddressModel mj_objectWithKeyValues:dict];
                
                [addressArray addObject:model];
            }
            
            
            [mainTV reloadData];
            
        } else {
            //失败
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - -

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
