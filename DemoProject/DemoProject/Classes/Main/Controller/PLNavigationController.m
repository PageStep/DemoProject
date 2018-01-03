//
//  PLNavigationController.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLNavigationController.h"

@interface PLNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation PLNavigationController

+(void)load {
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 设置navBar的标题字体大小
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attr];
    
    // 设置navBar的背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 利用系统自带的方法创建滑动返回手势 (pan手势是全屏作用的)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
    
    // 禁止系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate
// 非根控制器触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}
// 非根控制器设置返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        
        // 设置返回按钮 (非根控制器)
        // 把系统的返回按钮覆盖后, 系统滑动返回手势失效 (手势代理做了一些事情)
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highlightedImage:[UIImage imageNamed:@"navigationButtonReturnClick"]  target:self action:@selector(back) title:@"返回"];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 跳转
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


@end
