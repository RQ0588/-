//
//  NPYAfter_SalesViewController.m
//  牛品云
//
//  Created by Eric on 16/12/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYAfter_SalesViewController.h"
#import "NPYPlaceHolderTextView.h"
#import "NPYBaseConstant.h"

@interface NPYAfter_SalesViewController () {
    UIImageView *proIcon;
    UILabel *proName,*proCountL,*proPriceL;
    
    UIView *topView,*midView;
}

@property (nonatomic, strong) NPYPlaceHolderTextView    *wordView;

@end

@implementation NPYAfter_SalesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"售后/退款";
    
    self.view.backgroundColor = GRAY_BG;
    
    [self topViewLoad];
    
    [self midViewLoad];
    
    [self bottomViewLoad];
    
    [self detailInfonViewLoad];
}

- (void)topViewLoad {
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, WIDTH_SCREEN, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    //
    proIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 80, 80)];
    proIcon.image = [UIImage imageNamed:@"anli1_gouwu"];
    proIcon.contentMode = UIViewContentModeScaleToFill;
    [topView addSubview:proIcon];
    //
    proName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proIcon.frame) + 13, CGRectGetMinY(proIcon.frame), WIDTH_SCREEN - CGRectGetMaxX(proIcon.frame) - 28, 30)];
    proName.text = @"八杂市 2016年新米东北五常稻花香大米2.5kg黑龙江五常粳米5斤";
    proName.textColor = XNColor(35, 35, 35, 1);
    proName.font = [UIFont systemFontOfSize:12.0];
    proName.numberOfLines = 0;
    [topView addSubview:proName];
    //
    UILabel *tpL = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 114, CGRectGetMaxY(proIcon.frame) - 20, 100, 20)];
    tpL.text = @"合计：";
    tpL.textColor = XNColor(153, 153, 153, 1);
    tpL.font = XNFont(11.0);
    [topView addSubview:tpL];
    
    proPriceL = [[UILabel alloc] init];
    proPriceL.frame = CGRectMake(WIDTH_SCREEN - 80, CGRectGetMaxY(proIcon.frame) - 20, 80, 20);
    proPriceL.adjustsFontSizeToFitWidth = YES;
    proPriceL.numberOfLines = 0;
    proPriceL.attributedText = [self attributedStringWithSegmentationString:@"￥" withOriginalString:[NSString stringWithFormat:@"￥%.2f",38.80] withOneColor:XNColor(248, 31, 31, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:11.0 twoFontSize:17.0];
    [topView addSubview:proPriceL];
    //
    proCountL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(proName.frame), CGRectGetMinY(proPriceL.frame), 100, 20)];
    proCountL.text = [NSString stringWithFormat:@"共%i件商品",1];
    proCountL.textColor = XNColor(153, 153, 153, 1);
    proCountL.font = XNFont(11.0);
    [topView addSubview:proCountL];
}

- (void)midViewLoad {
    midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 10, WIDTH_SCREEN, 100)];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    
    UILabel *afterL = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, WIDTH_SCREEN - 28, 15)];
    afterL.attributedText = [self attributedStringWithSegmentationString:@"*" withOriginalString:[NSString stringWithFormat:@"售后类型 *"] withOneColor:XNColor(17, 17, 17, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:14.0 twoFontSize:14.0];
    [midView addSubview:afterL];
    
    UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(afterL.frame) + 10, WIDTH_SCREEN - 28, 40)];
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"huikuang_shouhou"] forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectedWithModel:) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:selectedBtn];
    
    UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectMake(28, CGRectGetMinY(selectedBtn.frame) + 10, 200, 20)];
    tmpL.text = @"—选择售后类型—";
    tmpL.textColor = XNColor(153, 153, 153, 1);
    tmpL.font = XNFont(14.0);
    [midView addSubview:tmpL];
    
    UIButton *tmpBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN - 40, CGRectGetMinY(tmpL.frame) + 4, 12, 12)];
    tmpBtn.tag = 1010;
    UIImage *norImg = [UIImage imageNamed:@"jtxia_zhongchou"];
    UIImage *selImg = [UIImage imageNamed:@"jtshang_zhongchou-"];
    [tmpBtn setImage:norImg forState:UIControlStateNormal];
    [tmpBtn setImage:selImg forState:UIControlStateSelected];
    [midView addSubview:tmpBtn];
    
    UIImage *sepLine = [UIImage imageNamed:@"750huixian_92"];
    UIImageView *sepLineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, midView.frame.size.height - 2, WIDTH_SCREEN, 1)];
    sepLineImgV.image = sepLine;
//    sepLineImgV.backgroundColor = [UIColor grayColor];
    [midView addSubview:sepLineImgV];
}

- (void)bottomViewLoad {
    UIButton *comBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN - 50, WIDTH_SCREEN, 50)];
    [comBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [comBtn setTitleColor:XNColor(255, 255, 255, 1) forState:UIControlStateNormal];
    comBtn.titleLabel.font = XNFont(18.0);
    comBtn.backgroundColor = XNColor(248, 31, 31, 1);
    [comBtn addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comBtn];
    
}

- (void)detailInfonViewLoad {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(midView.frame), WIDTH_SCREEN, 240)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *afterL = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, WIDTH_SCREEN - 28, 15)];
    afterL.attributedText = [self attributedStringWithSegmentationString:@"*" withOriginalString:[NSString stringWithFormat:@"售后原因 *"] withOneColor:XNColor(17, 17, 17, 1) withTwoColor:XNColor(248, 31, 31, 1) withOneFontSize:14.0 twoFontSize:14.0];
    [bottomView addSubview:afterL];
    
    self.wordView = [[NPYPlaceHolderTextView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(afterL.frame) + 10, WIDTH_SCREEN - 20, 120)];
    self.wordView.font = XNFont(14.0);
    self.wordView.placeholder = @"限140字~";
    self.wordView.layer.borderWidth = 1.0;
    self.wordView.layer.borderColor = GRAY_BG.CGColor;
    self.wordView.scrollEnabled = YES;
    self.wordView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.wordView.contentSize = CGSizeMake(0, 0);
    [self.wordView becomeFirstResponder];
    [bottomView addSubview:self.wordView];
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
        
    } else if (length == orStr.length - 1) {
        length = orStr.length - 2;
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:oneSize] range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:twoSize] range:NSMakeRange(length + 1, orStr.length - length - 1)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:oneColor range:NSMakeRange(0, length)];
        [mTmp addAttribute:NSForegroundColorAttributeName value:twoColor range:NSMakeRange(length + 1, orStr.length - length - 1)];
        
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

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)selectedWithModel:(UIButton *)sender {
    //
    UIButton *tpBtn = [midView viewWithTag:1010];
    tpBtn.selected = !tpBtn.selected;
    
}

- (void)submitButtonPressed:(UIButton *)sender {
    //
    
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
