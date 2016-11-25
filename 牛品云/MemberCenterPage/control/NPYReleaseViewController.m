//
//  NPYViewController.m
//  牛品云
//
//  Created by Eric on 16/11/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYReleaseViewController.h"
#import "NPYBaseConstant.h"
#import "TZImagePickerController.h"
#import "CollectionViewCell.h"
#import "NPYPlaceHolderTextView.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@interface NPYReleaseViewController () <TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) NPYPlaceHolderTextView *wordView;

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,strong) NSMutableArray *assestArray;
@property BOOL isSelectOriginalPhoto;

@end

@implementation NPYReleaseViewController

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
        flowLayOut.itemSize = CGSizeMake((Kwidth - 50)/ 6, (Kwidth - 50)/ 6);
        flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, Kwidth, 300) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"发布朋友圈";
    
    self.view.backgroundColor = GRAY_BG;
    
    [self navigationViewLoad];
    
    [self editViewLoad];
}

- (void)navigationViewLoad {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohaglan_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)editViewLoad {
    [self.view addSubview:[UIView new]];
    
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, WIDTH_SCREEN, 200)];
    editView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:editView];
    
    self.wordView = [[NPYPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, WIDTH_SCREEN - 20, 120)];
    self.wordView.placeholder = @"赶快写点什么吧~~~";
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

// 右栏目按钮点击事件
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    //提交数据到服务器，返回到朋友圈
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
