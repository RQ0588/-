//
//  NPYTicketViewController.m
//  牛品云
//
//  Created by Eric on 17/1/4.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "NPYTicketViewController.h"
#import "NPYTicketTableViewCell.h"
#import "NPYTicketModel.h"

@interface NPYTicketViewController () <UITableViewDelegate, UITableViewDataSource> {
    UILabel *timeL;
    NSMutableArray *mListArr;
}

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *mDataArr;

@end

@implementation NPYTicketViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)backItem:(UIButton *)sender {
    if (self.selectedIndex && self.delegate && [self.delegate respondsToSelector:@selector(selectedTicketAtIndexPath:withTicketInfo:)]) {
        NPYTicketModel *model = mListArr[self.selectedIndex.row];
        [self.delegate selectedTicketAtIndexPath:self.selectedIndex withTicketInfo:model];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = GRAY_BG;
    
    NSString *urlStr = @"";
    NSDictionary *request = [NSDictionary new];
    
    if (_isTicketManage) {
        self.navigationItem.title = @"券管理";
        
        
    } else {
        self.navigationItem.title = @"选择优惠券";
        urlStr = @"/index.php/app/Buy/get_coupon";
        request = [NSDictionary dictionaryWithObjectsAndKeys:self.sign,@"sign",self.user_id,@"user_id",self.shop_id,@"shop_id",self.money,@"money", nil];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.view addSubview:self.mainTableView];
    
    
    [self requestTicketInfoWithUrlString:urlStr withParames:request];
}

#pragma mark - UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isTicketManage) {
        //券管理
//        return self.mDataArr.count;
        return 3;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isTicketManage) {
        //券管理
        return 2;
    }
    return mListArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = GRAY_BG;
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_SCREEN, 30)];
    timeView.backgroundColor = [UIColor whiteColor];
    
    timeL = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH_SCREEN - 50) / 2, 15, 50, 15)];
    timeL.font = XNFont(12.0);
    timeL.textColor = [UIColor whiteColor];
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.layer.cornerRadius = 3.0;
    timeL.layer.masksToBounds = YES;
    timeL.backgroundColor = XNColor(200, 200, 200, 1);
    timeL.text = [self calutTimeFromeTime:@"1510329600" withType:2];
    [timeView addSubview:timeL];
    
    if (_isTicketManage) {
        [headerView addSubview:timeView];
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NPYTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYTicketTableViewCell" owner:nil options:nil] firstObject];
    }
    
    if (_isTicketManage) {
        cell.userInteractionEnabled = NO;
        cell.selectedImg.hidden = YES;
        
    } else {
        cell.ticketModel = mListArr[indexPath.row];
        
        if (_isSelectTicket && self.selectedIndex.row == indexPath.row) {
            cell.selectedImg.hidden = NO;
            
        } else {
             cell.selectedImg.hidden = YES;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NPYTicketTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedImg.hidden = NO;
    
    if (self.selectedIndex != indexPath) {
        NPYTicketTableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndex];
        oldSelectedCell.selectedImg.hidden = YES;
        
    }
    
    self.selectedIndex = indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isTicketManage) {
        return 40;
    }
    
    return 10;
}

#pragma mark - 

- (void)requestTicketInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            
            mListArr = [NSMutableArray new];
            
            for (NSDictionary *tpDict in dataDict[@"data"]) {
                NPYTicketModel *model = [NPYTicketModel mj_objectWithKeyValues:tpDict];
                [mListArr addObject:model];
                
            }
            
            [self.mainTableView reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
          
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - 

- (NSMutableArray *)mDataArr {
    if (_mDataArr == nil) {
        _mDataArr = [NSMutableArray new];
        
    }
    
    return _mDataArr;
}

- (NSString *)calutTimeFromeTime:(NSString *)timeStr withType:(int)type {
    NSString *stringTime = @"";
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (type == 1) {
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
        
    }
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStr intValue]];
    
    stringTime = [dateFormatter stringFromDate:timeDate];
    
    return stringTime;
}

- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        if (_isTicketManage) {
            _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 1) style:UITableViewStyleGrouped];
            
        } else {
            _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 1) style:UITableViewStylePlain];
            
        }
        
        _mainTableView.estimatedRowHeight = 100;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.backgroundColor = GRAY_BG;
        _mainTableView.separatorColor = [UIColor clearColor];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableView;
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
