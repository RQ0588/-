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

@interface NPYDiscusViewController () <TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat _itemWH;
    CGFloat _margin;
    CGRect  editFrame;
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
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohaglan_bg"] forBarMetrics:UIBarMetricsDefault];
    
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
    
    self.wordView = [[NPYPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, WIDTH_SCREEN - 20, 120)];
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
        cell.imagev.image = [UIImage imageNamed:@"AlbumAddBtn"];
        //        cell.imagev.backgroundColor = [UIColor redColor];
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
    starView *star = [[starView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(editFrame) + 10, WIDTH_SCREEN, 50)];
    [self.view addSubview:star];
}

- (void)commentButtonViewLoad {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN - 40, WIDTH_SCREEN, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"发表评论" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)commentButtonPressed:(UIButton *)btn {
    //发表评论按钮点击,提交数据并返回
    
    [self.navigationController popViewControllerAnimated:YES];
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
        _itemWH = (self.view.bounds.size.width - 2 * _margin - 4) / 3 - _margin;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake((WIDTH_SCREEN - 50)/ 6, (WIDTH_SCREEN - 50)/ 6);
        flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
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
