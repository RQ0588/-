//
//  SelctCityView.m
//  自定义城市选择器
//
//  Created by Eric on 2016/10/28.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "SelctCityView.h"

@interface SelctCityView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *provinceTableV;
@property (nonatomic, strong) UITableView *cityTableV;

/** 省 **/
@property (nonatomic, strong) NSArray *provinceArr;
/** 市 **/
@property (strong,nonatomic)NSArray *cityList;

@property (nonatomic, strong) NSString *provinceStr;

@property (nonatomic, copy) MyCitySelectBlock block;

@property (nonatomic, assign) CGSize mySize;

@end

@implementation SelctCityView

-(instancetype)initWithFrame:(CGRect)frame andMyCitySelect:(MyCitySelectBlock)selectCity
{
    if (self = [super initWithFrame:frame]) {
        
        self.block = selectCity;
        
        self.mySize = frame.size;
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        titleLbl.backgroundColor = [UIColor purpleColor];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.text = @"城市";
        titleLbl.textColor = [UIColor whiteColor];
        [self addSubview:titleLbl];
        
        self.provinceTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame), frame.size.width/2, frame.size.height - CGRectGetMaxY(titleLbl.frame)) style:UITableViewStylePlain];
        [self initTableView:self.provinceTableV];
        
        self.cityTableV = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.provinceTableV.frame), self.provinceTableV.frame.origin.y, self.provinceTableV.bounds.size.width, self.provinceTableV.bounds.size.height) style:UITableViewStylePlain];
        [self initTableView:self.cityTableV];
        
        
        [self.provinceTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
        [self.cityTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CityID"];
        //解决cell分割线最左边开始绘制问题
        if ([self.cityTableV respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self.cityTableV setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self.cityTableV respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self.cityTableV setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        if ([self.provinceTableV respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self.provinceTableV setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self.provinceTableV respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self.provinceTableV setLayoutMargins:UIEdgeInsetsZero];
            
        }

        [self achieveCityDatas];
    }
    return self;
}

-(void)initTableView:(UITableView *)tableV
{
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    [self addSubview:tableV];
}

-(void)achieveCityDatas
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSDictionary *provinceLise = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    self.provinceArr = [NSArray array];
    self.provinceArr = provinceLise[@"citylist"];
    

    [self getCityDatas:0];
    self.provinceStr = self.provinceArr[0][@"p"];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.provinceTableV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

-(void)getCityDatas:(NSInteger)num
{
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    for (NSArray *cityArr in self.provinceArr[num][@"c"]) {
        [cityList addObject:cityArr];
    }
    self.cityList = cityList;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.provinceTableV]) {
        return self.provinceArr.count;
    }
    return self.cityList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.provinceTableV]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        cell.textLabel.text = self.provinceArr[indexPath.row][@"p"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityID"];
    cell.textLabel.text = self.cityList[indexPath.row][@"n"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorWithRed:217/256.0 green:217/256.0 blue:217/256.0 alpha:1.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.provinceTableV isEqual:tableView]) {
        
        [self getCityDatas:indexPath.row];
        [self refreshTableView:self.cityTableV];
        
        self.provinceStr = self.provinceArr[indexPath.row][@"p"];
        NSLog(@"%@", self.provinceStr);
        
        
    }
    
    if ([self.cityTableV isEqual:tableView]) {
        NSString *city = self.cityList[indexPath.row][@"n"];
        NSLog(@"self.provinceStr%@--city:%@",self.provinceStr, city);
        
        if (self.block) {
            self.block([NSString stringWithFormat:@"%@%@", self.provinceStr, city]);
            [self removeAnimation];
            
        }
    }
}

-(void)removeAnimation
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//    animation.toValue = @(self.mySize.height);
//    animation.duration = 1.0;
//    animation.fillMode = kCAFillModeBackwards;
//    
//    [self.layer addAnimation:animation forKey:@"animation"];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
    
//    [self performSelector:@selector(removeView) withObject:nil afterDelay:0.5];
}

-(void)removeView
{
    [self removeFromSuperview];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

-(void)refreshTableView:(UITableView *)tableV
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [tableV reloadSections:set withRowAnimation:UITableViewRowAnimationRight];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
