//
//  NPYMsgDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYMsgDetailViewController.h"
#import "NPYBaseConstant.h"
#import "NPYMessageTableViewCell.h"
#import "NPYCouponMessageModel.h"
#import "NPYCommentsInfoViewController.h"

#define MessageUrl @"/index.php/app/Push/get"

@interface NPYMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource,MessageTableViewCellDelegate> {
    NSMutableArray *dataMArr;
    
}

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation NPYMsgDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.titleName;
    
    self.view.backgroundColor = GRAY_BG;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
     [self.view addSubview:self.mainTableView];
    
    NSDictionary *userDict =[NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    if ([self.titleName isEqualToString:@"通知消息"]) {
        NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",@"1",@"num", nil];
        [self requestCouponMessageWithUrlString:MessageUrl withParames:request];
        
    } else {
        NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",@"1",@"num",@"coupon",@"type", nil];
        [self requestCouponMessageWithUrlString:MessageUrl withParames:request];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titleName isEqualToString:@"通知消息"]) {
        NPYCouponMessageModel *model = dataMArr[indexPath.row];
        int selectedCellIndex;
        BOOL isHidenButton;
        switch (model.type) {
            case 1:
                selectedCellIndex = 1;
                break;
                
            case 2:
                selectedCellIndex = 0;
                isHidenButton = YES;
                break;
                
            case 3:
                selectedCellIndex = 0;
                break;
                
            case 5:
                selectedCellIndex = 1;
                break;
                
            case 6:
                selectedCellIndex = 0;
                isHidenButton = YES;
                break;
                
            default:
                break;
        }
        
        NPYMessageTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYMessageTableViewCell" owner:self options:nil] objectAtIndex:selectedCellIndex];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
    if ([self.titleName isEqualToString:@"优惠消息"]) {
        NPYMessageTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYMessageTableViewCell" owner:self options:nil] objectAtIndex:2];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NPYCouponMessageModel *model = dataMArr[indexPath.row];
    if (model.type == 2) {
        NPYCommentsInfoViewController *commentsVC = [[NPYCommentsInfoViewController alloc] init];
        commentsVC.moments_id = [NSString stringWithFormat:@"%i",model.moments_id];
        [self.navigationController pushViewController:commentsVC animated:YES];
    }
}

- (void)configCell:(NPYMessageTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NPYCouponMessageModel *model = dataMArr[indexPath.row];
    cell.cellIndex = (int)indexPath.row;
    cell.delegate = self;
    int selectedCellIndex;
    BOOL isHidenButton;
    NSString *urlStr = @"";
    switch (model.type) {
        case 1:
            selectedCellIndex = 1;
            cell.mesTitle.text = @"订单消息";
            urlStr = model.goods_img;
            cell.mesStateLabel.text = model.order_num;
            break;
            
        case 2:
            selectedCellIndex = 0;
            isHidenButton = YES;
            cell.mesTitle.text = @"朋友圈消息";
            break;
            
        case 3:
            selectedCellIndex = 0;
            cell.mesTitle.text = @"好友请求消息";
            break;
            
        case 5:
            selectedCellIndex = 1;
            cell.mesTitle.text = @"众筹订单消息";
            urlStr = model.many_img;
            cell.mesStateLabel.text = model.many_num;
            break;
            
        case 6:
            selectedCellIndex = 0;
            isHidenButton = YES;
            cell.mesTitle.text = @"好友请求消息";
            break;
            
        default:
            break;
    }
    
    cell.acceptBtn.hidden = isHidenButton;
    cell.refuseBtn.hidden = isHidenButton;
    cell.timeLabel.text = model.time;
    [cell.mesIcon sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"tongzhi_xiaoxi"]];
    cell.mesContent.text = model.data;
    
}

- (void)acceptButtonPressedWithCellIndex:(int)index {
    NPYCouponMessageModel *model = dataMArr[index];
    //接受
    NSDictionary *userDict =[NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",[NSString stringWithFormat:@"%i",model.push_id],@"push_id",[NSString stringWithFormat:@"%i",model.friend_id],@"friend_id", nil];
    
    NSString *urlStr = @"/index.php/app/Moments/set_friends_yes";
    
    [self requestFriendMessageWithUrlString:urlStr withParames:request];
}

- (void)refuseButtonPressedWithCellIndex:(int)index {
    NPYCouponMessageModel *model = dataMArr[index];
    //拒绝
    NSDictionary *userDict =[NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",[NSString stringWithFormat:@"%i",model.push_id],@"push_id",[NSString stringWithFormat:@"%i",model.friend_id],@"friend_id", nil];
    
    NSString *urlStr = @"/index.php/app/Moments/set_friends_no";
    
    [self requestFriendMessageWithUrlString:urlStr withParames:request];
}

- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = GRAY_BG;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 100;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _mainTableView;
}

- (void)requestCouponMessageWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            dataMArr  = [NSMutableArray new];
            
            NSArray *tp = dataDict[@"data"];
            for (int i = 0; i < tp.count; i++) {
                NPYCouponMessageModel *msgModel = [NPYCouponMessageModel mj_objectWithKeyValues:tp[i]];
                [dataMArr addObject:msgModel];
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

- (void)requestFriendMessageWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [self.mainTableView reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
