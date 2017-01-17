//
//  NPYDiscusViewController.m
//  牛品云
//
//  Created by Eric on 16/11/28.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYDiscusViewController.h"
#import "NPYBaseConstant.h"
#import "NPYPlaceHolderTextView.h"
#import "TZImagePickerController.h"
#import "CollectionViewCell.h"
#import "starView.h"

#define Appraise_Url @"/index.php/app/Order/set_appraise"

@interface NPYDiscusViewController () <TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat _itemWH;
    CGFloat _margin;
    CGRect  editFrame;
    UILabel *addL;
    
    starView *star;
}

@property (nonatomic, strong) NPYPlaceHolderTextView    *wordView;

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;
@property BOOL isSelectOriginalPhoto;

@end

@implementation NPYDiscusViewController

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
    
    self.view.backgroundColor = GRAY_BG;
    
    self.navigationItem.title = @"发表评论";
    
    [self editViewLoad];
    
    [self starViewLoad];
    
    [self commentButtonViewLoad];
}

#pragma mark - 编辑评语

- (void)editViewLoad {
    [self.view addSubview:[UIView new]];
    
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, WIDTH_SCREEN, 200)];
    editView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editView];
    
    editFrame = editView.frame;
    
    self.wordView = [[NPYPlaceHolderTextView alloc] initWithFrame:CGRectMake(14, 10, WIDTH_SCREEN - 20, 120)];
    self.wordView.font = XNFont(14.0);
    self.wordView.placeholder = @"限140字~";
    self.wordView.layer.borderWidth = 1.0;
    self.wordView.layer.borderColor = GRAY_BG.CGColor;
    self.wordView.scrollEnabled = YES;
    self.wordView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.wordView.contentSize = CGSizeMake(0, 0);
    [self.wordView becomeFirstResponder];
    [editView addSubview:self.wordView];
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.wordView.frame), WIDTH_SCREEN, 80);
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [editView addSubview:self.collectionView];
    
    addL = [[UILabel alloc] initWithFrame:CGRectMake(65, CGRectGetMaxY(editView.frame) - 45, 100, 20)];
    addL.text = @"添加图片";
    addL.textColor = XNColor(170, 170, 170, 1);
    addL.font = XNFont(14.0);
    [self.view addSubview:addL];
}

#pragma mark - 从相册获取图片

- (void)checkLocalPhoto{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    imagePicker.maxImagesCount = 3;//最多选择3张
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.photosArray = [NSMutableArray arrayWithArray:photos];
    self.assestArray = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    
    addL.frame = CGRectMake(_photosArray.count * 50 + 65, CGRectGetMinY(addL.frame), 100, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photosArray.count && _photosArray.count != 3) {
        [self checkLocalPhoto];
    } else if (indexPath.row == 3) {
        [ZHProgressHUD showMessage:@"最多添加3张图片" inView:self.view];
        
    } else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        imagePickerVc.maxImagesCount = 3;//最多选择3张
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _photosArray = [NSMutableArray arrayWithArray:photos];
            _assestArray = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_photosArray.count + 2) / 3 ) * (_margin + _itemWH));
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photosArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == _photosArray.count) {
        cell.imagev.image = [UIImage imageNamed:@"tiantu_icon"];
        cell.deleteButton.hidden = YES;
        
    }else{
        cell.imagev.image = _photosArray[indexPath.row];
        cell.deleteButton.hidden = NO;
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)deletePhotos:(UIButton *)sender{
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-100 inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

#pragma mark - 满意度 评星

- (void)starViewLoad {
    star = [[starView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(editFrame) + 10, WIDTH_SCREEN, 50)];
    [self.view addSubview:star];
}

- (void)commentButtonViewLoad {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN - 40, WIDTH_SCREEN, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"发表评论" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = XNFont(18.0);
    [self.view addSubview:btn];
}

- (void)commentButtonPressed:(UIButton *)btn {
    //发表评论按钮点击,提交数据并返回
    if (self.wordView.text.length <= 0) {
        [ZHProgressHUD showMessage:@"填写评语" inView:self.view];
        return;
    }
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",self.order_id,@"order_id",star.number_label.text,@"score",self.wordView.text,@"content", nil];
    
    [self requestAppraiseInfoWithUrlString:Appraise_Url withParames:request];
}

#pragma mark - 懒加载

- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (NSMutableArray *)assestArray{
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _margin = 4;
//        _itemWH = (self.view.bounds.size.width - 2 * _margin - 4) / 3 - _margin;
        _itemWH = 40;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(40, 40);
        flowLayOut.sectionInset = UIEdgeInsetsMake(14, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, WIDTH_SCREEN, 300) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.wordView resignFirstResponder];
    [self.view resignFirstResponder];
}

- (void)requestAppraiseInfoWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    if (parame == nil) {
        return;
    }
    
    NSMutableDictionary *paremes = [[NSMutableDictionary alloc] init];
    [paremes setObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
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
    
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSArray *imgNames = @[@"img1",@"img2",@"img3"];
        for (int i = 0; i < _photosArray.count; i++) {
            NSData *imageData =UIImageJPEGRepresentation(_photosArray[i],1);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:imgNames[i]
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
            
        }
        
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"");
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        [ZHProgressHUD showMessage:[responseObject valueForKey:@"data"] inView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"%@",error);
        
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
