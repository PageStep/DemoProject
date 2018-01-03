//
//  PLSubTagViewController.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLSubTagViewController.h"
#import "PLSubTagItem.h"
#import "PLSubTagCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const ID = @"cell";

@interface PLSubTagViewController ()

@property (nonatomic, strong) NSArray *subTagItems;
@property (nonatomic, weak) AFHTTPSessionManager *mgr;

@end

@implementation PLSubTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐标签";
    
    // 请求数据(接口文档)  -> 解析数据(写成plist文件) -> 设计模型 -> 字典转模型 -> 展示数据
    // 接口文档查看内容: 1.请求方式 2.请求的基本url+请求参数
    [self loadData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PLSubTagCell" bundle:nil] forCellReuseIdentifier:ID];
    
    /*
     处理cell分割线
     >第一种方式, 自定义分割线
     >1.取消系统自带分割线
     >2.在cell的awakeFromNib方法中, 添加一个与contentView等宽, 高度为1的子控件view, 减少view的透明度值可以让分隔线看起来更自然
     
     >第二种方式, 设置系统属性
     >清空tableView分割线内边距 (iOS7只设置此项即可)
     self.tableView.separatorInset = UIEdgeInsetsZero;
     >iOS8, 还需要清空cell的约束边缘
     在cell的awakeFromNib方法中设置self.layoutMargins = UIEdgeInsetsZero;
     
     >第三种方式, 万能方式
     >1.取消系统自带分割线
     >2.把tableView背景色设置为分割线的背景色
     >3.在cell中重写setFrame
     
     */
    // 处理cell分割线, 第三种方式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = PLColor(220, 220, 221);
    
    // 提示用户当前正在加载数据
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
}

// 界面即将消失时, 销毁指示器, 取消请求
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 销毁指示器
    [SVProgressHUD dismiss];
    
    // 取消之前的请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 请求数据
- (void)loadData
{
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        // 销毁指示器
        [SVProgressHUD dismiss];
        
        //        NSLog(@"%@",responseObject);
        //        XMGAFNWriteToPlist(subTag);
        // 字典数组转换模型数组
        _subTagItems = [PLSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 销毁指示器
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTagItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    // 自定义cell
    PLSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 获取模型
    PLSubTagItem *item = self.subTagItems[indexPath.row];
    // 设置数据
    cell.item = item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
