//
//  NPYSpecViewController.m
//  牛品云
//
//  Created by Eric on 16/12/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSpecViewController.h"
#import "NPYBaseConstant.h"

#define SpecUrl @"/index.php/app/Getgoods/get_spec"

@interface NPYSpecViewController () {
    NSArray *dataArr;
    NSDictionary *selectedDict;
    double price;
    int buy;
    int oldTag;
}

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice_lab;
@property (weak, nonatomic) IBOutlet UILabel *storNumber_lab;

@property (weak, nonatomic) IBOutlet UIView *midVIew;

- (IBAction)backSuperView:(id)sender;
- (IBAction)cutNumber:(id)sender;
- (IBAction)addNumber:(id)sender;
- (IBAction)addShoppingCar:(id)sender;
- (IBAction)buyGoods:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midView_Height;

@end

@implementation NPYSpecViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    buy = 1;
    
    //评论页网络请求
    NSDictionary *specDic = [NSDictionary dictionaryWithObjectsAndKeys:@"npy_we874646sf",@"key",self.goodsID,@"goods_id", nil];
    [self requestSpecDataWithUrlString:SpecUrl withGoodsID:specDic];
    
}

- (void)viewDidLayoutSubviews {
    
    self.buyNumber_lab.adjustsFontSizeToFitWidth = YES;
    
    [self.goodsIcon sd_setImageWithURL:[NSURL URLWithString:self.goodsIconUrl] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    if (self.storNumber == nil) {
        self.storNumber = @"0";
    }
    self.storNumber_lab.text = [NSString stringWithFormat:@"库存：%@件",self.storNumber];
    
}

- (void)specViewLoad {
    float oldWidth = 0;
    for (int i = 0; i < dataArr.count; i++) {
        UIButton *specBtn = [[UIButton alloc] init];
        UILabel *title_lab = [[UILabel alloc] init];
        
        specBtn.tag = 1020 + i;
        title_lab.tag = 1030 + i;
        
        NSDictionary *tmpDict = dataArr[i];
        NSString *name = [tmpDict valueForKey:@"name"];
        
        title_lab.text = name;
        title_lab.textAlignment = NSTextAlignmentCenter;
        title_lab.font = XNFont(12.0);
        
        CGSize nameSize = [self calculateStringSize:name withFontSize:12.0];
        
        specBtn.frame = CGRectMake(15 + (i * ((int)oldWidth + 40)), 50, nameSize.width + 20, 20);
        title_lab.frame =CGRectMake(15 + (i * ((int)oldWidth + 40)), 50, nameSize.width + 20, 20);
        
        [specBtn setImage:[UIImage imageNamed:@"guige_hui"] forState:UIControlStateNormal];
        [specBtn setImage:[UIImage imageNamed:@"guige_cheng"] forState:UIControlStateSelected];
        
        specBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        specBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentFill;
        
        if (i == _isSlected) {
            specBtn.selected = YES;
            title_lab.textColor = XNColor(255, 255, 255, 1);
            
            oldTag = 1020 + i;
            selectedDict = dataArr[i];
            self.goodsPrice_lab.text = [NSString stringWithFormat:@"￥%.2f",[[selectedDict valueForKey:@"price"] doubleValue] * buy];
            
        } else {
            title_lab.textColor = XNColor(51, 51, 51, 1);
            
        }
        
        oldWidth = nameSize.width;
        
        [specBtn addTarget:self action:@selector(selectedSpecModel:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.midVIew addSubview:specBtn];
        [self.midVIew addSubview:title_lab];
    }
    
    
}

- (void)selectedSpecModel:(UIButton *)btn {
    if (btn.tag == oldTag) {
        return;
    }
    
    buy = 1;
    self.buyNumber_lab.text = [NSString stringWithFormat:@"%i",buy];
    
    UIButton *oldBtn = [self.view viewWithTag:oldTag];
    oldBtn.selected = NO;
    
    btn.selected = YES;
    
    UILabel *tmpLabel = [self.view viewWithTag:btn.tag + 10];
    tmpLabel.textColor = XNColor(255, 255, 255, 1);
    
    UILabel *oldLabel = [self.view viewWithTag:oldTag + 10];
    oldLabel.textColor = XNColor(51, 51, 51, 1);
    
    selectedDict = dataArr[btn.tag - 1020];
    
    self.goodsPrice_lab.text = [NSString stringWithFormat:@"￥%.2f",[[selectedDict valueForKey:@"price"] doubleValue] * buy];
    
    oldTag = (int)btn.tag;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popValue:withNumber:)]) {
        [self.delegate popValue:selectedDict withNumber:[self.buyNumber_lab.text intValue]];
        
        [self.delegate popValue:selectedDict withNumber:[self.buyNumber_lab.text intValue] withIndex:self.indexPath];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)backSuperView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popValue:withNumber:)]) {
        [self.delegate popValue:selectedDict withNumber:[self.buyNumber_lab.text intValue]];
        
        [self.delegate popValue:selectedDict withNumber:[self.buyNumber_lab.text intValue] withIndex:self.indexPath];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cutNumber:(id)sender {
    buy--;
    if (buy <= 0) {
        buy = 1;
    }
    self.buyNumber_lab.text = [NSString stringWithFormat:@"%i",buy];
    self.goodsPrice_lab.text = [NSString stringWithFormat:@"￥%.2f",[[selectedDict valueForKey:@"price"] doubleValue] * buy];
    
}

- (IBAction)addNumber:(id)sender {
    if (buy >= [self.storNumber intValue]) {
        buy = [self.storNumber intValue];
        
    } else {
        buy++;
        
    }
    
    self.buyNumber_lab.text = [NSString stringWithFormat:@"%i",buy];
    self.goodsPrice_lab.text = [NSString stringWithFormat:@"￥%.2f",[[selectedDict valueForKey:@"price"] doubleValue] * buy];
    
}

- (IBAction)addShoppingCar:(id)sender {
    NSString *specID = [selectedDict valueForKey:@"id"];
    NSString *buyNumberStr = [NSString stringWithFormat:@"%i",buy];
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.sign,@"sign",
                                self.goodsID,@"goods_id",
                                self.userID,@"user_id",
                                specID,@"spec_id",
                                buyNumberStr,@"num", nil];
    
    [self requestAddGoodsToShoppingCarUrl:@"/index.php/app/Shopping/set" withParemes:requestDic];
}

- (IBAction)buyGoods:(id)sender {
    
}

- (void)requestSpecDataWithUrlString:(NSString *)url withGoodsID:(NSDictionary *)pareme {
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            dataArr = dataDict[@"data"];
            
            [self specViewLoad];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestAddGoodsToShoppingCarUrl:(NSString *)url withParemes:(NSDictionary *)pareme {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            //            NSDictionary *tpDict = dataDict[@"data"];
            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (CGSize)calculateStringSize:(NSString *)str withFontSize:(CGFloat)fontSize{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size=[str sizeWithAttributes:attrs];
    
    return size;
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
