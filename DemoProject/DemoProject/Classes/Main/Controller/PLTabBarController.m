//
//  PLTabBarController.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLTabBarController.h"
#import "PLNavigationController.h"
#import "PLEssenceViewController.h"
#import "PLFollowViewController.h"
#import "PLMeViewController.h"

@interface PLTabBarController ()

@end

@implementation PLTabBarController

// 对本身的初始化操作
+ (void)load {
    
    // appearance只能在控件显示之前设置才有作用
    UITabBarItem* item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 设置tabBarItem字体大小
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    // 设置tabBarItem字体颜色
    NSMutableDictionary *attr1 = [NSMutableDictionary dictionary];
    attr1[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attr1 forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVC];
    
    [self setupTabBar];
    
}

- (void)setupChildVC {
    
    PLEssenceViewController *essenceVC = [[PLEssenceViewController alloc] init];
    PLNavigationController *nav = [[PLNavigationController alloc] initWithRootViewController:essenceVC];
    [self addChildViewController:nav];
    
    
    
    PLFollowViewController *followVC = [[PLFollowViewController alloc] init];
    PLNavigationController *nav1 = [[PLNavigationController alloc] initWithRootViewController:followVC];
    [self addChildViewController:nav1];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([PLMeViewController class]) bundle:nil];
    PLMeViewController *meVC = [storyboard instantiateInitialViewController];
    PLNavigationController *nav2 = [[PLNavigationController alloc] initWithRootViewController:meVC];
    [self addChildViewController:nav2];
}

- (void)setupTabBar {
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"主页";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav.tabBarItem.selectedImage = [UIImage  pl_originalImageWithName:@"tabBar_essence_click_icon"];
    
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"关注";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav1.tabBarItem.selectedImage = [UIImage pl_originalImageWithName:@"tabBar_friendTrends_click_icon"];
    
    UINavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"我";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav2.tabBarItem.selectedImage = [UIImage  pl_originalImageWithName:@"tabBar_me_click_icon"];
}

@end

