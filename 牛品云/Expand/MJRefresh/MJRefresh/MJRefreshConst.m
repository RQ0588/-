//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat MJRefreshLabelLeftInset = 25;
const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";

NSString *const MJRefreshHeaderIdleText = @"MJRefreshHeaderIdleText";
NSString *const MJRefreshHeaderPullingText = @"MJRefreshHeaderPullingText";
NSString *const MJRefreshHeaderRefreshingText = @"MJRefreshHeaderRefreshingText";

NSString *const MJRefreshAutoFooterIdleText = @"MJRefreshAutoFooterIdleText";
NSString *const MJRefreshAutoFooterRefreshingText = @"MJRefreshAutoFooterRefreshingText";
NSString *const MJRefreshAutoFooterNoMoreDataText = @"MJRefreshAutoFooterNoMoreDataText";

NSString *const MJRefreshBackFooterIdleText = @"MJRefreshBackFooterIdleText";
NSString *const MJRefreshBackFooterPullingText = @"MJRefreshBackFooterPullingText";
NSString *const MJRefreshBackFooterRefreshingText = @"MJRefreshBackFooterRefreshingText";
NSString *const MJRefreshBackFooterNoMoreDataText = @"MJRefreshBackFooterNoMoreDataText";

NSString *const MJRefreshHeaderLastTimeText = @"MJRefreshHeaderLastTimeText";
NSString *const MJRefreshHeaderDateTodayText = @"MJRefreshHeaderDateTodayText";
NSString *const MJRefreshHeaderNoneLastDateText = @"MJRefreshHeaderNoneLastDateText";

const CGFloat MJRefreshViewHeight = 44.0;//64.0 //BG - 后改 修改时间 : 2016/1/7 14:11
const CGFloat MJRefreshAnimationDuration = 0.25;

NSString *const MJRefreshBundleName = @"MJRefresh.bundle";

NSString *const MJRefreshFooterPullToRefresh = @"上拉可以加载更多数据";
NSString *const MJRefreshFooterReleaseToRefresh = @"松开立即加载更多数据";
NSString *const MJRefreshFooterRefreshing = @"标哥正在帮你加载数据...";

NSString *const MJRefreshHeaderPullToRefresh = @"下拉,返回宝贝详情";
NSString *const MJRefreshHeaderReleaseToRefresh = @"释放,返回宝贝详情";
NSString *const MJRefreshHeaderRefreshing = @"返回";
NSString *const MJRefreshHeaderTimeKey = @"MJRefreshHeaderView";

NSString *const MJRefreshContentOffset = @"contentOffset";
NSString *const MJRefreshContentSize = @"contentSize";
