//
//  AppDelegate.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "AppDelegate.h"
#import "PLAdViewController.h"
#import "PLTabBarController.h"
#import <AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //    self.window.rootViewController = [[PLAdViewController alloc] init];
    self.window.rootViewController = [[PLTabBarController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    // 开始监控网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    return YES;
}


@end
