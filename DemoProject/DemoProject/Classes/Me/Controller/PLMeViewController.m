//
//  PLMeViewController.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLMeViewController.h"
#import "PLSquareItem.h"
#import "PLSquareCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <SafariServices/SafariServices.h>

#import "PLSettingViewController.h"
#import "PLLoginRegisterViewController.h"

static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH (PLScreenW - (cols - 1) * margin) / cols

@interface PLMeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *squareItems;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation PLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    // 创建UICollectionView, 设置为tableView底部视图
    [self setupFootView];
    
    // 展示方块内容 -> 请求数据
    [self loadData];
    
    // 处理cell间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = PLMargin;
     // tableView分组样式默认有额外头部高度 (35)
    self.tableView.contentInset = UIEdgeInsetsMake(PLMargin - 35, 0, 0, 0);
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    // 设置按钮
    UIBarButtonItem *settingItem =  [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highlightedImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    // 夜间模式按钮
    UIBarButtonItem *nightItem =  [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, nightItem];
    
    // titleView
    self.navigationItem.title = @"我";
}

- (void)setting {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([PLSettingViewController class]) bundle:nil];
    PLSettingViewController *settingVC = [storyboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)night:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark - 设置底部视图
- (void)setupFootView {
    /*
     1.初始化要设置流水布局
     2.cell必须要注册
     3.cell必须自定义
     */
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell尺寸
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = self.tableView.backgroundColor;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    
    _collectionView = collectionView;
    self.tableView.tableFooterView = collectionView;
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PLSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - 请求数据
- (void)loadData {
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
 
        NSArray *dictArr = responseObject[@"square_list"];
        
        // 字典数组转换成模型数组
        _squareItems = [PLSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        
        // 处理数据
        [self resloveData];
        
        // 计算collectionView高度
        // Rows = (count - 1) / cols + 1
        NSInteger count = _squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        // 设置collectioView高度
        self.collectionView.pl_height = rows * itemWH + (rows - 1) * margin;
        
        // 设置tableView后, tableView的滚动范围会重新计算
        self.tableView.tableFooterView = self.collectionView;
        // 刷新表格
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
    
}
// 处理数据
- (void)resloveData {
    // 判断下缺几个
    // 3 % 4 = 3 cols - 3 = 1
    // 5 % 4 = 1 cols - 1 = 3
    NSInteger count = self.squareItems.count;
    NSInteger extra = count % cols;
    if (extra) {
        extra = cols - extra;
        for (int i = 0; i < extra; i++) {
            PLSquareItem *item = [[PLSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从缓存池取
    PLSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转界面展示网页
    // SFSafariViewController:专门用来展示网页 需求:即想要在当前应用展示网页,又想要safari功能 iOS9才能使用
    PLSquareItem *item = self.squareItems[indexPath.row];
    if (![item.url containsString:@"http"]) return;
    
    // SFSafariViewController使用Modal
    NSURL *url = [NSURL URLWithString:item.url];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];

    [self presentViewController:safariVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
  
        PLLoginRegisterViewController *loginRegisterVC = [[PLLoginRegisterViewController alloc] init];
        
        [self presentViewController:loginRegisterVC animated:YES completion:nil];
    
    }
}

@end
