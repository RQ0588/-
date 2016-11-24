//
//  ScanViewController.m
//  Uhome
//
//  Created by silkiOS on 16/7/12.
//  Copyright © 2016年 Uhome. All rights reserved.
//

#import "ScanViewController.h"
#import "AVCaptureSession+ZZYQRCodeAndBarCodeExtension.h"
//#import "ScanToWebViewController.h"
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL isOpen;
}
@property (nonatomic, strong) CADisplayLink *link;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanTop;

@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation ScanViewController
-(UIImage *)imageWithColor:( UIColor  *)color size:( CGSize )size
{
    @autoreleasepool  {
        CGRect  rect =  CGRectMake ( 0 ,  0 , size. width , size. height );
        UIGraphicsBeginImageContext (rect. size );
        CGContextRef  context =  UIGraphicsGetCurrentContext ();
        CGContextSetFillColorWithColor (context,color. CGColor );
        CGContextFillRect (context, rect);
        UIImage  *img =  UIGraphicsGetImageFromCurrentImageContext ();
        UIGraphicsEndImageContext ();
        return  img;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self starScan];

}
-(void)starScan
{
    isOpen = YES;
    // Do any additional setup after loading the view.
    // 添加跟屏幕刷新频率一样的定时器
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(scan)];
    self.link = link;
    
    //    // 获取读取条形码的会话
    self.session = [AVCaptureSession readBarCodeWithMetadataObjectsDelegate:self];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];

    // 创建预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.frame = self.view.bounds;
    // 插入到最底层
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    self.toolsButton.layer.cornerRadius = 35.0f;
    self.toolsButton.layer.masksToBounds = YES;

    }
// 在页面将要显示的时候添加定时器
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session startRunning];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor clearColor] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];

//    self.navigationController.navigationBar.translucent = YES;
}

// 在页面将要消失的时候移除定时器
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
 //扫描效果
- (void)scan{
    self.scanTop.constant -= 1;
    if (self.scanTop.constant <= -300) {
        self.scanTop.constant = 300;
    }
}


#pragma mark ---------------------AVCaptureMetadataOutputObjectsDelegate--------------------

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        // 停止扫描
        [self.session stopRunning];
        // 获取信息
        AVMetadataMachineReadableCodeObject *object = metadataObjects.lastObject;
        
        // 弹窗提示
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Result" message:[NSString stringWithFormat:@"%@",object.stringValue] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
//        [alertView show];
        
        [self loadSkuNumWithSku:object.stringValue];
    }
}


-(void)loadSkuNumWithSku:(NSString *)sku
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"http://sales.uhomecorp.com/api/rest/getProductUrl/%@",sku];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        id json = responseObject;
        
//        NSString *nextUrl = json[@"data"];
        NSString *code    = json[@"code"];
        
        if (code.intValue == 1)
        {
//            ScanToWebViewController *scanToWebVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanToWebViewController"];
//                
//            scanToWebVC.webUrl = nextUrl;
//                
//            [self.navigationController pushViewController:scanToWebVC animated:YES];
        }
        else
        {
            // 弹窗提示
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无产品" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
                    [alertView show];
            [self.session startRunning];
            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }

    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"失败");
    }];
}
- (IBAction)testButtonAction:(id)sender
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        if (isOpen)
        {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOn];
            [device unlockForConfiguration];
            [self.toolsButton setTitle:@"关灯" forState:(UIControlStateNormal)];
        }
        else
        {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
            [self.toolsButton setTitle:@"开灯" forState:(UIControlStateNormal)];
        }
        isOpen = !isOpen;
    }

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
