//
//  PLFollowViewController.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLFollowViewController.h"
#import "PLSubTagViewController.h"
#import "PLLoginRegisterViewController.h"

@interface PLFollowViewController ()

@end

@implementation PLFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommendIcon"] highlightedImage:[UIImage imageNamed:@"friendsRecommendIcon-click"] target:self action:@selector(friendsRecommend)];
    
    // titleView
    self.navigationItem.title = @"我的关注";
}

// 推荐关注
- (void)friendsRecommend
{
    // 进入推荐标签界面
    PLSubTagViewController *subTag = [[PLSubTagViewController alloc] init];
    
    [self.navigationController pushViewController:subTag animated:YES];
}

- (IBAction)clickLoginRegister {
    // 进入到登录注册界面
    PLLoginRegisterViewController *loginVC = [[PLLoginRegisterViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
