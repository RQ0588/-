//
//  NPYShoppingCarPage.m
//  牛品云
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYShoppingCarPage.h"
#import "NPYBaseConstant.h"

@interface NPYShoppingCarPage () {
   
}

@end

@implementation NPYShoppingCarPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationViewLoad];
    
    
}

- (void)navigationViewLoad {
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = GRAY_BG;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
    UISegmentedControl *SegmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"编辑",
                                             @"消息", nil]];
    [SegmentedControl addTarget:self action:@selector(segmentAction:)
               forControlEvents:UIControlEventValueChanged];
    SegmentedControl.frame = CGRectMake(0, 0, 80, 30);
//    SegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    SegmentedControl.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
    SegmentedControl.momentary = YES;
    SegmentedControl.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1];
    
    SegmentedControl.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName: [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1]};
    [SegmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];//设置文字属性
    
    
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:SegmentedControl];
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(SegmentedControl.frame) / 2)];
    lineImgView.backgroundColor = [UIColor grayColor];
    lineImgView.center = CGPointMake(CGRectGetMidX(SegmentedControl.frame), CGRectGetMidY(SegmentedControl.frame));
    [self.navigationController.navigationBar addSubview:lineImgView];
    
}

- (void)segmentAction:(id)sender
{
    //NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);
    if ([sender selectedSegmentIndex] == 0) {
        NSLog(@"编辑...");
        
    }else if ([sender selectedSegmentIndex] == 1) {
        NSLog(@"消息...");
    }
    
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
