//
//  BGDetailViewCell.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/2/19.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGDetailViewCell.h"

@interface BGDetailViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *pageCount;


@end

@implementation BGDetailViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setImage:(NSString *)image{
    _image = image;
    //NSLog(@"---> %@",image);
    self.img.image = [UIImage imageNamed:image];
    
}

- (void)setPageString:(NSString *)pageString {
    _pageString = pageString;
    
    self.pageCount.text = self.pageString;
}

@end
