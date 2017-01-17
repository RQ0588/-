//
//  NPYDicMainDetailTableViewCell.h
//  牛品云
//
//  Created by Eric on 16/12/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NPYBaseConstant.h"
#import "NPYDicMainCellModel.h"

@protocol DicMainDetailCellDelegate <NSObject>

- (void)passBuyValueToSuperView:(int)number;

- (void)selectedSportWithIndexPath:(NSIndexPath *)path;

- (void)desSelectSpotWithIndexPath:(NSIndexPath *)path;

- (void)openSubDetailViewWithIndexPath:(NSIndexPath *)path withIsOpen:(BOOL)open;

@end

@interface NPYDicMainDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<DicMainDetailCellDelegate>delegate;

@property (nonatomic, strong) NPYDicMainCellModel *detailModel;

@property (nonatomic, strong) NSIndexPath *path;            //记录第几个cell
@property (nonatomic, assign) int countValue;               //购买的数量
@property (nonatomic, assign) int surplusValue;             //剩余可购买的数量
@property (nonatomic, assign) BOOL isOpen;                  //记录是否展开

@property (weak, nonatomic) IBOutlet UILabel *price;        //显示价格
@property (weak, nonatomic) IBOutlet UILabel *number;       //显示支持者和剩余的数量
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;   //是否支持按钮
@property (weak, nonatomic) IBOutlet UILabel *word;         //主体的内容显示
@property (weak, nonatomic) IBOutlet UILabel *wordDetail;   //配送费一类的
@property (weak, nonatomic) IBOutlet UIButton *openBtn;     //展开按钮
@property (weak, nonatomic) IBOutlet UIImageView *YQGImg;   //已抢光的图片

@property (weak, nonatomic) IBOutlet UIView *selectedView;  //显示加减购买数量的视图
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;      //➖
@property (weak, nonatomic) IBOutlet UILabel *countL;       //显示购买的数量
@property (weak, nonatomic) IBOutlet UIButton *sumBtn;      //➕
@property (weak, nonatomic) IBOutlet UIImageView *sepImg;

- (IBAction)selectedButtonPressed:(id)sender;               //显示购买的视图事件
- (IBAction)openButtonPressed:(id)sender;                   //展开简单介绍视图事件
- (IBAction)cutButtonPressed:(id)sender;                    //➖事件
- (IBAction)sumButtonPressed:(id)sender;                    //➕事件

+ (instancetype)tableViewCellwith:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                           isOpen:(BOOL)open;

@end
