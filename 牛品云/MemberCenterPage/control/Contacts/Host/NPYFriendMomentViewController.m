//
//  NPYFriendMomentViewController.m
//  牛品云
//
//  Created by Eric on 17/1/17.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "NPYFriendMomentViewController.h"
#import "NPYBaseConstant.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;

@interface NPYFriendMomentViewController () <SDTimeLineCellDelegate, UITextFieldDelegate ,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, copy) NSString *commentToUserName;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NPYFriendMomentViewController {
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"hk_dingbu"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = GRAY_BG;
    
    self.navigationItem.title = self.friendName;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [_textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark -
    
    [self.view addSubview:self.mainTableView];
    
    [self setupTextField];
    
    NSDictionary *requeatDict = [NSDictionary dictionaryWithObjectsAndKeys:self.sign,@"sign",self.user_id,@"user_id",self.friends_user_id,@"friends_user_id",@"1",@"num", nil];
    
    [self requestMomentDataWithUrlString:@"/index.php/app/Moments/friends_get" withParame:requeatDict];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
    }
    
    return _mainTableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)dealloc
{
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
    
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    _textField.backgroundColor = [UIColor whiteColor];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
    
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
            [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
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
    _currentEditingIndexthPath = [self.mainTableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}

//自己的就删除
- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.mainTableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    //判断是否是删除按钮
    NSDictionary *userDict = [NPYSaveGlobalVariable readValueFromeLocalWithKey:LoginData_Local];
    NPYLoginMode *userModel = [NPYLoginMode mj_objectWithKeyValues:userDict[@"data"]];
    if ([userModel.user_id isEqualToString:model.user_id]) {
        //删除
        NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:[userDict valueForKey:@"sign"],@"sign",userModel.user_id,@"user_id",model.moments_id,@"moments_id", nil];
        //        [self requestDeleteMomentsWithUrlString:Deleter_Moment_Url withParames:request];
        
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
            [self.mainTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        });
    }
    
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.mainTableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.mainTableView setContentOffset:offset animated:YES];
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
//        SDTimeLineCellModel *model = self.model;
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
        [self.mainTableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        _textField.placeholder = nil;
        
        
        return YES;
    }
    return NO;
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
            //            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

- (void)requestMomentDataWithUrlString:(NSString *)urlStr withParame:(NSDictionary *)parame {
    NSDictionary *paremes = [NSDictionary dictionaryWithObject:[NPYChangeClass dictionaryToJson:parame] forKey:@"data"];
    
    [[NPYHttpRequest sharedInstance] getWithUrlString:[NSString stringWithFormat:@"%@%@",BASE_URL,urlStr] parameters:paremes success:^(id responseObject) {
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dataDict[@"r"] intValue] == 1) {
            //成功
//            moments_id，朋友圈id  text，朋友圈内容  img1，朋友圈图片  reply_json，该条的评论
            NSArray *tpDataArr = dataDict[@"data"];
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

//            [self.tableView.mj_header endRefreshing];
            
            [self.mainTableView reloadData];
            
        } else {
            //请求失败
            //            [ZHProgressHUD showMessage:[NSString stringWithFormat:@"%@",dataDict[@"data"]] inView:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
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
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainTableView.frame), CGRectGetWidth(self.mainTableView.frame), 50)];
    bottom.backgroundColor = [UIColor whiteColor];
    bottom.layer.borderColor = [UIColor colorWithRed:226/255.0 green:227/255.0 blue:229/255. alpha:1.0].CGColor;
    bottom.layer.borderWidth = 0.5;
}

- (void)backItem:(UIButton *)sender {
    //    [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewControllerWithIdentifier:@"NPYMain"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    
    return _dataArray;
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
