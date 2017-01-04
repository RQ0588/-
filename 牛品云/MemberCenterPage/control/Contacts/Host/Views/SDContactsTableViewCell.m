//
//  SDContactsTableViewCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/3/3.
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

#import "SDContactsTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDContactModel.h"
#import "NPYBaseConstant.h"

@implementation SDContactsTableViewCell
{
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = 375;
    [super setFrame:frame];
}

- (void)setupView
{
    _iconImageView = [UIImageView new];
    _iconImageView.layer.cornerRadius = 5;
//    _iconImageView.layer.borderWidth = 0.5;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    _nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:_nameLabel];
    
    
    CGFloat margin = 14;
    
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(36)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(30);
    
}

- (void)setModel:(SDContactModel *)model
{
    _model = model;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (model.imageName) {
         _iconImageView.image = [UIImage imageNamed:model.imageName];
        
    }
   
    if (model.firend_img) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.firend_img] placeholderImage:[UIImage new]];
    }
    
}

+ (CGFloat)fixedHeight
{
    return 56;
}

@end
