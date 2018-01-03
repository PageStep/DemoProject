//
//  PLPostViewController.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLPostViewController.h"
#import "PLPostItem.h"
#import "PLPostCell.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface PLPostViewController ()

/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray<PLPostItem *> *postItems;
/** 当前最后一条帖子数据的描述信息，专门用来加载更多数据(下一页数据) */
@property (nonatomic, copy) NSString *maxtime;
/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation PLPostViewController

/** 在这里实现type方法，仅仅是为了消除警告 */
- (PLPostType)type {return 0;}

/* cell的重用标识 */
static NSString * const PLPostCellId = @"PLPostCellId";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = PLGrayColor(206);
    
    // 设置tableView.contentInset, 使cell可以下拉或上拉至设置的位置, 而不被导航栏或tabBar挡住
    self.tableView.contentInset = UIEdgeInsetsMake(PLNavMaxY + PLTitlesViewH, 0, PLTabBarH, 0);
    // 设置tableView滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PLPostCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:PLPostCellId];
    
    // 添加observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:PLTitleButtonDidRepeatClickNotification object:nil];
    
    [self setupRefreshView];
}

- (void)dealloc
{
    // 移除observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefreshView {
    // 广告条
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    
    // 自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 让header自动进入刷新
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark - 监听
// 监听titleButton的重复点击
- (void)titleButtonDidRepeatClick {
    // 如果正在显示的是当前tableView
    if (self.tableView.scrollsToTop == YES) {
        // 进入下拉刷新
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或者隐藏footer
    self.tableView.mj_footer.hidden = (self.postItems.count == 0);
    
    return self.postItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLPostCell *cell = [tableView dequeueReusableCellWithIdentifier:PLPostCellId];
    
    cell.item = self.postItems[indexPath.row];;
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.postItems[indexPath.row].cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
}



#pragma mark - 数据处理
// 发送请求给服务器 (下拉刷新数据)
- (void)loadNewTopics {
    //    // 1.创建请求会话管理者
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type); // 这里传@1也是可行的
    
    // 3.发送请求
    [self.manager GET:PLCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* _Nullable responseObject) {
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        self.postItems = [PLPostItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

// 发送请求给服务器(上拉加载更多数据)
- (void)loadMoreTopics {
    //    // 1.创建请求会话管理者
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type); // 这里传@1也是可行的
    if (self.maxtime) {
        parameters[@"maxtime"] = self.maxtime;
    }
    
    // 3.发送请求
    [self.manager GET:PLCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSArray *morePosts = [PLPostItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.postItems addObjectsFromArray:morePosts];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    }];
}
@end
