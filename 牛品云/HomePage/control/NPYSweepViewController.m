//
//  NPYSweepViewController.m
//  牛品云
//
//  Created by Eric on 16/11/7.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSweepViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ZHTextAlertView.h"
#import "ZHAttAlertView.h"
#import "ZHProgressHUD.h"
#import "ZHActionSheet.h"
#import "ZHActionSheetView.h"

#import "NPYBaseConstant.h"

#define ADDFRIEND_URL @"/index.php/app/Moments/set_friends"

@interface NPYSweepViewController () <AVCaptureMetadataOutputObjectsDelegate,ZHTextAlertDelegate,ZHAttAlertDelegate,DownSheetDelegate> {
    int number;
    NSTimer *timer;
    NSInteger _count;
    BOOL upOrdown;
    AVCaptureDevice *lightDevice;
    
    ZHAttAlertView *zhAlertView;
}

@property (nonatomic,strong) UIView *centerView;//扫描的显示视图

@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,retain) UIImageView *imageView;//扫描线

@end

@implementation NPYSweepViewController

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.translucent = YES;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
//        [ZHProgressHUD showMessage:errorStr inView:self.view];
        return;
    } else if (authStatus == AVAuthorizationStatusNotDetermined){
        //许可对话没有出现，发起授权许可
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) {
                //第一次用户接受
                if ([self isCameraAvailable] && [self isRearCameraAvailable]) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanningAnimation) userInfo:nil repeats:YES];
                    [self setupCamera];
                    
                } else {
//                    [ZHProgressHUD showMessage:@"相机不可用" inView:self.view];
                }
                
            }else{
                //用户拒绝
            }
        }];
        
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        //已经开启授权，可以继续
        if ([self isCameraAvailable] && [self isRearCameraAvailable]) {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanningAnimation) userInfo:nil repeats:YES];
            [self setupCamera];
            
        }else {
//            [ZHProgressHUD showMessage:@"相机不可用" inView:self.view];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _count = 0 ;
    //初始化闪光灯设备
    lightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //扫描范围
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_centerView];
    
    //扫描的视图加载
    UIView *scanningViewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    scanningViewOne.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.centerView addSubview:scanningViewOne];
    
    UIView *scanningViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 120, (self.view.frame.size.width-300)/2, 300)];
    scanningViewTwo.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.centerView addSubview:scanningViewTwo];
    
    UIView *scanningViewThree = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2+150, 120, (self.view.frame.size.width-300)/2, 300)];
    scanningViewThree.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.centerView addSubview:scanningViewThree];
    
    UIView *scanningViewFour = [[UIView alloc]initWithFrame:CGRectMake(0, 420, self.view.frame.size.width,CGRectGetHeight(self.view.frame)- 420)];
    scanningViewFour.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.centerView addSubview:scanningViewFour];
    
    
    UILabel *labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 430, self.view.frame.size.width - 30, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"请将企业邀请码放入扫描框内";
    [self.centerView addSubview:labIntroudction];
    
    UIButton *openLight = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-25, 470, 50, 50)];
    [openLight setImage:[UIImage imageNamed:@"灯泡"] forState:UIControlStateNormal];
    [openLight setImage:[UIImage imageNamed:@"灯泡2"] forState:UIControlStateSelected];
    [openLight addTarget:self action:@selector(openLightWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:openLight];
    
    //扫描线
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-110, 130, 220, 5)];
    _imageView.image = [UIImage imageNamed:@"scanning@3x"];
    [self.centerView addSubview:_imageView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.translucent = YES;
    
    _count= 0;
    [timer invalidate];
    [self stopReading];
}

#pragma mark -- 设置参数
- (void)setupCamera {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新界面
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = CGRectMake(0, 0, CGRectGetWidth(self.centerView.frame), CGRectGetHeight(self.centerView.frame));
            [self.centerView.layer insertSublayer:self.preview atIndex:0];
            [_session startRunning];
        });
    });
}

//扫描动画
- (void)scanningAnimation {
    if (upOrdown == NO) {
        number ++;
        _imageView.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-115, 130+2*number, 230, 5);
        if (2*number == 280) {
            upOrdown = YES;
        }
    }
    else {
        number --;
        _imageView.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-115, 130+2*number, 230, 5);
        if (number == 0) {
            upOrdown = NO;
        }
    }
}

- (void)stopReading {
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [timer invalidate];
    timer = nil ;
}

-(void)openLightWay:(UIButton *)sender {
    
    if (![lightDevice hasTorch]) {//判断是否有闪光灯
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前设备没有闪光灯，不能提供手电筒功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [lightDevice lockForConfiguration:nil];
        [lightDevice setTorchMode:AVCaptureTorchModeOn];
        [lightDevice unlockForConfiguration];
    }
    else
    {
        [lightDevice lockForConfiguration:nil];
        [lightDevice setTorchMode: AVCaptureTorchModeOff];
        [lightDevice unlockForConfiguration];
    }
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *stringValue;
    if ([metadataObjects count] >0){
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"%@",stringValue);
    }
    [_session stopRunning];
    [timer invalidate];
    _count ++ ;
    [self stopReading];
    if (stringValue && _count == 1) {
        //扫描完成
        //npy:add这是前缀
        stringValue = [stringValue substringFromIndex:6];
        
        NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
        NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
        
        NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",stringValue,@"friend_user_id", nil];
        
        [self requestAddFriendInfoWithUrlString:ADDFRIEND_URL withParames:request];
        
    }
}

#pragma mark - 
- (void)requestAddFriendInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"添加成功" inView:self.view];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - ZHAlertView

-(void) didSelectIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个", index);
}
- (void)alertView:(ZHTextAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex alertText:(NSString *)alertText
{
    if (buttonIndex == 1) {
        NSLog(@"文本输入=%@", alertText);
    }
}
- (void)alertView:(ZHAttAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
    }
}

#pragma mark - 摄像头和相册相关的公共类
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
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
