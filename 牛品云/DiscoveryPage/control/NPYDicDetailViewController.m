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
#import "NPYDicMainCellModel.h"
#import "NPYDicImgInfoViewController.h"
#import "NPYSupportViewController.h"

@interface NPYDicDetailViewController () <UITableViewDelegate,UITableViewDataSource,lookImageInfoDelegate,DicMainDetailCellDelegate> {
    NSArray *selecArr;
}

@property (nonatomic, strong) NPYDicTopDetailTableViewCell  *topCell;
@property (nonatomic, strong) NPYDicMainDetailTableViewCell *mainCell;
@property (nonatomic, strong) NPYDicMainCellModel           *mainModel;
@property (nonatomic, strong) NPYDicImgInfoViewController   *imgInfo;
@property (nonatomic, strong) NPYSupportViewController      *supportVC;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;

- (IBAction)collectionButtonPressed:(id)sender;
- (IBAction)supportButtonPressed:(id)sender;

@end

static NSString *dicMainCell = @"NPYDicMainDetailTableViewCell";

@implementation NPYDicDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selecArr = [NSArray arrayWithObjects:@"YES",@"NO",@"YES",@"NO",@"NO", nil];
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
    
}

- (void)navigationViewLoad {
    self.navigationItem.title = @"众筹详情";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

- (void)mainViewLoad {
    self.mainTableView.estimatedRowHeight = 100;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    
    self.mainTableView.tableFooterView = [UIView new];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:dicMainCell bundle:nil] forCellReuseIdentifier:dicMainCell];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 5;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        
    } else if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 20)];
        headView.backgroundColor = [UIColor redColor];
        return headView;
        
    }
    
    return nil;
}

/**
    static NSString *CellIdentifier = @"Cell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([Cell class]) bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    nibsRegistered = YES;
    }
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.titleLabel.text = [self.dataList objectAtIndex:indexPath.row];
    return cell;
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
//        static NSString *CellIdentifier = @"Cell";
//        self.topCell = (NPYDicTopDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        self.topCell = [[[NSBundle mainBundle] loadNibNamed:@"NPYDicTopDetailTableViewCell" owner:nil options:nil] firstObject];
        self.topCell.delegate = self;
        self.topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.topCell;
        
    } else if (indexPath.section == 1) {
        
        NPYDicMainDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dicMainCell forIndexPath:indexPath];
        cell.path = indexPath;
        cell.delegate = self;
        NPYDicMainCellModel *model = [[NPYDicMainCellModel alloc] init];
        model.isSelected = [selecArr[indexPath.row] boolValue];
        
        UIImageView *img = [cell viewWithTag:1001];
        img.hidden = model.isSelected;
        
        [self configCell:cell indexPath:indexPath];
        
        return cell;
        
    }
    
    return nil;
    
}

- (void)configCell:(NPYDicMainDetailTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    cell.price.text = selecArr[indexPath.row];
    cell.price.hidden = [selecArr[indexPath.row] boolValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
        
    } else if (section == 1) {
        return 20;
        
    }
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        self.supportVC = [[NPYSupportViewController alloc] initWithNibName:@"NPYSupportViewController" bundle:nil];
        [self.navigationController pushViewController:self.supportVC animated:YES];
        
    }
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
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
    [self.navigationController pushViewController:self.imgInfo animated:YES];
}

#pragma mark - DicMainDetailCellDelegate

- (void)selectedSportWithIndexPath:(NSIndexPath *)path {
    NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
    cell.path = path;
    cell.selectBtn.hidden = YES;
    cell.selectedView.hidden = NO;
    cell.countL.text = @"1";
}

- (void)desSelectSpotWithIndexPath:(NSIndexPath *)path {
    NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
    cell.path = path;
    cell.selectBtn.hidden = NO;
    cell.selectedView.hidden = YES;
    cell.selectBtn.selected = NO;
    cell.countL.text = @"0";
}

- (void)openSubDetailViewWithIndexPath:(NSIndexPath *)path withIsOpen:(BOOL)open {
    NPYDicMainDetailTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:path];
    cell.path = path;
    
    if (open) {
        //展开
        
    } else {
        //收起
        
    }
    
    [self.mainTableView reloadData];
}

#pragma mark - 懒加载

- (UIView *)bottomView {
    _bottomView.layer.borderColor = XNColor(240, 240, 240, 1).CGColor;
    _bottomView.layer.borderWidth = 0.5;
    
    return _bottomView;
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

- (IBAction)collectionButtonPressed:(id)sender {
}

- (IBAction)supportButtonPressed:(id)sender {
}
@end
