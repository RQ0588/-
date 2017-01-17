//
//  NPYDicDetailViewController.m
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicDetailViewController.h"
#import "NPYBaseConstant.h"
#import "NPYDicTopDetailTableViewCell.h"
#import "NPYDicMainDetailTableViewCell.h"
#import "NPYDicDetailExpandTableViewCell.h"
#import "NPYDicMainCellModel.h"
#import "NPYDicImgInfoViewController.h"
#import "NPYSupportViewController.h"

#define ExpandCount 1

#define ManyDetail_Url @"/index.php/app/Many/get_details"

@interface NPYDicDetailViewController () <UITableViewDelegate,UITableViewDataSource,lookImageInfoDelegate,DicMainDetailCellDelegate> {
    NSMutableArray *selecArr;
    BOOL isOpenCell;
    NSIndexPath *selectedIndexPath;
    NSIndexPath *oldSelectedIndexPath;
    
    NSUInteger CellCount;
    
    NSMutableArray *dataArr;
    
    int supporNumber;
}

@property (nonatomic, strong) NPYDicTopDetailTableViewCell      *topCell;
@property (nonatomic, strong) NPYDicMainDetailTableViewCell     *mainCell;
@property (nonatomic, strong) NPYDicMainCellModel               *detailModel;
@property (nonatomic, strong) NPYDicImgInfoViewController       *imgInfo;
@property (nonatomic, strong) NPYSupportViewController          *supportVC;

@property (weak, nonatomic) IBOutlet UITableView    *mainTableView;
@property (weak, nonatomic) IBOutlet UIView         *bottomView;
@property (weak, nonatomic) IBOutlet UIButton       *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton       *supportBtn;

- (IBAction)collectionButtonPressed:(id)sender;
- (IBAction)supportButtonPressed:(id)sender;

@end

static NSString *dicMainCell = @"First";
static NSString *dicOpenMainCell = @"Expand";

@implementation NPYDicDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = GRAY_BG;
    
    selecArr = [NSMutableArray arrayWithObjects:@"YES",@"NO",@"YES",@"NO",@"NO", nil];
    
    dataArr = [NSMutableArray new];
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.homeModel.many_id,@"many_id", nil];
    [self requestManyDetailInfoWithUrlString:ManyDetail_Url withParames:requestDict];
    
}

- (void)navigationViewLoad {
    self.navigationItem.title = @"众筹详情";
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
//    UIButton *shareBtn = [[UIButton alloc] init];
//    [shareBtn setFrame:CGRectMake(0, 0, 18, 18)];
//    [shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self
//     
//                  action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)mainViewLoad {
    self.mainTableView.estimatedRowHeight = 100;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (isOpenCell) {
            return CellCount + ExpandCount;
        }
        return CellCount;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
       //
    } else if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 40)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIImage *img1 = [UIImage imageNamed:@"huibao_zhongchou"];
        UIImageView *icon1 = [[UIImageView alloc] initWithImage:img1];
        icon1.frame = CGRectMake(14, 0, img1.size.width, img1.size.height);
        icon1.center = CGPointMake(CGRectGetMidX(icon1.frame), 20);
        [headView addSubview:icon1];
        
        UILabel *title2 = [[UILabel alloc] init];
        title2.frame = CGRectMake(CGRectGetMaxX(icon1.frame) + 10, CGRectGetMinY(icon1.frame), 200, img1.size.height);
        title2.text = @"选择众筹回报";
        title2.font = XNFont(14.0);
        title2.textColor = XNColor(51, 51, 51, 1);
        [headView addSubview:title2];
        
        UIImageView *huiLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750huixian_88"]];
        huiLine.frame = CGRectMake(0, 40, WIDTH_SCREEN, 0.5);
        [headView addSubview:huiLine];
        
        return headView;
        
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        self.topCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYDicTopDetailTableViewCell" owner:nil options:nil] firstObject];
        self.topCell.delegate = self;
        self.topCell.homeModel = self.homeModel;
        self.topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.topCell.userInteractionEnabled = NO;
        return self.topCell;
        
    } else if (indexPath.section == 1) {
        
        NSInteger idx = indexPath.row;
        
        if (isOpenCell) {
            idx -= idx;
        }
        
        if (isOpenCell && selectedIndexPath.row < indexPath.row && indexPath.row <= selectedIndexPath.row + ExpandCount) {
            NPYDicDetailExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dicOpenMainCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYDicDetailExpandTableViewCell" owner:nil options:nil] firstObject];
            }
            
            cell.model = dataArr[idx];
//            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            NPYDicMainDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dicMainCell ];
            if (cell == nil) {
                cell= (NPYDicMainDetailTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"NPYDicMainDetailTableViewCell" owner:self options:nil]  firstObject];
            }
            cell.delegate = self;
            cell.path = indexPath;
            cell.YQGImg.hidden = YES;
            
            cell.detailModel = dataArr[idx];
//            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self configCell:cell indexPath:indexPath];
            return cell;
        }
        
    }
    
    return nil;
    
}

- (void)configCell:(NPYDicMainDetailTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    NSInteger idx = indexPath.row;
    
    if (isOpenCell) {
        idx -= idx;
    }
    
//    cell.YQGImg.hidden = YES;
//    cell.price.text = selecArr[idx];
//    cell.price.hidden = [selecArr[idx] boolValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
        
    } else if (section == 1) {
        return 40;
        
    }
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 1) {
//        self.supportVC = [[NPYSupportViewController alloc] initWithNibName:@"NPYSupportViewController" bundle:nil];
//        [self.navigationController pushViewController:self.supportVC animated:YES];
//        
//    }
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    
    [self.collectionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [self.collectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    [self.supportBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [self.supportBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - ...

#pragma mark - lookImageInfoDelegate

- (void)pushToImageInfoViewController {
    self.imgInfo = [[NPYDicImgInfoViewController alloc] init];
    self.imgInfo.imageStr = self.homeModel.text_img;
    [self.navigationController pushViewController:self.imgInfo animated:YES];
}

#pragma mark - DicMainDetailCellDelegate

- (void)passBuyValueToSuperView:(int)number {
    supporNumber = number;
}

- (void)selectedSportWithIndexPath:(NSIndexPath *)path {
    if (oldSelectedIndexPath == nil || oldSelectedIndexPath == path) {
        NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
        cell.path = path;
        cell.selectBtn.hidden = YES;
        cell.selectedView.hidden = NO;
        
    } else {
        NPYDicMainDetailTableViewCell *oldCell = [self.mainTableView cellForRowAtIndexPath:oldSelectedIndexPath];
        oldCell.path = oldSelectedIndexPath;
        oldCell.selectBtn.hidden = NO;
        oldCell.selectedView.hidden = YES;
//        oldCell.countL.text = @"1";
        
        NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
        cell.path = path;
        cell.selectBtn.hidden = YES;
        cell.selectedView.hidden = NO;
    }
    
    oldSelectedIndexPath = path;
//    cell.countL.text = @"1";
}

- (void)desSelectSpotWithIndexPath:(NSIndexPath *)path {
    NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
    cell.path = path;
    cell.selectBtn.hidden = NO;
    cell.selectedView.hidden = YES;
    cell.selectBtn.selected = NO;
    cell.countL.text = @"0";
    oldSelectedIndexPath = nil;
}

- (void)openSubDetailViewWithIndexPath:(NSIndexPath *)path withIsOpen:(BOOL)open {
    NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
    cell.path = path;
    cell.sepImg.hidden = !cell.sepImg.hidden;
    cell.openBtn.selected = !cell.openBtn.selected;
    if (!selectedIndexPath) {
        isOpenCell = YES;
        selectedIndexPath = path;
        [self.mainTableView beginUpdates];
        [self.mainTableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:path.row] withRowAnimation:UITableViewRowAnimationTop];
        [self.mainTableView endUpdates];
        
    } else if (isOpenCell) {
        if (selectedIndexPath == path) {
            isOpenCell = NO;
            [self.mainTableView beginUpdates];
            [self.mainTableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:path.row] withRowAnimation:UITableViewRowAnimationTop];
            [self.mainTableView endUpdates];
            selectedIndexPath = nil;
            
        } else if (selectedIndexPath.row < path.row && path.row <= selectedIndexPath.row + ExpandCount) {
            NSLog(@".......");
            
        } else {
            
            isOpenCell = NO;
            [self.mainTableView beginUpdates];
            [self.mainTableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
            [self.mainTableView endUpdates];
            selectedIndexPath = nil;
            
        }
        
        
    }
    
}

- (NSArray *)indexPathsForExpandRow:(NSInteger)row {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i <= ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row + 1 inSection:1];
        [indexPaths addObject:idxPth];
        
    }
    return [indexPaths copy];
}

- (void)backItem:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载

- (UIView *)bottomView {
    _bottomView.layer.borderColor = XNColor(240, 240, 240, 1).CGColor;
    _bottomView.layer.borderWidth = 0.5;
    
    return _bottomView;
}

#pragma mark - 网络请求

- (void)requestManyDetailInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"网络请求成功" inView:self.view];
            NSDictionary *tpDict = [NSDictionary dictionaryWithDictionary:dataDict[@"data"]];
            
            self.homeModel = [NPYDicHomeModel mj_objectWithKeyValues:tpDict[@"many"]];
            
            for (NSDictionary *dict in tpDict[@"repay"]) {
                self.detailModel = [NPYDicMainCellModel mj_objectWithKeyValues:dict];
                
                [dataArr addObject:self.detailModel];
            }
            
            CellCount = dataArr.count;
            
            [self.mainTableView reloadData];
            
        } else {
            //请求失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
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

- (void)shareButtonPressed:(UIButton *)sender {
    //分享
    NSLog(@"..分享..");
}

- (IBAction)collectionButtonPressed:(id)sender {
    
}

- (IBAction)supportButtonPressed:(id)sender {
    if (oldSelectedIndexPath == nil || supporNumber == 0) {
        [ZHProgressHUD showMessage:@"没有支持的档位或者支持的数量小于1" inView:self.view];
        return;
    }
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate verifyLoginWithViewController:self];
    
    self.supportVC = [[NPYSupportViewController alloc] initWithNibName:@"NPYSupportViewController" bundle:nil];
    self.supportVC.model = dataArr[oldSelectedIndexPath.row];
    self.supportVC.supportNumber = supporNumber;
    [self.navigationController pushViewController:self.supportVC animated:YES];
    
}
@end
