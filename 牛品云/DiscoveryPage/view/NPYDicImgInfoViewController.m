//
//  NPYDicImgInfoViewController.m
//  牛品云
//
//  Created by Eric on 16/12/5.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDicImgInfoViewController.h"
#import "NPYBaseConstant.h"

@interface NPYDicImgInfoViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *infoImgView;

@end

@implementation NPYDicImgInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = GRAY_BG;
    
    self.navigationItem.title = @"项目详情";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    
    self.infoImgView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
    
    [self.infoImgView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"bottleBkg"]];
    
    UIImage *img = self.infoImgView.image;
    self.infoImgView.frame = CGRectMake(0, 0, WIDTH_SCREEN, img.size.height);
    self.infoImgView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(0, img.size.height);
    
    [self.scrollView addSubview:self.infoImgView];
    
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
