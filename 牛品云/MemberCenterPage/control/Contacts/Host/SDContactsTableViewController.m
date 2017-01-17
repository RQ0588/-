//
//  SDContactsTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDContactsTableViewController.h"
#import "SDContactsSearchResultController.h"

#import "SDContactModel.h"
//#import "SDAnalogDataGenerator.h"

#import "SDContactsTableViewCell.h"

#import "GlobalDefines.h"

#import "NPYBaseConstant.h"

#import "NPYCIFilterViewController.h"
#import "NPYSweepViewController.h"
#import "NPYFriendMomentViewController.h"

@interface SDContactsTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;

@end

@implementation SDContactsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"好友";
    
    self.tableView.backgroundColor = GRAY_BG;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:[SDContactsSearchResultController new]];
//    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    
//    UISearchBar *bar = self.searchController.searchBar;
//    bar.barStyle = UIBarStyleDefault;
//    bar.translucent = YES;
//    bar.barTintColor = Global_mainBackgroundColor;
//    bar.tintColor = Global_tintColor;
//    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
//    view.layer.borderColor = Global_mainBackgroundColor.CGColor;
//    view.layer.borderWidth = 1;
//    
//    bar.layer.borderColor = [UIColor redColor].CGColor;
//    
//    bar.showsBookmarkButton = YES;
//    [bar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
//    bar.delegate = self;
//    CGRect rect = bar.frame;
//    rect.size.height = 44;
//    bar.frame = rect;
//    self.tableView.tableHeaderView = bar;
    self.tableView.rowHeight = [SDContactsTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    [self genDataWithCount:30];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    self.tableView.separatorColor = GRAY_BG;
    self.tableView.sectionHeaderHeight = 25;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSString *urlStr = @"/index.php/app/Moments/get_friends";
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id", nil];
    [self requestMomentsFriendsInfoWithUrlString:urlStr withParames:requestDict];
    
}

- (void)loadNewData {
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSString *urlStr = @"/index.php/app/Moments/get_friends";
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id", nil];
    [self requestMomentsFriendsInfoWithUrlString:urlStr withParames:requestDict];
    
}

- (void)genDataWithCount:(NSInteger)count
{
    
    NSArray *xings = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"楚",@"卫",@"蒋",@"沈",@"韩",@"杨"];
    NSArray *ming1 = @[@"大",@"美",@"帅",@"应",@"超",@"海",@"江",@"湖",@"春",@"夏",@"秋",@"冬",@"上",@"左",@"有",@"纯"];
    NSArray *ming2 = @[@"强",@"好",@"领",@"亮",@"超",@"华",@"奎",@"海",@"工",@"青",@"红",@"潮",@"兵",@"垂",@"刚",@"山"];
    
    for (int i = 0; i < count; i++) {
        NSString *name = xings[arc4random_uniform((int)xings.count)];
        NSString *ming = ming1[arc4random_uniform((int)ming1.count)];
        name = [name stringByAppendingString:ming];
        if (arc4random_uniform(10) > 3) {
            NSString *ming = ming2[arc4random_uniform((int)ming2.count)];
            name = [name stringByAppendingString:ming];
        }
        SDContactModel *model = [SDContactModel new];
        model.name = name;
//        model.imageName = [SDAnalogDataGenerator randomIconImageName];
        [self.dataArray addObject:model];
    }
    
    [self setUpTableSection];
}

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (SDContactModel *model in self.dataArray) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    
    [newSectionArray removeObjectsInArray:temp];
    
    NSMutableArray *operrationModels = [NSMutableArray new];
    
    NSArray *dicts = @[@{@"name" : @"我的二维码", @"imageName" : @"erweima_pyq"},
                       @{@"name" : @"扫一扫加好友", @"imageName" : @"jiahaoyou_pyq"}];
    for (NSDictionary *dict in dicts) {
        SDContactModel *model = [SDContactModel new];
        model.name = dict[@"name"];
        model.imageName = dict[@"imageName"];
        [operrationModels addObject:model];
    }
    
    [newSectionArray insertObject:operrationModels atIndex:0];
    [self.sectionTitlesArray insertObject:@"" atIndex:0];
    
    self.sectionArray = newSectionArray;
    
    [self.tableView reloadData];
}

#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SDContacts";
    SDContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SDContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    SDContactModel *model = self.sectionArray[section][row];
    cell.model = model;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitlesArray objectAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //我得二维码
//        NSLog(@"我的二维码%i-%i",indexPath.section,indexPath.row);
        NPYCIFilterViewController *ciFVC = [[NPYCIFilterViewController alloc] init];
        [self.navigationController pushViewController:ciFVC animated:YES];
        
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        //扫一扫
//        NSLog(@"扫一扫%i-%i",indexPath.section,indexPath.row);
        NPYSweepViewController *sweepVC = [[NPYSweepViewController alloc] init];
        [self.navigationController pushViewController:sweepVC animated:YES];
        
    }
    
    if (indexPath.section != 0) {
        NSDictionary *userDic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
        NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDic[@"data"]];
        
        SDContactModel *model = self.sectionArray[indexPath.section][indexPath.row];
        NPYFriendMomentViewController *friendMomentVC = [[NPYFriendMomentViewController alloc] init];
        friendMomentVC.sign = [userDic valueForKey:@"sign"];
        friendMomentVC.user_id = userModel.user_id;
        friendMomentVC.friends_user_id = model.friend_id;
        friendMomentVC.friendName = model.name;
        [self.navigationController pushViewController:friendMomentVC animated:YES];
    }
    
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,14,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = XNColor(149, 149, 153, 1);
    
}

- (void)backItem:(UIButton *)sender {
    [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewControllerWithIdentifier:@"NPYMain"];
}

- (void)requestMomentsFriendsInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            
            [self.dataArray removeAllObjects];
            
            NSArray *tpArr = dataDict[@"data"];
            
            for (int i = 0; i < tpArr.count; i++) {
                NSDictionary *tpDict = tpArr[i];
                SDContactModel *model = [SDContactModel new];
                model.name = [tpDict valueForKey:@"friend_name"];
                model.firend_img = [tpDict valueForKey:@"friend_img"];
                model.friend_id = [tpDict valueForKey:@"friend_user_id"];
                [self.dataArray addObject:model];
            }
            [self setUpTableSection];
            
            [self.tableView.mj_header endRefreshing];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];

}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}



@end
