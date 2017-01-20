//
//  MKJShoppingCartViewController.m
//  TaoBaoShoppingCart
//
//  Created by MKJING on 16/9/10.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJShoppingCartViewController.h"
#import "MJRefresh.h"
#import "shoppingCartModel.h"
#import "MKJRequestHelper.h"
#import "ShoppingCartCell.h"
#import "UIImageView+WebCache.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ChooseGoodsPropertyViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "JTSImageViewController.h"
#import "Masonry.h"
#import "RelatedProductCollectionViewCell.h"
#import "RelatedHeaderCollectionReusableView.h"

#import "NPYBaseConstant.h"
#import "NPYSpecViewController.h"//规格页
#import "NPYShopCarOrderViewController.h"

@interface MKJShoppingCartViewController () <UITableViewDelegate,UITableViewDataSource,ShoppingCartCellDelegate,UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,popValueToSuperViewDelegate> {
    
    NSDictionary *specDict;
    int buyNumber;
    
    NSString *buyID;
    
    BOOL isNeedLogin;
}

@property (weak, nonatomic) IBOutlet UIView *emptyCar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *buyerLists;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) ChooseGoodsPropertyViewController *chooseVC;
// 由于代理问题衍生出的来已经选择单个或者批量的数组装Cell
@property (nonatomic,strong) NSMutableArray *tempCellArray;

@property (nonatomic, strong) UIButton *msgButton;
@property (nonatomic, strong) NPYMessageViewController  *msgVC;
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UIView *rightView;

// 底部统计View的控件 （normal）
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;
@property (weak, nonatomic) IBOutlet UIView *normalBottomRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalBottomRightWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

// 底部全局编辑按钮 (edit)
@property (weak, nonatomic) IBOutlet UIView *editBottomRightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBottomRightWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *editBaby;
@property (weak, nonatomic) IBOutlet UIButton *bottomDelete;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;


// footerView
@property (strong, nonatomic) IBOutlet UIView *underFooterView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *relatedProducts; // 底部相关商品


@property (nonatomic,strong) UIView *textView;


@end


static NSString *shoppongID = @"ShoppingCartCell";
static NSString *shoppingHeaderID = @"BuyerHeaderCell";
static NSString *relatedID = @"RelatedProductCollectionViewCell";
static NSString *relatedHeaderID = @"RelatedHeaderCollectionReusableView";

@implementation MKJShoppingCartViewController


- (void)dealloc
{
//    [self removeObserver:self forKeyPath:@"iSNEEDLOGIN"];
    
    NSLog(@"%s____dealloc",object_getClassName(self));
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.tableView.mj_header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate verifyLoginWithViewController:self];

//    [self addObserver:self forKeyPath:@"iSNEEDLOGIN" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // 设置底部按钮
    CGRect rec = self.bottomView.frame;
    rec.size.width = [UIScreen mainScreen].bounds.size.width;
    rec.size.height = 50;
    rec.origin.x = 0;
    rec.origin.y = [UIScreen mainScreen].bounds.size.height - 99;
    self.bottomView.frame = rec;
    self.normalBottomRightWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width * 2 / 3;
    self.editBottomRightWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width * 2 / 3;
    [self.view addSubview:self.bottomView];
    self.editBottomRightView.hidden = YES;
    
    [self.accountButton addTarget:self action:@selector(accountButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.emptyCar];
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 右上角编辑
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
    [self.rightButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.rightButton setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateSelected];
    
    [self.rightButton setTitle:@"编辑" forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateDisabled];
    
    [self.rightButton addTarget:self action:@selector(clickAllEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.rightButton];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 1, 16)];
    self.lineImgView.image = [UIImage imageNamed:@"32huixian"];
    self.lineImgView.center = CGPointMake(40, CGRectGetMidY(self.rightButton.frame));
    [self.rightView addSubview:self.lineImgView];
    
    // 右上角消息
    self.msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.msgButton.frame = CGRectMake(40, 0, 40, 40);
    [self.msgButton setTitle:@"消息" forState:UIControlStateNormal];
    [self.msgButton setTitleColor:XNColor(102, 102, 102, 1) forState:UIControlStateNormal];
    [self.msgButton addTarget:self action:@selector(clickMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:self.msgButton];
    self.msgButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [self.tableView registerNib:[UINib nibWithNibName:shoppongID bundle:nil] forCellReuseIdentifier:shoppongID];
    [self.tableView registerNib:[UINib nibWithNibName:shoppingHeaderID bundle:nil] forCellReuseIdentifier:shoppingHeaderID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:relatedID bundle:nil] forCellWithReuseIdentifier:relatedID];
    [self.collectionView registerNib:[UINib nibWithNibName:relatedHeaderID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:relatedHeaderID];
    
    self.title = @"购物车";
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    [self.tableView.mj_header beginRefreshing];
    
//    [self refreshData];
}

#pragma mark - 点击全部编辑按钮
- (void)clickAllEdit:(UIButton *)button
{
    button.selected = !button.selected;
    for (BuyerInfo *buyer in self.buyerLists)
    {
        buyer.buyerIsEditing = button.selected;
    }
    [self.tableView reloadData];
    self.editBottomRightView.hidden = !button.selected;
}

#pragma mark - 点击消息按钮

- (void)clickMessage:(UIButton *)button {
    self.msgVC = [[NPYMessageViewController alloc] init];
    [self.navigationController pushViewController:self.msgVC animated:YES];
    
}

- (void)refreshData
{
    self.totalPriceLabel.text = @"合计￥0.00";
    self.allSelectedButton.selected = NO;
    self.rightButton.selected = NO;
    
    __weak typeof(self)weakSelf = self;
    // 请求购物车数据
    [[MKJRequestHelper shareRequestHelper] requestShoppingCartInfo:^(id obj, NSError *err) {
       // buyer Array
        if (err) {
            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",err] inView:self.view];
        }
        
        [weakSelf.buyerLists removeAllObjects];
        weakSelf.buyerLists = (NSMutableArray *)obj;
        
        if (weakSelf.buyerLists.count != 0) {
            weakSelf.emptyCar.hidden = YES;
            
        } else {
            weakSelf.emptyCar.hidden = NO;
        }
        
        [weakSelf.tableView reloadData];

        [weakSelf.tableView.mj_header endRefreshing];
        
        if (![[MKJRequestHelper shareRequestHelper] isEmptyArray:weakSelf.buyerLists]) {
            weakSelf.rightButton.enabled = YES;
        }
        
    }];
    // 请求相关商品数据 （猜你喜欢栏目）
//    [[MKJRequestHelper shareRequestHelper] requestMoreRecommandInfo:^(id obj, NSError *err) {
//       
//        [weakSelf.relatedProducts removeAllObjects];
//        weakSelf.relatedProducts = [[NSMutableArray alloc] initWithArray:(NSArray *)obj];
//
//        [weakSelf.collectionView reloadData];
//        weakSelf.underFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, weakSelf.collectionView.collectionViewLayout.collectionViewContentSize.height);
//        weakSelf.tableView.tableFooterView = weakSelf.underFooterView;
//    }];
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.buyerLists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BuyerInfo *buyer = self.buyerLists[section];
    return buyer.prod_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppongID forIndexPath:indexPath];
    
    cell.delegate = self;
    [self configCell:cell indexPath:indexPath];
    
    return cell;
}

// 组装cell
- (void)configCell:(ShoppingCartCell *)cell indexPath:(NSIndexPath *)indexPath
{
    BuyerInfo *buyer = self.buyerLists[indexPath.section];
    ProductInfo *product = buyer.prod_list[indexPath.row];
    cell.leftChooseButton.selected = product.productIsChoosed; //!< 商品是否需要选择的字段
    __weak typeof(cell)weakCell = cell;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:product.image] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && cacheType == SDImageCacheTypeNone)
        {
            weakCell.productImageView.alpha = 0;
            [UIView animateWithDuration:1.0 animations:^{
               
                weakCell.productImageView.alpha = 1.0f;
            }];
            
        }
        else
        {
            weakCell.productImageView.alpha = 1.0f;
        }
    }];
    cell.titleLabel.text = product.title;
    if ([[MKJRequestHelper shareRequestHelper] isEmptyArray:product.model_detail])
    {
        cell.sizeDetailLabel.text = @"";
        cell.editDetailView.hidden = YES;
    }
    else
    {
        cell.editDetailView.hidden = NO;
//        cell.sizeDetailLabel.text = @"这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据这里测试规格数据";
        cell.sizeDetailLabel.text = [product.model_detail[indexPath.row] valueForKey:@"type_name"];
        cell.editDetailTitleLabel.text = @"点击我修改规格";
    }
    
    cell.priceLabel.attributedText = [[MKJRequestHelper shareRequestHelper] recombinePrice:product.cn_price orderPrice:product.order_price];
    
    cell.countLabel.text = [NSString stringWithFormat:@"x%ld",product.count];
    
    cell.editCountLabel.text = [NSString stringWithFormat:@"%ld",product.count];
    
    
    // 正常模式下面 非编辑
    if (!buyer.buyerIsEditing)
    {
        cell.normalBackView.hidden = NO;
        cell.editBackView.hidden = YES;
    }
    else
    {
        cell.normalBackView.hidden = YES;
        cell.editBackView.hidden = NO;
    }
}

// 高度计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyerInfo *buyer = self.buyerLists[indexPath.section];
    if (buyer.buyerIsEditing)
    {
        return 100;
    }
    else
    {
        CGFloat actualHeight = [tableView fd_heightForCellWithIdentifier:shoppongID cacheByIndexPath:indexPath configuration:^(ShoppingCartCell *cell) {
            
            [self configCell:cell indexPath:indexPath];
            
        }];
        return actualHeight >= 100 ? actualHeight : 100;
    }
}

// tableView的sectionHeader加载数据
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BuyerInfo *buyer = self.buyerLists[section];
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingHeaderID];
    cell.headerSelectedButton.selected = buyer.buyerIsChoosed; //!< 买手是否需要勾选的字段
    [cell.buyerImageView sd_setImageWithURL:[NSURL URLWithString:buyer.user_avatar]];
    cell.buyerNameLabel.text = buyer.nick_name;
    cell.sectionIndex = section;
    cell.editSectionHeaderButton.selected = buyer.buyerIsEditing;
    if (self.rightButton.selected)
    {
        cell.editSectionHeaderButton.hidden = YES;
    }
    else
    {
        cell.editSectionHeaderButton.hidden = NO;
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma  - 
#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.relatedProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingleProduct *product = self.relatedProducts[indexPath.item];
    RelatedProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:relatedID forIndexPath:indexPath];
    __weak typeof(cell)weakCell = cell;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:product.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.imageView.alpha = 0.0f;
            [UIView animateWithDuration:1.0 animations:^{
                weakCell.imageView.alpha = 1.0f;
            }];
        }
        else
        {
            weakCell.imageView.alpha = 1.0f;
        }
        
    }];
    cell.priceLabel.attributedText = [[MKJRequestHelper shareRequestHelper] recombinePrice:product.cn_price orderPrice:product.order_price];
    cell.nameLabel.text = product.title;
    cell.countryLabel.text = product.user_id;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 30) / 2;
    CGFloat height = 250;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:relatedHeaderID forIndexPath:indexPath];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma -
#pragma - 点击单个商品cell选择按钮
- (void)productSelected:(ShoppingCartCell *)cell isSelected:(BOOL)choosed
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BuyerInfo *buyer  = self.buyerLists[indexPath.section];
    ProductInfo *product = buyer.prod_list[indexPath.row];
    product.productIsChoosed = !product.productIsChoosed;
    // 当点击单个的时候，判断是否该买手下面的商品是否全部选中
    __block NSInteger count = 0;
    [buyer.prod_list enumerateObjectsUsingBlock:^(ProductInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (obj.productIsChoosed)
        {
            count ++;
        }
    }];
    if (count == buyer.prod_list.count)
    {
        buyer.buyerIsChoosed = YES;
    }
    else
    {
        buyer.buyerIsChoosed = NO;
    }
    [self.tableView reloadData];
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
}


#pragma mark - 点击buer选择按钮回调
- (void)buyerSelected:(NSInteger)sectionIndex
{
    BuyerInfo *buyer = self.buyerLists[sectionIndex];
    buyer.buyerIsChoosed = !buyer.buyerIsChoosed;
    [buyer.prod_list enumerateObjectsUsingBlock:^(ProductInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.productIsChoosed = buyer.buyerIsChoosed;
    }];
    [self.tableView reloadData];
    // 每次点击都要统计底部的按钮是否全选
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
}

#pragma mark - 点击buyer编辑按钮回调
- (void)buyerEditingSelected:(NSInteger)sectionIdx
{
    BuyerInfo *buy = self.buyerLists[sectionIdx];
    buy.buyerIsEditing = !buy.buyerIsEditing;
    
    if (! buy.buyerIsEditing && buyID && [specDict valueForKey:@"id"]) {
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - 点击编辑详情回调
- (void)clickEditingDetailInfo:(ShoppingCartCell *)cell
{
    // 编辑对应的商品信息，这里写的太多了，我就写死了，逻辑太多了，这尼玛根本不叫Demo了，这简直就是我的成品
//    self.chooseVC = nil;
//    self.chooseVC = [[ChooseGoodsPropertyViewController alloc] init];
//    self.chooseVC.enterType = SecondEnterType;
//    self.chooseVC.price = 999.99f;
//    [self.navigationController presentSemiViewController:self.chooseVC withOptions:@{
//                                                                                         KNSemiModalOptionKeys.pushParentBack    : @(YES),
//                                                                                         KNSemiModalOptionKeys.animationDuration : @(0.6),
//                                                                                         KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
//                                                                                         KNSemiModalOptionKeys.backgroundView : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]]
//                                                                                         }];
//
    
#pragma mark - 规格编辑
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BuyerInfo *buyer  = self.buyerLists[indexPath.section];
    ProductInfo *product = buyer.prod_list[indexPath.row];
    buyID = [buyer valueForKey:@"buyer_shopping_id"];
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NPYSpecViewController *specVC = [[NPYSpecViewController alloc] initWithNibName:@"NPYSpecViewController" bundle:nil];
    specVC.indexPath = indexPath;
    specVC.goodsID = product.prod_id;
    specVC.sign = [userDict valueForKey:@"sign"];
    specVC.userID = userModel.user_id;
    specVC.storNumber = [NSString stringWithFormat:@"%li",(long)product.count];
    specVC.delegate = self;
    specVC.view.backgroundColor = XNColor(0, 0, 0, 0.2);
    specVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    specVC.buyNumberL.hidden = YES;
    specVC.buyNumberShow.hidden = YES;
    specVC.cutBtn.hidden = YES;
    specVC.addBtn.hidden = YES;
    specVC.buyNumber_lab.hidden = YES;
    [self presentViewController:specVC animated:YES completion:nil];
    
}

#pragma mark - 编辑规格返回的值
- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number {
    specDict = [NSDictionary dictionaryWithDictionary:dataDict];
//    buyNumber = number;

}

- (void)popValue:(NSDictionary *)dataDict withNumber:(int)number withIndex:(NSIndexPath *)indexPath {
    
    BuyerInfo *buyer  = self.buyerLists[indexPath.section];
    ProductInfo *product = buyer.prod_list[indexPath.row];
    
    product.price = [[specDict valueForKey:@"price"] doubleValue];
//    product.count = number;
    product.remark = [specDict valueForKey:@"id"];
    
    NSArray *list = product.model_detail;
    for (int i = 0; i < list.count; i++) {
        ModelDeatail *detal = list[i];
        [detal setValue:[dataDict valueForKey:@"id"] forKey:@"key"];
        [detal setValue:[dataDict valueForKey:@"name"] forKey:@"type_name"];
        [detal setValue:[dataDict valueForKey:@"postage"] forKey:@"value"];
        list = [NSArray arrayWithObject:detal];
    }
    
    product.model_detail = [list copy];
    
    NSString *urlStr = @"/index.php/app/Shopping/update";

    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];

    NSDictionary *editDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              buyID,@"shopping_id",
                              [NSString stringWithFormat:@"%li",(long)product.count],@"number",
                              [specDict valueForKey:@"id"],@"goods_spec", nil];

    NSArray *listArr = [NSArray arrayWithObject:editDict];

    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [userDict valueForKey:@"sign"],@"sign",
                                userModel.user_id,@"user_id",
                                listArr,@"list", nil];

    [self requestEditShoppingCarUrl:urlStr withParemes:requestDic];
}

#pragma mark - 点击图片展示Show
- (void)clickProductIMG:(ShoppingCartCell *)cell
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    BuyerInfo *buyer = self.buyerLists[indexpath.section];
    ProductInfo *product = buyer.prod_list[indexpath.row];
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    NSString *imageURLStr = product.image;
    imageInfo.imageURL  = [NSURL URLWithString:imageURLStr];
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
}

#pragma mark -增加或者减少商品
- (void)plusOrMinusCount:(ShoppingCartCell *)cell tag:(NSInteger)tag
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    BuyerInfo *buyer = self.buyerLists[indexpath.section];
    ProductInfo *product = buyer.prod_list[indexpath.row];
    
    if (tag == 555)
    {
        if (product.count <= 1) {
            
        }
        else
        {
            product.count --;
        }
    }
    else if (tag == 666)
    {
        product.count ++;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
    buyID = [buyer valueForKey:@"buyer_shopping_id"];
    
    NSString *urlStr = @"/index.php/app/Shopping/update";
    
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NSDictionary *editDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",buyID],@"shopping_id",
                              [NSString stringWithFormat:@"%li",product.count],@"number",
                              product.remark,@"goods_spec", nil];
    
    NSArray *listArr = [NSArray arrayWithObject:editDict];
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [userDict valueForKey:@"sign"],@"sign",
                                userModel.user_id,@"user_id",
                                listArr,@"list", nil];
    
    [self requestEditShoppingCarUrl:urlStr withParemes:requestDic];
    
    [self.tableView reloadData];
    
}

#pragma mark - 点击单个商品删除回调
- (void)productGarbageClick:(ShoppingCartCell *)cell
{
    [self.tempCellArray removeAllObjects];
    [self.tempCellArray addObject:cell];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    alert.delegate = self;
    [alert show];
}

// alert的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 单个删除
    if (alertView.tag == 101) {
        if (buttonIndex == 1)
        {
            NSIndexPath *indexpath = [self.tableView indexPathForCell:self.tempCellArray.firstObject];
            BuyerInfo *buyer = self.buyerLists[indexpath.section];
            ProductInfo *product = buyer.prod_list[indexpath.row];
            if (buyer.prod_list.count == 1) {
                [self.buyerLists removeObject:buyer];
            }
            else
            {
                [buyer.prod_list removeObject:product];
            }
            
            NSString *urlStr = @"/index.php/app/Shopping/delete";
            NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
            NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
            NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [userDict valueForKey:@"sign"],@"sign",
                                        userModel.user_id,@"user_id",
                                        [buyer valueForKey:@"buyer_shopping_id"],@"shopping_id", nil];
            
            [self requestDeleteGoodsFromShoppingCar:urlStr withPatemes:requestDic];
            // 这里删除之后操作涉及到太多东西了，需要
            [self updateInfomation];
        }
    }
    else if (alertView.tag == 102) // 多个或者单个
    {
        if (buttonIndex == 1)
        {
            NSMutableArray *buyerTempArr = [[NSMutableArray alloc] init];
            for (BuyerInfo *buyer in self.buyerLists)
            {
                if (buyer.buyerIsChoosed)
                {
                    [buyerTempArr addObject:buyer];
                }
                else
                {
                    NSMutableArray *productTempArr = [[NSMutableArray alloc] init];
                    for (ProductInfo *product in buyer.prod_list)
                    {
                        if (product.productIsChoosed)
                        {
                            [productTempArr addObject:product];
                        }
                    }
                    if (![[MKJRequestHelper shareRequestHelper] isEmptyArray:productTempArr])
                    {
                        [buyer.prod_list removeObjectsInArray:productTempArr];
                    }
                }
            }
            [self.buyerLists removeObjectsInArray:buyerTempArr];
            [self updateInfomation];
            
            NSMutableArray *mArr = [NSMutableArray new];
            NSMutableDictionary *mDict = [NSMutableDictionary new];
            
            for (int i = 0; i < buyerTempArr.count; i++) {
                BuyerInfo *buyer = buyerTempArr[i];
                [mDict setObject:[buyer valueForKey:@"buyer_shopping_id"] forKey:@"shopping_id"];
                [mArr addObject:mDict];
            }
            
            NSString *urlStr = @"/index.php/app/Shopping/del";
            NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
            NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
            NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [userDict valueForKey:@"sign"],@"sign",
                                        userModel.user_id,@"user_id",
                                        mArr,@"list", nil];
            
            [self requestDeleteGoodsFromShoppingCar:urlStr withPatemes:requestDic];
        }
        
    }
    
}

#pragma mark - 删除之后一些列更新操作
- (void)updateInfomation
{
    // 会影响到对应的买手选择
    for (BuyerInfo *buyer in self.buyerLists) {
        NSInteger count = 0;
        for (ProductInfo *product in buyer.prod_list) {
            if (product.productIsChoosed) {
                count ++;
            }
        }
        if (count == buyer.prod_list.count) {
            buyer.buyerIsChoosed = YES;
        }
    }
    // 再次影响到全部选择按钮
    self.allSelectedButton.selected = [self isAllProcductChoosed];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    
    // 如果删除干净了
    if ([[MKJRequestHelper shareRequestHelper] isEmptyArray:self.buyerLists]) {
        [self clickAllEdit:self.rightButton];
        self.rightButton.enabled = NO;
    }
   
    
}


#pragma mark - 判断是否全部选中了
- (BOOL)isAllProcductChoosed
{
    if ([[MKJRequestHelper shareRequestHelper] isEmptyArray:self.buyerLists]) {
        return NO;
    }
    NSInteger count = 0;
    for (BuyerInfo *buyer in self.buyerLists) {
        if (buyer.buyerIsChoosed) {
            count ++;
        }
    }
    return (count == self.buyerLists.count);
}

#pragma mark - 点击底部全选按钮
- (IBAction)clickAllProductSelected:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    for (BuyerInfo *buyer in self.buyerLists) {
        buyer.buyerIsChoosed = sender.selected;
        for (ProductInfo *product in buyer.prod_list) {
            product.productIsChoosed = buyer.buyerIsChoosed;
        }
    }
    [self.tableView reloadData];
    
    CGFloat totalPrice = [self countTotalPrice];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计￥%.2f",totalPrice];
    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
}


#pragma -
#pragma mark - 计算选出商品的总价
- (CGFloat)countTotalPrice
{
    CGFloat totalPrice = 0.0;
    for (BuyerInfo *buyer in self.buyerLists) {
        if (buyer.buyerIsChoosed) {
            for (ProductInfo *product in buyer.prod_list) {
                totalPrice += product.order_price * product.count;
            }
        }else{
            for (ProductInfo *product in buyer.prod_list) {
                if (product.productIsChoosed) {
                    totalPrice += product.order_price * product.count;
                }
            }
            
        }
    }
    return totalPrice;
}

#pragma mark - 计算商品被选择了数量
- (NSInteger)countTotalSelectedNumber
{
    NSInteger count = 0;
    for (BuyerInfo *buyer in self.buyerLists) {
        for (ProductInfo *product in buyer.prod_list) {
            if (product.productIsChoosed) {
                count ++;
            }
        }
    }
    return count;
}

// 分享
- (IBAction)share:(id)sender {
    NSLog(@"分享宝贝");
}

// 移动到收藏夹
- (IBAction)store:(id)sender {
    NSLog(@"移动到收藏夹");
}

// 底部多选删除也可单选删除
- (IBAction)deleteMultipleOrSingfle:(id)sender {
    
    // 这个大的是用来过滤buyer的 没有就是nil，从商品数组中删除
    [self.tempCellArray removeAllObjects];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    alert.delegate = self;
    [alert show];
}
#pragma mark - 结算事件
- (void)accountButtonPressed:(UIButton *)sender {
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    
    NPYShopCarOrderViewController *shopOrederVC = [[NPYShopCarOrderViewController alloc] init];
    shopOrederVC.sign = [userDict valueForKey:@"sign"];
    shopOrederVC.user_id = userModel.user_id;
    shopOrederVC.totalPrice = [NSString stringWithFormat:@"%.2f",[self countTotalPrice]];
    
//    for (BuyerInfo *buyer in self.buyerLists) {
//        
//        for (ProductInfo *product in buyer.prod_list) {
//            if (product.productIsChoosed) {
//                
//                [shopOrederVC.mShopModels addObject:buyer];
//                
//                [shopOrederVC.mGoodsModels addObject:product];
//                
//            }
//            
//        }
//    }
    
    for (BuyerInfo *buyer in self.buyerLists) {
        int num = 0;
        if (buyer.buyerIsChoosed) {
            [shopOrederVC.mShopModels addObject:buyer];
            
        } else {
            NSMutableArray *tpArr = [NSMutableArray new];
            tpArr = [buyer.prod_list mutableCopy];
            for (ProductInfo *pro in buyer.prod_list) {
                if (pro.productIsChoosed) {
                    ++num;
                    if (num == 1) {
                        [shopOrederVC.mShopModels addObject:buyer];
                    }
                } else {
                    [tpArr removeObject:pro];
                }
            }
            
            buyer.prod_list = [tpArr copy];
        }
        
        
    }
    
    
    if (shopOrederVC.mShopModels.count != 0) {
        [self.navigationController pushViewController:shopOrederVC animated:YES];
    }
    
    [ZHProgressHUD showMessage:@"选择要支付的商品" inView:self.view];

    
}

#pragma mark - 网络请求服务器数据

- (void)requestEditShoppingCarUrl:(NSString *)url withParemes:(NSDictionary *)pareme {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            NSDictionary *tpDict = dataDict[@"data"];
            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestDeleteGoodsFromShoppingCar:(NSString *)urlStr withPatemes:(NSDictionary *)pareme {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            NSDictionary *tpDict = dataDict[@"data"];
            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        } else {
            //失败
//            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([change objectForKey:@"new"]) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate verifyLoginWithViewController:self];
    }
    
}

- (NSMutableArray *)buyerLists
{
    if (_buyerLists == nil) {
        _buyerLists = [[NSMutableArray alloc] init];
    }
    return _buyerLists;
}

- (NSMutableArray *)tempCellArray
{
    if (_tempCellArray == nil) {
        _tempCellArray = [[NSMutableArray alloc] init];
    }
    return _tempCellArray;
}
- (NSMutableArray *)relatedProducts
{
    if (_relatedProducts == nil) {
        _relatedProducts = [[NSMutableArray alloc] init];
    }
    return _relatedProducts;
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
