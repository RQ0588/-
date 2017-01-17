//
//  SDTimeLineTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineTableViewController.h"

#import "SDRefresh.h"

#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"

#import "NPYReleaseViewController.h"

#import "AppDelegate.h"

#import "NPYBaseConstant.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

#define Moments_Url @"/index.php/app/Moments/get"
#define Deleter_Moment_Url @"/index.php/app/Moments/delete"

static CGFloat textFieldH = 40;

@interface SDTimeLineTableViewController () <SDTimeLineCellDelegate, UITextFieldDelegate> {
    UIImageView *headerIcon;
    UILabel     *headerNotic;
    int         noticCount;
    int         refreshNumber;
}

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, copy) NSString *commentToUserName;

@end

@implementation SDTimeLineTableViewController

{
    SDTimeLineRefreshFooter *_refreshFooter;
    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.view.backgroundColor = GRAY_BG;
    
    self.navigationItem.title = @"朋友圈";
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [_textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //LEETheme 分为两种模式 , 独立设置模式 JSON设置模式 , 朋友圈demo展示的是独立设置模式的使用 , 微信聊天demo 展示的是JSON模式的使用
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [rightBtn setTitleColor:XNColor(51, 51, 51, 1) forState:0];
    [rightBtn setTitle:@"发布" forState:0];
    rightBtn.titleLabel.font = XNFont(16.0);
    [rightBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    
//    rightBarButtonItem.lee_theme
//    .LeeAddCustomConfig(DAY , ^(UIBarButtonItem *item){
//        
//        item.title = @"夜间";
//        
//    }).LeeAddCustomConfig(NIGHT , ^(UIBarButtonItem *item){
//        
//        item.title = @"日间";
//    });
    
    //为self.view 添加背景颜色设置
    
//    [self navigationViewLoad];
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);
    
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
//    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
    self.dataArray = [NSMutableArray new];
    
#pragma mark -
    
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    
    NSDictionary *requeatDict = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",@"0",@"num", nil];
    [self requestMomentDataWithUrlString:Moments_Url withParame:requeatDict];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 65)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, WIDTH_SCREEN, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
//    [headView addSubview:bgView];
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH_SCREEN - 126)/2, 15, 126, 31)];
    bgImgView.image = [UIImage imageNamed:@"圆角矩形-1"];
    [bgView addSubview:bgImgView];
    
    headerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(bgImgView.frame)+12, CGRectGetMinY(bgImgView.frame) + 5, 21, 21)];
    headerIcon.layer.cornerRadius = 21/2;
    headerIcon.layer.masksToBounds = YES;
    headerIcon.image = [UIImage imageNamed:@"0.jpg"];
    [bgView addSubview:headerIcon];

    headerNotic = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerIcon.frame)+10, CGRectGetMinY(headerIcon.frame), 75, 21)];
    noticCount = 99;
    headerNotic.text = [NSString stringWithFormat:@"%i条新消息",noticCount];
    headerNotic.textColor = XNColor(51, 51, 51, 1);
    headerNotic.font = XNFont(15.0);
    headerNotic.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:headerNotic];
    
    UIButton *noticBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 60)];
    [noticBtn addTarget:self action:@selector(noticButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:noticBtn];
    
    self.tableView.tableHeaderView = headView;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //添加分隔线颜色设置
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY , [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
    .LeeAddSeparatorColor(NIGHT , [[UIColor grayColor] colorWithAlphaComponent:0.5f]);
    
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
    [self setupTextField];
    
    self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
        NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
        
        NSDictionary *requeatDict = [NSDictionary dictionaryWithObjectsAndKeys:[dic valueForKey:@"sign"],@"sign",model.user_id,@"user_id",@"0",@"num", nil];
        [self requestMomentDataWithUrlString:Moments_Url withParame:requeatDict];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    [_refreshFooter removeFromSuperview];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    
    _textField.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor whiteColor])
    .LeeAddTextColor(DAY , [UIColor blackColor])
    .LeeAddTextColor(NIGHT , [UIColor blackColor])
    .LeeAddCustomConfig(DAY , ^(UITextField *item){
    
        item.keyboardAppearance = UIKeyboardAppearanceDefault;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    }).LeeAddCustomConfig(NIGHT , ^(UITextField *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDark;
        if ([item isFirstResponder]) {
            [item resignFirstResponder];
            [item becomeFirstResponder];
        }
    });
    
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    _textField.backgroundColor = [UIColor whiteColor];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

// 右栏目按钮点击事件

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    
//    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
//        
//        [LEETheme startTheme:NIGHT];
//        
//    } else {
//        [LEETheme startTheme:DAY];
//    }
    //发布按钮
    NSDictionary *dic = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *model = [NPYLoginMode mj_objectWithKeyValues:dic[@"data"]];
    NPYReleaseViewController *releaseVC = [[NPYReleaseViewController alloc] init];
    releaseVC.sign = [dic valueForKey:@"sign"];
    releaseVC.userID = model.user_id;
    [self.navigationController pushViewController:releaseVC animated:YES];
//    [self presentViewController:releaseVC animated:YES completion:nil];
}

- (NSArray *)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        
        
        // 模拟“随机图片”
        int random = arc4random_uniform(6);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
        
        // 模拟随机评论数据
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            commentItemModel.firstUserName = namesArray[index];
            commentItemModel.firstUserId = @"666";
            if (arc4random_uniform(10) < 5) {
                commentItemModel.secondUserName = namesArray[arc4random_uniform((int)namesArray.count)];
                commentItemModel.secondUserId = @"888";
            }
            commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        
        // 模拟随机点赞数据
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            SDTimeLineCellLikeItemModel *model = [SDTimeLineCellLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        
        model.likeItemsArray = [tempLikes copy];
        
        [resArr addObject:model];
    }
    return [resArr copy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, NSString *commentName,CGRect rectInWindow, NSIndexPath *indexPath) {
            weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentName];
            weakSelf.currentEditingIndexthPath = indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            weakSelf.commentToUserName = commentName;
            [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
        }];
        
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
    _textField.placeholder = nil;
}



- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - SDTimeLineCellDelegate

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}

//自己的就删除
- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    //判断是否是删除按钮
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    if ([userModel.user_id isEqualToString:model.user_id]) {
        //删除
        NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",model.moments_id,@"moments_id", nil];
        [self requestDeleteMomentsWithUrlString:Deleter_Moment_Url withParames:request];
        
    } else {
        if (!model.isLiked) {
            SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
            likeModel.userName = model.name;
            likeModel.userId = model.user_id;
            [temp addObject:likeModel];
            model.liked = YES;
        } else {
            SDTimeLineCellLikeItemModel *tempLikeModel = nil;
            for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
                if ([likeModel.userId isEqualToString:model.user_id]) {
                    tempLikeModel = likeModel;
                    break;
                }
            }
            [temp removeObject:tempLikeModel];
            model.liked = NO;
        }
        model.likeItemsArray = [temp copy];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        });
    }
    
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
#pragma mark - 评论
        NSString *urlStr = @"/index.php/app/Moments/reply";
        
        NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
        NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
        
        SDTimeLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        
        if (self.isReplayingComment) {
            commentItemModel.firstUserName = userModel.user_name;
            commentItemModel.firstUserId = userModel.user_id;
            commentItemModel.secondUserName = self.commentToUserName;
            commentItemModel.secondUserId = self.commentToUser;
            commentItemModel.commentString = textField.text;
            
            NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",model.moments_id,@"moments_id",commentItemModel.secondUserId,@"be_user_id",_textField.text,@"text", nil];
            
            [self requestReplyMomentsWithUrlString:urlStr withParames:requestDict];
            
            self.isReplayingComment = NO;
        } else {
            commentItemModel.firstUserName = userModel.user_name;
            commentItemModel.commentString = textField.text;
            commentItemModel.firstUserId = userModel.user_id;
            
            NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",model.moments_id,@"moments_id",model.user_id,@"be_user_id",_textField.text,@"text", nil];
            
            [self requestReplyMomentsWithUrlString:urlStr withParames:requestDict];
        }
        [temp addObject:commentItemModel];
        model.commentItemsArray = [temp copy];
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        _textField.placeholder = nil;

        
        return YES;
    }
    return NO;
}


- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

- (void)bottomViewLoad {
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), 50)];
    bottom.backgroundColor = [UIColor whiteColor];
    bottom.layer.borderColor = [UIColor colorWithRed:226/255.0 green:227/255.0 blue:229/255. alpha:1.0].CGColor;
    bottom.layer.borderWidth = 0.5;
}

- (void)noticButtonPressed:(UIButton *)sender {
    [ZHProgressHUD showMessage:@"查看通知消息" inView:self.tableView];
    
}

- (void)backItem:(UIButton *)sender {
    [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewControllerWithIdentifier:@"NPYMain"];
}

#pragma mark - 

- (void)requestMomentDataWithUrlString:(NSString *)urlStr withParame:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"网络请求成功" inView:self.view];
            NSArray *tpDataArr = [NSArray arrayWithArray:dataDict[@"data"]];
            /*moments_id，朋友圈id  text，朋友圈内容  img1，朋友圈图片  reply_json，该条的评论*/
            [self.dataArray removeAllObjects];
            for (int i = 0; i < tpDataArr.count; i++) {
                NSDictionary *tpDict = tpDataArr[i];
                //发布信息模型
                SDTimeLineCellModel *model = [SDTimeLineCellModel new];
                model.moments_id = [tpDict valueForKey:@"moments_id"];
                model.user_id = [tpDict valueForKey:@"user_id"];
                model.name = [tpDict valueForKey:@"user_name"];
                model.iconName = [tpDict valueForKey:@"user_portrait"];
                model.msgContent = [tpDict valueForKey:@"text"];
                model.picNamesArray = [NSArray arrayWithObjects:[tpDict valueForKey:@"img1"],[tpDict valueForKey:@"img2"],[tpDict valueForKey:@"img3"], nil];
                model.time = [tpDict valueForKey:@"time"];
                
                NSArray *commentArr = [tpDict valueForKey:@"reply_json"];
                NSMutableArray *tempComments = [NSMutableArray new];
                for (int i = 0; i < commentArr.count; i++) {
                    NSDictionary *commentDict = commentArr[i];
                    //评论模型
                    SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
                    commentItemModel.firstUserId = [commentDict valueForKey:@"user_id"];
                    commentItemModel.firstUserName = [commentDict valueForKey:@"user_name"];
                    commentItemModel.commentString = [commentDict valueForKey:@"text"];
                    commentItemModel.secondUserId = [commentDict valueForKey:@"be_user_id"];
                    commentItemModel.secondUserName = [commentDict valueForKey:@"be_user_name"];
                    
                    [tempComments addObject:commentItemModel];
                }
                
                model.commentItemsArray = [tempComments copy];
                
                [self.dataArray addObject:model];
            }
            
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
        } else {
            //请求失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestReplyMomentsWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            [ZHProgressHUD showMessage:@"网络请求成功" inView:self.view];
            
        } else {
            //请求失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestDeleteMomentsWithUrlString:(NSString *)urlStr withParames:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
            [ZHProgressHUD showMessage:@"删除成功" inView:self.view];
            
            [self.tableView.mj_header beginRefreshing];
            
        } else {
            //请求失败
//            [ZHProgressHUD showMessage:dataDict[@"data"] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

@end
