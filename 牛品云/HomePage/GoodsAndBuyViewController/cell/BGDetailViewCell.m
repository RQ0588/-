//
//  BGDetailViewCell.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/2/19.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGDetailViewCell.h"
#import "NPYBaseConstant.h"

@interface BGDetailViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *pageCount;


@end

@implementation BGDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setImage:(id)image{
    _image = image;
    //NSLog(@"---> %@",image);
    if ([image isKindOfClass:[UIImage class]]) {
        self.img.image = image;
        
    } else if ([image isKindOfClass:[NSString class]]) {
//        self.img.image = [UIImage imageNamed:image];
        [self.img sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"tiantu_icon"]];
    }
    
}

- (void)setPageString:(NSString *)pageString {
    _pageString = pageString;
    
    self.pageCount.text = self.pageString;
}

@end
