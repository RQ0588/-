//
//  NPYDetailCenterViewController.m
//  牛品云
//
//  Created by Eric on 16/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSettingViewController.h"
#import "NPYBaseConstant.h"
#import "NPYSettingTVCell.h"
#import "NPYShopCollectionTableViewCell.h"
#import "NPYLoginViewController.h"
#import "NPYRetrievePWDetailViewController.h"
#import "NPYSettingDetailViewController.h"
#import "NPYAddressViewController.h"

#define Updata_Image_Url @"/index.php/app/User/update_img"
#define Updata_UserName_Url @"/index.php/app/User/update_name"

@interface NPYSettingViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZHTextAlertDelegate> {
    UITableView     *mainTableView;
    NSInteger   row;
    CGFloat     hegiht,topSep;
    NSArray     *dataArray;
    NSString *newName;
}

@property (nonatomic, strong) NPYLoginViewController    *loginVC;
@property (nonatomic, strong) NPYRetrievePWDetailViewController     *pwVC;
@property (nonatomic, strong) NPYAddressViewController              *addressVC;

@property (nonatomic, strong) UIImage *headerImg;

@property (nonatomic,strong)UIAlertController *alertController;

@end

@implementation NPYSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.titleStr;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    NSString *requestUrl;
    NSDictionary *requestDic;
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    if ([self.titleStr isEqualToString:@"设置"]) {
        //设置页
        row = 5;
        hegiht = 46;
        dataArray = @[@"头像",@"用户名",@"修改登录密码",@"地址管理",@"关于"];
        
    } else if ([self.titleStr isEqualToString:@"我的牛豆"]) {
        //我的牛豆页
//        row = 1;
//        hegiht = 40;
//        dataArray = @[@"获取",@"使用"];
        
    } else if ([self.titleStr isEqualToString:@"店铺收藏"]) {
        //店铺收藏
        topSep = 10;
        row = dataArray.count;
        hegiht = 70;
        dataArray = @[@"大明食品旗舰店",@"company官方店"];
        
        requestUrl = @"/index.php/app/Collect/get_shop";
        requestDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",@"1",@"num",model.user_id,@"user_id", nil];
    }
    
    [self mainViewLoad];
    
    //拍照或打开相册控制器
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 ) {
        [self setupCameraView];
    }
    
    [self requestDataWithUrlString:requestUrl withKeyValueParemes:requestDic];
    
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    mainTableView.backgroundColor = GRAY_BG;
    [self.view addSubview:mainTableView];
    
    mainTableView.separatorColor = GRAY_BG;
    mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, topSep)];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hegiht;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.titleStr isEqualToString:@"设置"]) {
        
        mainTableView.scrollEnabled = NO;
        
        static NSString *identifier = @"cell";
        NPYSettingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYSettingTVCell" owner:nil options:nil] firstObject];
            cell.funName.text = dataArray[indexPath.row];
            
            if (indexPath.row == 0) {
//                [cell.headPortrait sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                cell.headPortrait.image = self.headerImg;
            } else {
                cell.headPortrait.hidden = YES;
            }
        }
        
        UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, hegiht * row + 90, WIDTH_SCREEN - 16, 44)];
        [outBtn setBackgroundImage:[UIImage imageNamed:@"hongikuang_dl"] forState:UIControlStateNormal];
        [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        outBtn.backgroundColor = [UIColor redColor];
        [outBtn addTarget:self action:@selector(outLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:outBtn];
        
        return cell;
        
    } else if ([self.titleStr isEqualToString:@"我的牛豆"]) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
            
            cell.textLabel.text = dataArray[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
        
    } else if ([self.titleStr isEqualToString:@"店铺收藏"]) {
//        mainTableView.scrollEnabled = NO;
        
        static NSString *identifier = @"cell";
        NPYShopCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NPYShopCollectionTableViewCell" owner:nil options:nil] firstObject];
//            cell.shopName = dataArray[indexPath.row];
            
            NPYShopModel *model = [NPYShopModel mj_objectWithKeyValues:dataArray[indexPath.row]];
            cell.shopName.text = model.shop_name;
            [cell.shopIcon sd_setImageWithURL:[NSURL URLWithString:model.shop_img] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
            cell.shopCity.text = model.shop_province;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.titleStr isEqualToString:@"设置"]) {
        if (indexPath.row == 0) {
            if (self.alertController != nil) {
                [self presentViewController:self.alertController animated:YES completion:^{
                    
                }];
            }else{
                [self setupCameraViewBelow8];
                
            }
        }
        //修改用户名
        if (indexPath.row == 1) {
            ZHTextAlertView *textAlertView = [ZHTextAlertView alertViewDefault];
            textAlertView.titleLabel.text = @"修改用户名";
            textAlertView.textField.placeholder = @"输入新的用户名";
            textAlertView.delegate = self;
            [textAlertView show];
        }
        
        if (indexPath.row == 2) {
            self.pwVC = [[NPYRetrievePWDetailViewController alloc] init];
            self.pwVC.titleName = @"修改登录密码";
            [self.navigationController pushViewController:self.pwVC animated:YES];
        }
        //地址管理
        if (indexPath.row == 3) {
            self.addressVC = [[NPYAddressViewController alloc] init];
            [self.navigationController pushViewController:self.addressVC animated:YES];
        }
        
        if (indexPath.row == 4) {
            //关于
            NPYSettingDetailViewController *aboutVC = [[NPYSettingDetailViewController alloc] initWithNibName:@"NPYSettingDetailViewController" bundle:nil];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        
    } else if ([self.titleStr isEqualToString:@"我的牛豆"]) {
        
        
    }
}

- (void)alertView:(ZHTextAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex alertText:(NSString*)alertText {
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",alertText,@"new_name", nil];
    newName = alertText;
    if (buttonIndex == 0) {
        return;
    } else {
        [self requestUpdataUserNameWithUrlString:Updata_UserName_Url withParames:request];
    }
    
}

#pragma mark - 更改tableView的分割线顶格显示
- (void)viewDidLayoutSubviews
{
    if ([mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

- (void)requestDataWithUrlString:(NSString *)url withKeyValueParemes:(NSDictionary *)pareme {
    
    if (pareme == nil) {
        return;
    }
    
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"请求成功" inView:self.view];
            NPYHomeModel *model = [[NPYHomeModel alloc] init];
            model.shopArr = dataDict[@"data"];
            [model toDetailModel];
            dataArray = [model returnShopModelArray];
            
            row = dataArray.count;
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
        [mainTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestUpdataUserNameWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:mainTableView];
            
            NSMutableDictionary *userDict = [[NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local] mutableCopy];
            NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
            userModel.user_name = newName;
            
            [userDict removeObjectForKey:@"data"];
            
            NSDictionary *tp = [NSDictionary dictionaryWithObjectsAndKeys:userModel.integral,@"integral",userModel.type,@"type",userModel.user_id,@"user_id",userModel.user_name,@"user_name",userModel.user_phone,@"user_phone",userModel.user_portrait,@"user_portrait",userModel.user_time,@"user_time",userModel.r,@"r",userModel.sign,@"sign", nil];
            
            [userDict setObject:tp forKey:@"data"];
            
            [NPYSaveGlobalVariable saveValueAtLocal:userDict withKey:LoginData_Local];
            
        } else {
            //失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:mainTableView];
        }
        
        [mainTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - 相册相机

-(void)setupCameraViewBelow8
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 1) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
        
    }else if(buttonIndex == 2) {
        
    }
    
}

-(void)setupCameraView
{
    //    UIColor *showColor = [UIColor colorWithRed:0/255.0 green:152/255.0 blue:234/255.0 alpha:0.85];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //     [self.bg removeFromSuperview];
        [self.alertController.view setTintColor:[UIColor blackColor]];
        
    }];
    //    [cancelAc setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    UIAlertAction *openCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            [self takePhoto];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
    //    [openCamera setValue:showColor forKey:@"titleTextColor"];
    
    UIAlertAction *openAlbum = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
    }];
    //    [openAlbum setValue:showColor forKey:@"titleTextColor"];
    
    [ac addAction:cancelAc];
    [ac addAction:openCamera];
    [ac addAction:openAlbum];
    [ac.view setTintColor:[UIColor blackColor]];
    self.alertController = ac;
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.headerImg = iconImage;
    
//    NSData *imageData = UIImageJPEGRepresentation(iconImage, 1);
    
    iconImage = [self imageWithImage:iconImage scaledToSize:CGSizeMake(200, 200)];
    NSData *imageData = UIImageJPEGRepresentation(iconImage, 1);
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *pareme = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id", nil];
    
    [self updataImageToServerWithUrl:Updata_Image_Url withParames:pareme withImageData:(NSData *)imageData];
    
    [mainTableView reloadData];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - UIButton

- (void)outLoginButtonPressed:(UIButton *)btn {
    //退出登录
//    NSLog(@"退出登录...");
    //从阿里推送移除别名
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    [CloudPushSDK removeAlias:model.user_id withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"removeAlias success");
        }
    }];
    
    self.loginVC = [[NPYLoginViewController alloc] init];
    [self.navigationController pushViewController:self.loginVC animated:YES];
}

- (UIImage *)headerImg {
    if (_headerImg == nil) {
        UIImageView *tmp = [UIImageView new];
        NSString *isLogin = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginState];
        if ([isLogin intValue] == 1) {
            NSDictionary *loginData = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
            NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:loginData[@"data"]];
            
            NSString *portrait = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LocalPortrait];
            if (portrait) {
                [tmp sd_setImageWithURL:[NSURL URLWithString:portrait] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
                
            } else {
                
                [tmp sd_setImageWithURL:[NSURL URLWithString:userModel.user_portrait] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
            }
            
//            userName.text = userModel.user_name;
        }
//        [tmp sd_setImageWithURL:[NSURL new] placeholderImage:[UIImage imageNamed:@"touxiang_zc"]];
        _headerImg = [[UIImage alloc] init];
        _headerImg = tmp.image;
    }
    
    return _headerImg;
}

- (void)updataImageToServerWithUrl:(NSString *)url withParames:(NSDictionary *)pareme withImageData:(NSData *)imageData{
    
    if (pareme == nil) {
        return;
    }
    
    NSMutableDictionary *paremes = [[NSMutableDictionary alloc] init];
    [paremes setObject:[NPYChangeClass dictionaryToJson:pareme] forKey:@"data"];
//    [paremes setObject:imageData forKey:@"img"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:paremes constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(self.headerImg,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"img"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"");
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
//        [ZHProgressHUD showMessage:[responseObject valueForKey:@"data"] inView:self.view];
        [ZHProgressHUD showMessage:@"修改成功" inView:self.view];
        
        [NPYSaveGlobalVariable saveValueAtLocal:[responseObject valueForKey:@"data"] withKey:LocalPortrait];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"");
    }];
    
    
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
