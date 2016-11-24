//
//  ZHActionSheetCell.m
//  ZHAlertView
//
//  Created by 张慧 on 16/11/2.
//  Copyright © 2016年 ZH. All rights reserved.
//

#import "ZHActionSheetCell.h"

@interface ZHActionSheetCell ()
@property (nonatomic , strong) UIImageView *leftView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) ZHActionSheet  *item;

@end
@implementation ZHActionSheetCell
//在initWithStyle中，生成控件，将控件添加到self.contentView中
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _leftView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_leftView];
        [self.contentView addSubview:_titleLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//在layoutSubviews中，设置控件的frame
-(void)layoutSubviews{
    [super layoutSubviews];
    _leftView.frame = CGRectMake(20, (CGRectGetHeight(self.frame)-30)/2, 30, 30);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_leftView.frame)+15, (CGRectGetHeight(self.frame)-20)/2, 150, 20);
    _titleLabel.textColor = [UIColor blueColor];
}

//设置数据
-(void)setData:(ZHActionSheet *)item{
    _item = item;
    _leftView.image = [UIImage imageNamed:item.icon];
    _titleLabel.text = item.title;
}

//设置点击事件
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
