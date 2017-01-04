//
//  RightSlidetableViewCell.m
//  iOS 自定义时间轴
//
//  Created by Apple on 16/7/26.
//  Copyright © 2016年 zls. All rights reserved.
//

#import "RightSlidetableViewCell.h"
#import "CommonDefine.h"
#import "UIView+SDAutoLayout.h"


@interface RightSlidetableViewCell ()
@property (nonatomic, strong) UILabel *verticalLabel1 ;//竖线
@property (nonatomic, strong) UILabel *verticalLabel2 ;//竖线
@property (nonatomic, strong) UILabel *horizontalLabel;//横线
@property (nonatomic, strong) UIButton *circleView; //圈
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *detailLabel; //描述
@property (nonatomic, strong) UILabel *timeLabel; //时间

@end
@implementation RightSlidetableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
//布局
-(void)initView
{
    //竖线
    self.verticalLabel1 = [[UILabel alloc]init];
    self.verticalLabel1.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    [self.contentView addSubview:self.verticalLabel1];
    
    self.verticalLabel2 = [[UILabel alloc]init];
    self.verticalLabel2.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    [self.contentView addSubview:self.verticalLabel2];
    
    //横线
//    self.horizontalLabel = [[UILabel alloc] init];
//    self.horizontalLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
//    [self.contentView addSubview:self.horizontalLabel];
    
    //圆圈
    self.circleView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.circleView.backgroundColor = [UIColor colorWithRed:248/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
    self.circleView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
    self.circleView.layer.cornerRadius = 8;
    self.circleView.layer.borderWidth = 1;
//    [self.circleView setImage:[UIImage imageNamed:@""] forState:0];
    [self.contentView addSubview:self.circleView];
    
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    //时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [self.contentView addSubview:self.timeLabel];
    
    //描述
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textColor = [UIColor colorWithRed:172/255.0 green:173/255.0 blue:174/255.0 alpha:1.0];
    [self.contentView addSubview:self.detailLabel];
    
    //布局
    self.verticalLabel1.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,PADDING_OF_LEFT_STEP_LINE)
    .widthIs(2)
    .heightIs(10);
    
    self.verticalLabel2.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,PADDING_OF_LEFT_STEP_LINE)
    .widthIs(2)
    .bottomEqualToView(self.contentView);
    
    self.circleView.sd_layout
    .centerXEqualToView(self.verticalLabel1)
    .centerYIs(13)
    .heightIs(16)
    .widthIs(16);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.verticalLabel1,PADDING_OF_LEFT_RIGHT)
    .topSpaceToView(self.contentView,3)
    .heightIs(30)
    .widthIs(WIDTH_OF_PROCESS_LABLE);
//    .rightEqualToView(self.contentView);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.titleLabel,9)
    .leftSpaceToView(self.verticalLabel2,PADDING_OF_LEFT_RIGHT)
    .heightIs(11)
    .rightEqualToView(self.contentView);
    
    self.detailLabel.sd_layout
    .topSpaceToView(self.timeLabel,0)
    .leftSpaceToView(self.verticalLabel2,PADDING_OF_LEFT_RIGHT)
    .widthIs(WIDTH_OF_PROCESS_LABLE)
    .heightIs(30);
    
//    self.horizontalLabel.sd_layout
//    .topSpaceToView(self.timeLabel,9)
//    .leftSpaceToView(self.verticalLabel2,PADDING_OF_LEFT_RIGHT)
//    .heightIs(1)
//    .widthIs(WIDTH_OF_PROCESS_LABLE);
}
//赋值
-(void)setModel:(TimeModel *)model
{
    self.titleLabel.text = model.titleStr;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", model.timeStr];
    self.detailLabel.text = model.detailSrtr;
    if (model.isTop) {
        //是开头的不显示最上端的竖线
        self.verticalLabel1.hidden = YES;
        
        self.circleView.sd_layout
        .centerXEqualToView(self.verticalLabel1)
        .centerYIs(13)
        .heightIs(15)
        .widthIs(15);
        self.circleView.backgroundColor = [UIColor colorWithRed:248/255.0 green:31/255.0 blue:31/255.0 alpha:1.0];
        self.circleView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        self.circleView.layer.cornerRadius = 8;
        self.circleView.layer.borderWidth = 1;
        
    } else {
        self.circleView.sd_layout
        .centerXEqualToView(self.verticalLabel1)
        .centerYIs(13)
        .heightIs(10)
        .widthIs(10);
        self.circleView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
        self.circleView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        self.circleView.layer.cornerRadius = 5;
        self.circleView.layer.borderWidth = 1;
    }
    
    if (model.isEnd) {
        //是结尾的不显示最下端的竖线
        self.verticalLabel2.hidden = YES;
    }
    
    if (model.titleStr.length > 1) {
        //描述lab隐藏
        NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        CGSize size1 = CGSizeMake(WIDTH_OF_PROCESS_LABLE,0);
        CGSize titleStrSize = [model.titleStr boundingRectWithSize:size1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading   attributes:fontDic context:nil].size;
        self.titleLabel.sd_layout
        .topSpaceToView(self.contentView,3)
        .leftSpaceToView(self.verticalLabel1,PADDING_OF_LEFT_RIGHT)
        .widthIs(WIDTH_OF_PROCESS_LABLE)
        .heightIs(titleStrSize.height + 12);
    }
    
    if (model.detailSrtr.length > 1) {
        //描述lab隐藏
        NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGSize size1 = CGSizeMake(WIDTH_OF_PROCESS_LABLE,0);
        CGSize detailStrSize = [model.detailSrtr boundingRectWithSize:size1 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading   attributes:fontDic context:nil].size;
        self.detailLabel.sd_layout
        .topSpaceToView(self.timeLabel,5)
        .leftSpaceToView(self.verticalLabel2,PADDING_OF_LEFT_RIGHT)
        .widthIs(WIDTH_OF_PROCESS_LABLE)
        .heightIs(detailStrSize.height + 12);
    }
}

@end
