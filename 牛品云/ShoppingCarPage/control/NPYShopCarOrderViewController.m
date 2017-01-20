//
//  NPYShopCarOrderViewController.m
//  牛品云
//
//  Created by Eric on 17/1/8.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "NPYShopCarOrderViewController.h"
#import "NPYBaseConstant.h"
#import "NPYAddressViewController.h"
#import "NPYPaymentOrderViewController.h"
#import "NPYAddressModel.h"
#import "NPYTicketViewController.h"
#import "NPYTicketModel.h"

#define SHOP_ORDER_BUY_URL   @"/index.php/app/Buy/batch_home"
#define SHOP_ORDER_BUY_ONEGOODS_URL  @"/index.php/app/Buy/batch_goods"

@interface NPYShopCarOrderViewController () <UITableViewDelegate,UITableViewDataSource,AddressValueToSuperViewDelegate,TicketViewControllerDelegate> {
    UILabel *totalMoneyL;   //总计金额
    UILabel *addAddressL;   //地址
    
    UILabel *consigneeName; //收货人
    UILabel *phonNumber;    //手机号
    UILabel *address;       //收货地址
    
    UIImageView *topLineImg;
    
    BOOL isAddress;
    
    NSDictionary *addressDic;
    
    NSString *couponNumber,*uer_integralNumber;
    
    NSIndexPath *selectedTicketPath;
    NPYTicketModel *selectedTicketModel;
    NSString *useIntegral;//使用牛豆（0-不使用、1-使用）
    NSMutableArray *integralArr;
    NSMutableArray *ticketArr;
    
    NSMutableArray *mReqList;
    
    int proTotalNumber;
    int proTotalFreight;
    float proTotalPrice;
    
    int orderTotalFreight;
    float orderTotalPrice;
}

@property (nonatomic, strong) UITableView *mainTView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NPYAddressViewController          *addressVC;
@property (nonatomic, strong) NPYPaymentOrderViewController     *paymentOrderVC;

@end

@implementation NPYShopCarOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    proTotalNumber = 0;
    proTotalPrice = 0.00;
    orderTotalPrice = 0.00;
    proTotalFreight = 0;
    orderTotalFreight = 0;
    
    self.view.backgroundColor = GRAY_BG;
    
    [self navigationViewLoad];
    
    [self mainViewLoad];
    
//    [self bottomViewLoad];
    
    [self calculateFreight];
    
    mReqList = [NSMutableArray new];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:self.sign,@"sign",self.user_id,@"user_id", nil];
    [self requestOrderInfoWithUrlString:SHOP_ORDER_BUY_URL withParames:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [topLineImg removeFromSuperview];
    topLineImg = nil;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)navigationViewLoad {
    //
    self.navigationItem.title = @"确认订单";
    
    //    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0]};
    
    topLineImg = [[UIImageView alloc] init];
    topLineImg.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 1, WIDTH_SCREEN, 1);
    topLineImg.image = [UIImage imageNamed:@"750huixian_88"];
    [self.navigationController.navigationBar addSubview:topLineImg];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)mainViewLoad {
    //
    self.mainTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, WIDTH_SCREEN, HEIGHT_SCREEN - 41) style:UITableViewStyleGrouped];
    self.mainTView.backgroundColor = [UIColor clearColor];
    self.mainTView.dataSource = self;
    self.mainTView.delegate = self;
    [self.view addSubview:self.mainTView];
    [self.mainTView setSeparatorColor:GRAY_BG];
    self.mainTView.estimatedRowHeight = 200;
    self.mainTView.rowHeight = UITableViewAutomaticDimension;
    
    self.mainTView.showsVerticalScrollIndicator = NO;
    self.mainTView.showsHorizontalScrollIndicator = NO;
}

- (void)bottomViewLoad {
    //
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
        self.bottomView = nil;
    }
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, HEIGHT_SCREEN - 40, WIDTH_SCREEN, 40);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750huixian_92"]];
    lineImg.frame = CGRectMake(0, 0, WIDTH_SCREEN, 1);
    [self.bottomView addSubview:lineImg];
    //
    UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN / 3, CGRectGetHeight(self.bottomView.frame))];
    [self.bottomView addSubview:tmpL];
    tmpL.text = @"总计：";
    tmpL.textColor = XNColor(51, 51, 51, 1);
    tmpL.font = [UIFont systemFontOfSize:13.0];
    tmpL.textAlignment = NSTextAlignmentRight;
    
    self.totalPrice  = [NSString stringWithFormat:@"%.2f",orderTotalPrice + orderTotalFreight];
    
    totalMoneyL = [[UILabel alloc] init];
    totalMoneyL.frame = CGRectMake(CGRectGetMaxX(tmpL.frame), 0, 100, CGRectGetHeight(tmpL.frame));
    [self.bottomView addSubview:totalMoneyL];
    totalMoneyL.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%@",self.totalPrice] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    totalMoneyL.adjustsFontSizeToFitWidth = YES;
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.frame = CGRectMake(CGRectGetMaxX(totalMoneyL.frame), 0, WIDTH_SCREEN - CGRectGetMaxX(totalMoneyL.frame), CGRectGetHeight(self.bottomView.frame));
    [self.bottomView addSubview:submitBtn];
    submitBtn.backgroundColor = [UIColor redColor];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = XNFont(20.0);
    [submitBtn addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mShopModels.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 1) {
//        return self.mShopModels.count;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"mainCell";
    //    UITableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *mainCell;
    if (mainCell == nil) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //地址栏
        if (indexPath.section == 0) {
            if (isAddress == NO) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.frame = CGRectMake(14, 0, 19, 19);
                imgView.image = [UIImage imageNamed:@"xinzeng_gouwu"];
                [mainCell.contentView addSubview:imgView];
                imgView.center = CGPointMake(CGRectGetMidX(imgView.frame), CGRectGetMidY(mainCell.contentView.frame));
                
                addAddressL = [[UILabel alloc] init];
                addAddressL.frame = CGRectMake(CGRectGetMaxX(imgView.frame) + 15, CGRectGetMinY(imgView.frame), 80, CGRectGetHeight(imgView.frame));
                [mainCell.contentView addSubview:addAddressL];
                addAddressL.text = @"新增地址";
                addAddressL.textColor = XNColor(17, 17, 17, 1);
                addAddressL.font = XNFont(15.0);
                
            } else {
                UILabel *consigneeL = [[UILabel alloc] init];
                consigneeL.frame = CGRectMake(14, 15, 60, 20);
                consigneeL.text = @"收货人：";
                consigneeL.font = [UIFont systemFontOfSize:14.0];
                consigneeL.textColor = XNColor(17, 17, 17, 1);
                [mainCell.contentView addSubview:consigneeL];
                
                consigneeName = [[UILabel alloc] init];
                consigneeName.frame = CGRectMake(CGRectGetMaxX(consigneeL.frame), CGRectGetMinY(consigneeL.frame), 80, 20);
                consigneeName.text = [addressDic valueForKey:@"name"];
                consigneeName.font = [UIFont systemFontOfSize:14.0];
                consigneeName.textColor = XNColor(17, 17, 17, 1);
                consigneeName.textAlignment = NSTextAlignmentLeft;
                [mainCell.contentView addSubview:consigneeName];
                
                phonNumber = [[UILabel alloc] init];
                phonNumber.frame = CGRectMake(CGRectGetMaxX(consigneeName.frame) + Height_Space, CGRectGetMinY(consigneeL.frame), 100, 20);
                phonNumber.text = [addressDic valueForKey:@"phone"];
                phonNumber.font = [UIFont systemFontOfSize:14.0];
                phonNumber.textColor = XNColor(17, 17, 17, 1);
                [mainCell.contentView addSubview:phonNumber];
                
                UILabel *addressL = [[UILabel alloc] init];
                addressL.frame = CGRectMake(14, CGRectGetMaxY(consigneeL.frame) + 15, 70, 20);
                addressL.text = @"收货地址：";
                addressL.font = [UIFont systemFontOfSize:14.0];
                addressL.textColor = XNColor(17, 17, 17, 1);
                addressL.adjustsFontSizeToFitWidth = YES;
                [mainCell.contentView addSubview:addressL];
                
                address = [[UILabel alloc] init];
                address.frame = CGRectMake(CGRectGetMaxX(addressL.frame) + Height_Space, CGRectGetMinY(addressL.frame) - 10, WIDTH_SCREEN  - CGRectGetWidth(addressL.frame) - 50, 40);
                address.text = [addressDic valueForKey:@"address"];
                address.font = [UIFont systemFontOfSize:14.0];
                address.textColor = XNColor(17, 17, 17, 1);
                address.numberOfLines = 0;
                [mainCell.contentView addSubview:address];
            }
            
            mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.section == self.mShopModels.count + 1) {
            //牛豆
            mainCell.textLabel.text = @"牛豆";
            
            UISwitch *NPYSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 60, 10, 100, 20)];
            [NPYSwitch setOn:YES];
            NPYSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [NPYSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [mainCell.contentView addSubview:NPYSwitch];
            useIntegral = NPYSwitch.isOn ? @"1" : @"0";
            
        } else {
            //产品信息栏 && 优惠信息
            int i = (int)indexPath.row;
            
            BuyerInfo *buyer = self.mShopModels[i];
            UIView *bg2;
            UIView *bg;
            UIImageView *proIcon = [[UIImageView alloc] init];
            proIcon.frame = CGRectMake(14, 10, 20, 20);
            [proIcon sd_setImageWithURL:[NSURL URLWithString:buyer.user_avatar] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];//logo
            proIcon.contentMode = UIViewContentModeScaleToFill;
            [mainCell.contentView addSubview:proIcon];
            
            UILabel *proName = [[UILabel alloc] init];
            proName.frame = CGRectMake(CGRectGetMaxX(proIcon.frame) + 10, 10, WIDTH_SCREEN - 60, 20);
            proName.textColor = XNColor(17, 17, 17, 1);
            proName.font = [UIFont systemFontOfSize:15.0];
            proName.text = buyer.nick_name;//名字
            [mainCell.contentView addSubview:proName];
            
            for (int i = 0; i < buyer.prod_list.count; i++) {
                ProductInfo *pro = buyer.prod_list[i];
                
                bg = [[UIView alloc] init];
                bg.frame = CGRectMake(0, CGRectGetMaxY(proIcon.frame) + 10 + 105 * i, WIDTH_SCREEN, 105);
                bg.backgroundColor = XNColor(247, 247, 247, 1);
                [mainCell.contentView addSubview:bg];
                
                UIImageView *proImage = [[UIImageView alloc] init];
                proImage.frame = CGRectMake(CGRectGetMinX(proIcon.frame), 10, 80, 80);
                [proImage sd_setImageWithURL:[NSURL URLWithString:pro.image] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];//
                proImage.contentMode = UIViewContentModeScaleToFill;
                [bg addSubview:proImage];
                
                UILabel *proDetail = [[UILabel alloc] init];
                proDetail.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 11, CGRectGetMinY(proImage.frame), bg.frame.size.width - CGRectGetWidth(proImage.frame) - 40, 30);
                proDetail.text = pro.title;//
                proDetail.textColor = XNColor(35, 35, 35, 1);
                proDetail.font = [UIFont systemFontOfSize:12.0];
                proDetail.numberOfLines = 0;
                [bg addSubview:proDetail];
                
                UILabel *proPrice = [[UILabel alloc] init];
                proPrice.frame = CGRectMake(CGRectGetMaxX(proImage.frame) + 10, CGRectGetMaxY(proImage.frame) - 20, 80, 20);
                proPrice.adjustsFontSizeToFitWidth = YES;
                proPrice.tag = 500 + indexPath.row;
                proPrice.numberOfLines = 0;
                proPrice.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",pro.price] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];//
                [bg addSubview:proPrice];
                
//                UIButton *cutBtn = [[UIButton alloc] init];
//                cutBtn.tag = 5000 + indexPath.row;
//                cutBtn.frame = CGRectMake(bg.frame.size.width - 90, CGRectGetMinY(proPrice.frame), 23, 23);
//                [cutBtn setImage:[UIImage imageNamed:@"jian_zhongchou"] forState:UIControlStateNormal];
//                [cutBtn addTarget:self action:@selector(cutAndAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//                [bg addSubview:cutBtn];
                
                UILabel *proCount = [[UILabel alloc] init];
                proCount.frame = CGRectMake(CGRectGetMaxX(bg.frame) - 60, CGRectGetMinY(proPrice.frame), 30, 23);
                proCount.tag = 600 + indexPath.row;
                proCount.text = [NSString stringWithFormat:@"X%li",(long)pro.count];
                proCount.textColor = XNColor(17, 17, 17, 1);
                proCount.font = [UIFont systemFontOfSize:14.0];
                proCount.textAlignment = NSTextAlignmentCenter;
                proCount.adjustsFontSizeToFitWidth = YES;
                [bg addSubview:proCount];
                
//                UIButton *sumBtn = [[UIButton alloc] init];
//                sumBtn.tag = 4000 + indexPath.row;
//                sumBtn.frame = CGRectMake(CGRectGetMaxX(proCount.frame), CGRectGetMinY(proPrice.frame), 23, 23);
//                [sumBtn setImage:[UIImage imageNamed:@"jia_zhongchou"] forState:UIControlStateNormal];
//                [sumBtn addTarget:self action:@selector(cutAndAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//                [bg addSubview:sumBtn];
                
                proTotalNumber += pro.count;
                proTotalPrice += pro.price * pro.count;
            }
            
            UILabel *proTotal = [[UILabel alloc] init];
            proTotal.frame = CGRectMake(0, CGRectGetMaxY(bg.frame) + 10, WIDTH_SCREEN - 96, 20);
            proTotal.tag = 700 + indexPath.row;
            proTotal.text = [NSString stringWithFormat:@"共 %i 件商品 合计：",proTotalNumber];
            proTotal.textAlignment = NSTextAlignmentRight;
            proTotal.font = [UIFont systemFontOfSize:13.0];
            proTotal.textColor = XNColor(51, 51, 51, 1);
            [mainCell.contentView addSubview:proTotal];
            
            UILabel *proPrice2 = [[UILabel alloc] init];
            proPrice2.frame = CGRectMake(CGRectGetMaxX(proTotal.frame), CGRectGetMinY(proTotal.frame), 80, 20);
            proPrice2.tag = 800 + indexPath.row;
            proPrice2.adjustsFontSizeToFitWidth = YES;
            proPrice2.numberOfLines = 0;
            proPrice2.textAlignment = NSTextAlignmentRight;
            proPrice2.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",proTotalPrice] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
            [mainCell.contentView addSubview:proPrice2];
            
            bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(proTotal.frame) + 8, WIDTH_SCREEN, 10)];
            bg2.backgroundColor = GRAY_BG;
            [mainCell.contentView addSubview:bg2];
            
            NSArray *names = @[@"运费",@"优惠券"];
//            CGRect rect11 ;
            for (int i = 0; i < names.count; i++) {
                
                UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(bg2.frame) + 5 + i * 40, WIDTH_SCREEN, 20)];
//                rect11 = nameL.frame;
                nameL.text = names[i];
                nameL.font = XNFont(15.0);
                nameL.textColor = XNColor(17, 17, 17, 1);
                [mainCell.contentView addSubview:nameL];
                
                if (i == 0) {
                    UILabel *disL = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 100, CGRectGetMinY(nameL.frame), 80, 20)];
                    disL.tag = 855 + indexPath.row;
                    disL.text = [NSString stringWithFormat:@"%i元",proTotalFreight];
                    disL.font = XNFont(12.0);
                    disL.textColor = XNColor(51, 51, 51, 1);
                    disL.adjustsFontSizeToFitWidth = YES;
                    disL.textAlignment = NSTextAlignmentRight;
                    [mainCell.contentView addSubview:disL];
                    
                    UIView *bg3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameL.frame) + 10, WIDTH_SCREEN, 1)];
                    bg3.backgroundColor = GRAY_BG;
                    [mainCell.contentView addSubview:bg3];
                }
                
                if (i == 1) {
                    UILabel *disL = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 120, CGRectGetMinY(nameL.frame), 80, 20)];
                    disL.tag = 855 + indexPath.row;
                    disL.font = XNFont(12.0);
                    disL.textColor = XNColor(51, 51, 51, 1);
                    disL.adjustsFontSizeToFitWidth = YES;
                    disL.textAlignment = NSTextAlignmentRight;
                    [mainCell.contentView addSubview:disL];
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(nameL.frame), WIDTH_SCREEN, 20)];
                    btn.tag = 3000 + indexPath.row;
                    [btn addTarget:self action:@selector(selectedTicket:) forControlEvents:UIControlEventTouchUpInside];
                    btn.enabled = NO;
                    [mainCell.contentView addSubview:btn];
                    
                    btn.enabled = YES;
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(WIDTH_SCREEN - 30, CGRectGetMinY(nameL.frame) + 4, 13, 13)];
                    imgView.image = [UIImage imageNamed:@"bian_sanjiao"];
                    [mainCell.contentView addSubview:imgView];
                    
                } else {
                    mainCell.accessoryType = UITableViewCellAccessoryNone;
                }
                
            }
            
            orderTotalPrice += proTotalPrice;
            
            [self bottomViewLoad];
        }
        
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return mainCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        BuyerInfo *buyer = self.mShopModels[indexPath.row];
        return 160 + 105 * buyer.prod_list.count;
    }
    if (isAddress && indexPath.section == 0) {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //跳到选择地址页
        self.addressVC = [[NPYAddressViewController alloc] init];
        self.addressVC.delegate = self;
        [self.navigationController pushViewController:self.addressVC animated:YES];
    }
    
}

- (void)selectedTicketAtIndexPath:(NSIndexPath *)indexPath withTicketInfo:(NPYTicketModel *)ticketModel{
    
    selectedTicketPath = indexPath;
    selectedTicketModel = ticketModel;
    
    UILabel *tpL = [self.view viewWithTag:indexPath.row + 855];
    tpL.text = [NSString stringWithFormat:@"-%@元",ticketModel.reduce];
    
    BuyerInfo *buyer = self.mShopModels[indexPath.row];
    for (ProductInfo *pro in buyer.prod_list) {
        pro.coupon_id = ticketModel.coupon_id;
    }
    
    orderTotalPrice -= [ticketModel.reduce floatValue];
    
    [self bottomViewLoad];
}

- (void)popValue:(NSDictionary *)dic {
    addressDic = [dic copy];
    isAddress = YES;
    
    [self.mainTView reloadData];
}
//tag = 3000
- (void)selectedTicket:(UIButton *)btn {
    //跳到优惠券界面
    BuyerInfo *buyer = self.mShopModels[btn.tag - 3000];
    UILabel *priceL = [self.view viewWithTag:800 + btn.tag - 3000];
    //优惠券
    NPYTicketViewController *ticketVC = [[NPYTicketViewController alloc] init];
    ticketVC.isTicketManage = NO;
    ticketVC.sign = self.sign;
    ticketVC.user_id = self.user_id;
    ticketVC.money = [NSString stringWithFormat:@"%@",priceL.text];
    ticketVC.shop_id = buyer.buyer_id;
    ticketVC.delegate = self;
    if (selectedTicketPath) {
        ticketVC.selectedIndex = selectedTicketPath;
        ticketVC.isSelectTicket = YES;
    }
    [self.navigationController pushViewController:ticketVC animated:YES];
    
}

-(void)viewDidLayoutSubviews
{
    if ([self.mainTView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_mainTView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mainTView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

#pragma mark -

- (NSMutableAttributedString *)attributedStringWithSegmentationString:(NSString *)segStr withOriginalString:(NSString *)orStr withOneColor:(UIColor *)oneColor withTwoColor:(UIColor *)twoColor withOneFontSize:(CGFloat)oneSize twoFontSize:(CGFloat)twoSize {
    NSString *tmp = [orStr componentsSeparatedByString:segStr][0];
    NSMutableAttributedString *mTmp = [[NSMutableAttributedString alloc] initWithString:orStr];
    NSUInteger length = tmp.length;
    if (length == 0) {
        length = 1;
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length, orStr.length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length, orStr.length - 1)];
        
    } else {
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length + 1, orStr.length - length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length + 1, orStr.length - length - 1)];
        
    }
    
    return mTmp;
}

- (CGSize)calculateStringSize:(NSString *)str withFontSize:(CGFloat)fontSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size=[str sizeWithAttributes:attrs];
    
    return size;
}

//5000 (➖)，5001（➕）
- (void)cutAndAddButtonPressed:(UIButton *)btn {
    //
//    UILabel *lab1 = [self.view viewWithTag:btn.tag - (btn.tag >= 5000 ? 5000 : 4000) + 500];
    //proPrice.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",pro.price] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    UILabel *lab2 = [self.view viewWithTag:btn.tag - (btn.tag >= 5000 ? 5000 : 4000) + 600];
    //proCount.text = [NSString stringWithFormat:@"%li",(long)pro.count];
    UILabel *lab3 = [self.view viewWithTag:btn.tag - (btn.tag >= 5000 ? 5000 : 4000) + 700];
    //proTotal.text = [NSString stringWithFormat:@"共 %li 件商品 合计：",(long)pro.count];
    UILabel *lab4 = [self.view viewWithTag:btn.tag - (btn.tag >= 5000 ? 5000 : 4000) + 800];
    //proPrice2.attributedText = proPrice.attributedText;
    
    ProductInfo *pro = self.mGoodsModels[btn.tag - (btn.tag >= 5000 ? 5000 : 4000)];
    
    int value = (int)pro.count;
    switch (btn.tag/1000) {
        case 5:
            value--;
            if (value <= 0) {
                value = 1;
            }
            
            break;
            
        case 4:
            value++;
//            proCount.text = [NSString stringWithFormat:@"%i",value];
            break;
            
        default:
            break;
    }
    pro.count = value;
    
//    proCount.text = [NSString stringWithFormat:@"%i",value];
    lab2.text = [NSString stringWithFormat:@"%i",value];
    
//    double b = [[proPrice.text substringWithRange:NSMakeRange(1,proPrice.text.length - 1)] doubleValue];
//    proTotal.text = [NSString stringWithFormat:@"共 %i 件商品 合计：",value];
    lab3.text = [NSString stringWithFormat:@"共 %i 件商品 合计：",value];
    
//    proPrice2.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",value * b] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    lab4.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",value * pro.price] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
    
    int freightNum = 0;
    double total = 0.00;
    for (int i = 0; i < self.mGoodsModels.count; i++) {
        ProductInfo *pro = self.mGoodsModels[i];
        NSArray *list = pro.model_detail;
        ModelDeatail *detail = list[i];
        freightNum = [[detail valueForKey:@"value"] intValue];
        total += pro.price * pro.count + freightNum;
    }
    
//    totalMoneyL.attributedText = proPrice2.attributedText;
    totalMoneyL.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",total] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:12.0 twoFontSize:17.0];
}

#pragma mark - 提交订单

- (void)submitButtonPressed:(UIButton *)btn {
    //    NSLog(@"提交订单");
    NSMutableArray *mLists = [NSMutableArray new];
    for (int i = 0; i < self.mShopModels.count; i++) {
        BuyerInfo *buyer = self.mShopModels[i];
        for (ProductInfo *pro in buyer.prod_list) {
            if (pro.coupon_id == nil) {
                pro.coupon_id = @"0";
            }
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:pro.prod_id,@"goods_id",pro.remark,@"spec_id",[NSString stringWithFormat:@"%li",(long)pro.count],@"num",pro.coupon_id,@"coupon_id",useIntegral,@"integral", nil];
            [mLists addObject:tempDict];
        }
        
    }
    
    
    self.paymentOrderVC = [[NPYPaymentOrderViewController alloc] init];
    
    self.paymentOrderVC.sign = self.sign;
    self.paymentOrderVC.user_id = self.user_id;
//    self.paymentOrderVC.goods_id = self.goods_id;
//    self.paymentOrderVC.spec_id = [self.goodsSpe valueForKey:@"id"];
    self.paymentOrderVC.address_id = [addressDic valueForKey:@"address_id"];
//    self.paymentOrderVC.coupon_id = selectedTicketModel.coupon_id ? selectedTicketModel.coupon_id : @"0";
//    self.paymentOrderVC.integral = useIntegral;
//    self.paymentOrderVC.num = proCount.text;
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:self.sign,@"sign",self.user_id,@"user_id",[addressDic valueForKey:@"address_id"],@"address_id",mLists,@"list", nil];
    
    [self requetUpdataOrderInfoWithUrlString:SHOP_ORDER_BUY_ONEGOODS_URL withParames:request];
    
}

- (void)calculateFreight {
    orderTotalFreight = 0;
    for (int i = 0; i < self.mShopModels.count; i++) {
        BuyerInfo *buyer = self.mShopModels[i];
        
        proTotalFreight = 0.0;
        
        for (ProductInfo *pro in buyer.prod_list) {
            NSArray *tm = pro.model_detail;
            for (int i = 0; i < tm.count; i++) {
                NSDictionary *dic = tm[i];
                
                proTotalFreight = proTotalFreight > [[dic valueForKey:@"value"] intValue] ? proTotalFreight : [[dic valueForKey:@"value"] intValue];
                
//                 NSLog(@"商品邮费%i",proTotalFreight);
            }
        }
        
        orderTotalFreight += proTotalFreight;
    }
    
//    NSLog(@"总邮费%i",orderTotalFreight);
}

-(void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        //        NSLog(@"使用牛豆");
        useIntegral = @"1";
    }else {
        //        NSLog(@"不用牛豆");
        useIntegral = @"0";
    }
}

#pragma mark - 网络请求

- (void)requestOrderInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NSDictionary *tpDict = dataDict[@"data"];
            NPYAddressModel *addressModel = [NPYAddressModel mj_objectWithKeyValues:tpDict[@"address"]];
            
            addressDic = [NSDictionary dictionaryWithObjectsAndKeys:addressModel.receiver,@"name",addressModel.phone,@"phone",addressModel.detailed,@"address",addressModel.address_id,@"address_id", nil];
            
            isAddress = YES;
            
            proTotalPrice = 0.00;
            proTotalNumber = 0;
            orderTotalPrice = 0.00;
            
            [self.mainTView reloadData];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)requetUpdataOrderInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            
            NSDictionary *resultDict = dataDict[@"data"];
            
            self.paymentOrderVC.order_id = [resultDict valueForKey:@"order_id"];
            self.paymentOrderVC.price = [resultDict valueForKey:@"price"];
            self.paymentOrderVC.order_type = @"order_batch";
            
            [self.navigationController pushViewController:self.paymentOrderVC animated:YES];
            
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

#pragma mark - 懒加载

- (NSMutableArray *)mGoodsSpes {
    if (_mGoodsSpes == nil) {
        _mGoodsSpes = [NSMutableArray new];
    }
    return _mGoodsSpes;
}

- (NSMutableArray *)mShopModels {
    if (_mShopModels == nil) {
        _mShopModels = [NSMutableArray new];
    }
    return _mShopModels;
}

- (NSMutableArray *)mGoodsModels {
    if (_mGoodsModels == nil) {
        _mGoodsModels = [NSMutableArray new];
    }
    return _mGoodsModels;
}

- (NSMutableArray *)mBuyNumbers {
    if (_mBuyNumbers == nil) {
        _mBuyNumbers = [NSMutableArray new];
    }
    return _mBuyNumbers;
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
