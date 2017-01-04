//
//  NPYSupportViewController.m
//  牛品云
//
//  Created by Eric on 16/12/6.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "NPYSupportViewController.h"
#import "NPYSupporTopTableViewCell.h"
#import "NPYSupporMidTableViewCell.h"
#import "NPYBaseConstant.h"
#import "NPYAddressViewController.h"

@interface NPYSupportViewController () <UITableViewDelegate,UITableViewDataSource> {
    UILabel *freightL;      //运费
}

@property (nonatomic, strong) NPYSupporTopTableViewCell *topCell;
@property (nonatomic, strong) NPYSupporMidTableViewCell *midCell;
@property (nonatomic, strong) NPYAddressViewController  *addressVC;

@end

static NSString *topCell = @"NPYSupporTopTableViewCell";
static NSString *midCell = @"NPYSupporMidTableViewCell";

@implementation NPYSupportViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self navigationViewLoad];
    
    [self addMainViewToSelf];
}

- (void)navigationViewLoad {
    self.navigationItem.title = @"我要支持";
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [backBtn setImage:[UIImage imageNamed:@"icon_fanhui"] forState:0];
    [backBtn addTarget:self action:@selector(backItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;

}

- (void)addMainViewToSelf {
    self.mainTableView.estimatedRowHeight = 100;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.backgroundColor = GRAY_BG;
    
    self.mainTableView.separatorColor = GRAY_BG;
    
    self.mainTableView.tableFooterView = [UIView new];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:topCell bundle:nil] forCellReuseIdentifier:topCell];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:midCell bundle:nil] forCellReuseIdentifier:midCell];
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.topCell = [tableView dequeueReusableCellWithIdentifier:topCell];
        self.topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.topCell;
        
    } else if (indexPath.section == 1) {
        self.midCell = [tableView dequeueReusableCellWithIdentifier:midCell forIndexPath:indexPath];
        [self configCell:self.midCell indexPath:indexPath];
        return self.midCell;
        
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"threeCell"];
            cell.textLabel.text = @"运费";
            cell.textLabel.font = XNFont(14.0);
            cell.textLabel.textColor = XNColor(17, 17, 17, 1);
            
            freightL = [[UILabel alloc] init];
            freightL.frame = CGRectMake(WIDTH_SCREEN - 140, 10, 100, 30);
            freightL.textColor = XNColor(170, 170, 170, 1);
            freightL.font = XNFont(16.0);
            freightL.text = @"免邮";
            freightL.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:freightL];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)configCell:(NPYSupporMidTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.addressVC = [[NPYAddressViewController alloc] init];
//        self.addressVC.delegate = self;
        [self.navigationController pushViewController:self.addressVC animated:YES];
        
    }
}

- (void)backItem:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
