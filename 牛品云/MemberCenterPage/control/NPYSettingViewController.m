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
#import "NPYLoginViewController.h"

@interface NPYSettingViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UITableView     *mainTableView;
    NSInteger   row;
    CGFloat     hegiht;
    NSArray     *dataArray;
}

@property (nonatomic, strong) NPYLoginViewController    *loginVC;

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
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.titleStr;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    if ([self.titleStr isEqualToString:@"设置"]) {
        //设置页
        row = 5;
        hegiht = 60;
        dataArray = @[@"头像",@"用户名",@"修改登录密码",@"地址管理",@"关于"];
        
    } else if ([self.titleStr isEqualToString:@"我的牛豆"]) {
        //我的牛豆页
        row = 2;
        hegiht = 40;
        dataArray = @[@"获取",@"使用"];
    }
    
    [self mainViewLoad];
    
    //拍照或打开相册控制器
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0 ) {
        [self setupCameraView];
    }
}

- (void)mainViewLoad {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.titleStr isEqualToString:@"设置"]) {
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
        
        UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, HEIGHT_SCREEN / 2, WIDTH_SCREEN - 20, 40)];
        [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        outBtn.backgroundColor = [UIColor redColor];
        outBtn.layer.cornerRadius = 5;
        outBtn.layer.masksToBounds = YES;
        [outBtn addTarget:self action:@selector(outLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:outBtn];
        
        return cell;
        
    } else if ([self.titleStr isEqualToString:@"我的牛豆"]) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cell.textLabel.text = dataArray[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        
    } else if ([self.titleStr isEqualToString:@"我的牛豆"]) {
        
        
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
    NSLog(@"退出登录...");
    
    self.loginVC = [[NPYLoginViewController alloc] init];
    [self.navigationController pushViewController:self.loginVC animated:YES];
}

- (UIImage *)headerImg {
    if (_headerImg == nil) {
        UIImageView *tmp = [UIImageView new];
        [tmp sd_setImageWithURL:[NSURL new] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _headerImg = [[UIImage alloc] init];
        _headerImg = tmp.image;
    }
    
    return _headerImg;
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
