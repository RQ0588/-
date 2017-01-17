//
//  NPYCIFilterViewController.m
//  牛品云
//
//  Created by Eric on 17/1/16.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "NPYCIFilterViewController.h"
#import "NPYBaseConstant.h"

@interface NPYCIFilterViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation NPYCIFilterViewController

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的二维码";
    
    self.view.backgroundColor = GRAY_BG;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    [self viewInit];
}

//创建过滤器
- (void)viewInit {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认
    [filter setDefaults];
    //添加数据
    NSDictionary *userDic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDic[@"data"]];
    
    NSString *dataString = [NSString stringWithFormat:@"npy:add%@",userModel.user_id];
    
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //获取输出的二维码
    CIImage *outImage = [filter outputImage];
    //将CIImage转换成UIImage
    self.imgView.image = [self createNonInterpolatedUIImageFormCIImage:outImage withSize:200];
    
    [self.view addSubview:self.imgView];
}

//根据CIImage生成指定大小的UIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(0, 0, 200, 200);
        _imgView.center = CGPointMake(WIDTH_SCREEN/2, HEIGHT_SCREEN/2);
    }
    return _imgView;
    
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
